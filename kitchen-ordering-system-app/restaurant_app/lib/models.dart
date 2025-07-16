// models.dart - Contains all data models for the application

class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageUrl;
  final bool isAvailable;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    this.imageUrl = '',
    this.isAvailable = true,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] is int) ? (json['price'] as int).toDouble() : (json['price'] ?? 0.0),
      category: json['category'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      isAvailable: json['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'imageUrl': imageUrl,
      'isAvailable': isAvailable,
    };
  }
}

enum OrderStatus { pending, preparing, ready, served, cancelled }

OrderStatus orderStatusFromString(String status) {
  switch (status) {
    case 'pending':
      return OrderStatus.pending;
    case 'preparing':
      return OrderStatus.preparing;
    case 'ready':
      return OrderStatus.ready;
    case 'served':
      return OrderStatus.served;
    case 'cancelled':
      return OrderStatus.cancelled;
    default:
      return OrderStatus.pending;
  }
}

String orderStatusToString(OrderStatus status) {
  return status.toString().split('.').last;
}

class OrderItem {
  final String id;
  final MenuItem menuItem;
  int quantity;
  String? specialInstructions;
  OrderStatus status;

  OrderItem({
    required this.id,
    required this.menuItem,
    required this.quantity,
    this.specialInstructions,
    this.status = OrderStatus.pending,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    MenuItem menuItem;
    if (json['menuItem'] == null) {
      menuItem = MenuItem(
        id: json['_id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: json['name'] ?? 'Bilinmeyen Ürün',
        description: json['description'] ?? '',
        price: (json['price'] ?? 0.0).toDouble(),
        category: json['category'] ?? 'Diğer',
      );
    } else if (json['menuItem'] is Map) {
      menuItem = MenuItem.fromJson(json['menuItem']);
    } else {
      menuItem = MenuItem(
        id: json['menuItem'].toString(),
        name: json['name'] ?? 'Bilinmeyen Ürün',
        description: json['description'] ?? '',
        price: (json['price'] ?? 0.0).toDouble(),
        category: json['category'] ?? 'Diğer',
      );
    }

    return OrderItem(
      id: json['_id'] ?? json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      menuItem: menuItem,
      quantity: json['quantity'] ?? 1,
      specialInstructions: json['specialInstructions'],
      status: json['status'] is String ? orderStatusFromString(json['status']) : OrderStatus.pending,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menuItem': menuItem.id,
      'quantity': quantity,
      'specialInstructions': specialInstructions,
      'status': orderStatusToString(status),
    };
  }

  double get totalPrice => menuItem.price * quantity;
}

class Order {
  final String id;
  final String tableId;
  final List<OrderItem> items;
  final DateTime createdAt;
  bool isPaid;
  String? paymentMethod;

  Order({
    required this.id,
    required this.tableId,
    required this.items,
    required this.createdAt,
    this.isPaid = false,
    this.paymentMethod,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    String? tableId;
    if (json['tableId'] != null) {
      if (json['tableId'] is Map) {
        tableId = json['tableId']['_id'] ?? json['tableId']['id'];
      } else {
        tableId = json['tableId'].toString();
      }
    }
    
    return Order(
      id: json['_id'] ?? json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      tableId: tableId ?? 'unknown_table',
      items: (json['items'] as List? ?? []).map((item) => OrderItem.fromJson(item)).toList(),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      isPaid: json['isPaid'] ?? false,
      paymentMethod: json['paymentMethod'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tableId': tableId,
      'items': items.map((item) => item.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'isPaid': isPaid,
      'paymentMethod': paymentMethod,
    };
  }

  double get totalAmount => items.fold(0, (sum, item) => sum + item.totalPrice);
}

enum TableStatus { available, occupied, reserved, outOfService }

TableStatus tableStatusFromString(String status) {
  switch (status) {
    case 'available':
      return TableStatus.available;
    case 'occupied':
      return TableStatus.occupied;
    case 'reserved':
      return TableStatus.reserved;
    case 'outOfService':
      return TableStatus.outOfService;
    default:
      return TableStatus.available;
  }
}

String tableStatusToString(TableStatus status) {
  return status.toString().split('.').last;
}

class RestaurantTable {
  final String id;
  final String name;
  final int capacity;
  final int x;
  final int y;
  TableStatus status;
  String? serverId;
  List<Order> orders;

  RestaurantTable({
    required this.id,
    required this.name,
    required this.capacity,
    required this.x,
    required this.y,
    this.status = TableStatus.available,
    this.serverId,
    this.orders = const [],
  });

  factory RestaurantTable.fromJson(Map<String, dynamic> json) {
    return RestaurantTable(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      capacity: json['capacity'],
      x: json['x'],
      y: json['y'],
      status: json['status'] is String ? tableStatusFromString(json['status']) : TableStatus.available,
      serverId: json['serverId'] is Map ? (json['serverId']['_id'] ?? json['serverId']['id']) : json['serverId'],
      orders: json['orders'] != null ? (json['orders'] as List).map((o) => Order.fromJson(o)).toList() : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'capacity': capacity,
      'x': x,
      'y': y,
      'status': tableStatusToString(status),
      'serverId': serverId,
      'orders': orders.map((o) => o.toJson()).toList(),
    };
  }

  bool get hasActiveOrders => orders.any((order) => !order.isPaid);
}

class Staff {
  final String id;
  final String name;
  final String role; // 'waiter', 'chef', 'manager', etc.
  
  Staff({
    required this.id,
    required this.name,
    required this.role,
  });

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'role': role,
    };
  }
}
