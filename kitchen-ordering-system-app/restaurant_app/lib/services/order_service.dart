import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../models.dart';
import '../../services/table_service.dart';

class OrderService extends ChangeNotifier {
  final String orderUrl = 'http://10.0.2.2:3000/api/orders';
  List<Order> _orders = [];
  
  // Current cart items for the active table
  final Map<String, Map<String, OrderItem>> _activeOrders = {};

  List<Order> get orders => _orders;
  
  // Raporlama verileri
  Map<String, dynamic> _reportSummary = {
    'totalOrders': 0,
    'paidOrders': 0,
    'pendingOrders': 0,
    'totalRevenue': 0.0,
    'popularItems': []
  };

  Map<String, dynamic> _dailyReport = {
    'dailyOrders': 0,
    'dailyRevenue': 0.0,
    'paymentMethods': []
  };

  Map<String, dynamic> get reportSummary => _reportSummary;
  Map<String, dynamic> get dailyReport => _dailyReport;

  // Siparişleri backend'den çek
  Future<void> fetchOrders() async {
    final response = await http.get(Uri.parse(orderUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      _orders = data.map((item) => Order.fromJson(item)).toList();
      notifyListeners();
    } else {
      throw Exception('Siparişler alınamadı');
    }
  }

  // Mutfak siparişlerini çek
  Future<void> fetchKitchenOrders() async {
    final response = await http.get(Uri.parse('$orderUrl/kitchen'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      _orders = data.map((item) => Order.fromJson(item)).toList();
      notifyListeners();
    } else {
      throw Exception('Mutfak siparişleri alınamadı');
    }
  }

  // Get cart for a specific table
  Map<String, OrderItem> getCartForTable(String tableId) {
    return _activeOrders[tableId] ?? {};
  }

  // Get all active kitchen orders
  List<Order> getKitchenOrders() {
    return _orders.where((order) => order.items.any((item) => 
      item.status == OrderStatus.pending || 
      item.status == OrderStatus.preparing)).toList();
  }

  // Add item to cart
  void addToCart(String tableId, MenuItem menuItem, int quantity, {String? specialInstructions}) {
    if (!_activeOrders.containsKey(tableId)) {
      _activeOrders[tableId] = {};
    }
    
    final existingItem = _activeOrders[tableId]![menuItem.id];
    
    if (existingItem != null) {
      existingItem.quantity += quantity;
    } else {
      _activeOrders[tableId]![menuItem.id] = OrderItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        menuItem: menuItem,
        quantity: quantity,
        specialInstructions: specialInstructions,
      );
    }
    
    notifyListeners();
  }

  // Update cart item quantity
  void updateCartItemQuantity(String tableId, String menuItemId, int quantity) {
    if (_activeOrders.containsKey(tableId) && 
        _activeOrders[tableId]!.containsKey(menuItemId)) {
      if (quantity <= 0) {
        _activeOrders[tableId]!.remove(menuItemId);
      } else {
        _activeOrders[tableId]![menuItemId]!.quantity = quantity;
      }
      notifyListeners();
    }
  }

  // Remove item from cart
  void removeFromCart(String tableId, String menuItemId) {
    if (_activeOrders.containsKey(tableId)) {
      _activeOrders[tableId]!.remove(menuItemId);
      notifyListeners();
    }
  }

  // Clear entire cart for a table
  void clearCart(String tableId) {
    if (_activeOrders.containsKey(tableId)) {
      _activeOrders[tableId]!.clear();
      notifyListeners();
    }
  }

  // Siparişi backend'e gönder
  Future<void> submitOrder(String tableId, TableService tableService) async {
    final cartItems = _activeOrders[tableId];
    if (cartItems == null || cartItems.isEmpty) return;
    
    // Toplam tutarı hesapla
    final totalAmount = cartItems.values.fold(0.0, (sum, item) => sum + item.totalPrice);
    
    final items = cartItems.values.map((item) => {
      'menuItem': item.menuItem.id,
      'quantity': item.quantity,
      'specialInstructions': item.specialInstructions
    }).toList();
    
    final requestBody = {
      'tableId': tableId,
      'items': items,
      'totalAmount': totalAmount
    };
    
    print('Gönderilen sipariş verisi: ${json.encode(requestBody)}');
    
    try {
      final response = await http.post(
        Uri.parse(orderUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );
      
      print('Backend yanıt kodu: ${response.statusCode}');
      print('Backend yanıtı: ${response.body}');
      
      if (response.statusCode == 201) {
        // Masa durumunu occupied yap
        await tableService.updateTableStatus(tableId, TableStatus.occupied);
        _activeOrders[tableId] = {}; // Sepeti temizle
        await fetchOrders();
      } else {
        throw Exception('Sipariş gönderilemedi: ${response.body}');
      }
    } catch (e) {
      print('Sipariş gönderme hatası: $e');
      rethrow;
    }
  }

  // Sipariş durumu güncelle
  Future<void> updateOrderItemStatus(String orderId, String orderItemId, OrderStatus status) async {
    final response = await http.patch(
      Uri.parse('$orderUrl/$orderId/status'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'itemId': orderItemId, 'status': status.name}),
    );
    if (response.statusCode == 200) {
      await fetchOrders();
    } else {
      throw Exception('Sipariş durumu güncellenemedi');
    }
  }

  // Siparişi ödenmiş olarak işaretle
  Future<void> markOrderAsPaid(String orderId, String paymentMethod, TableService tableService) async {
    final response = await http.patch(
      Uri.parse('$orderUrl/$orderId/payment'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'paymentMethod': paymentMethod}),
    );
    if (response.statusCode == 200) {
      await fetchOrders();
      await tableService.fetchTables(); // Masaları da güncelle
    } else {
      throw Exception('Ödeme işlemi başarısız');
    }
  }

  // Get all orders for a specific table
  List<Order> getOrdersForTable(String tableId) {
    return _orders.where((order) {
      // order.tableId hem string hem de obje id olabilir
      return order.tableId == tableId ||
          order.tableId.toString() == tableId.toString();
    }).toList();
  }

  // Get total amount due for a table (all unpaid orders)
  double getTotalAmountForTable(String tableId) {
    final tableOrders = getOrdersForTable(tableId);
    return tableOrders
        .where((order) => !order.isPaid)
        .fold(0, (sum, order) => sum + order.totalAmount);
  }

  // Raporlama verilerini güncelle
  Future<void> fetchReportSummary() async {
    try {
      final response = await http.get(Uri.parse('$orderUrl/reports/summary'));
      if (response.statusCode == 200) {
        _reportSummary = json.decode(response.body);
        notifyListeners();
      } else {
        throw Exception('Raporlama verileri alınamadı');
      }
    } catch (e) {
      print('Raporlama verileri alınırken hata: $e');
      rethrow;
    }
  }

  Future<void> fetchDailyReport() async {
    try {
      final response = await http.get(Uri.parse('$orderUrl/reports/daily'));
      if (response.statusCode == 200) {
        _dailyReport = json.decode(response.body);
        notifyListeners();
      } else {
        throw Exception('Günlük rapor verileri alınamadı');
      }
    } catch (e) {
      print('Günlük rapor verileri alınırken hata: $e');
      rethrow;
    }
  }

  // Sistemi sıfırla
  Future<void> resetSystem() async {
    try {
      final response = await http.post(
        Uri.parse('$orderUrl/reset-system'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        // Tüm yerel verileri sıfırla
        _orders = [];
        _activeOrders.clear();
        _reportSummary = {
          'totalOrders': 0,
          'paidOrders': 0,
          'pendingOrders': 0,
          'totalRevenue': 0.0,
          'popularItems': []
        };
        _dailyReport = {
          'dailyOrders': 0,
          'dailyRevenue': 0.0,
          'paymentMethods': []
        };
        notifyListeners();
      } else {
        throw Exception('Sistem sıfırlanamadı: ${response.body}');
      }
    } catch (e) {
      print('Sistem sıfırlama hatası: $e');
      rethrow;
    }
  }
}
