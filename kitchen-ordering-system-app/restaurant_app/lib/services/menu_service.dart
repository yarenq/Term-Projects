import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../models.dart';

// This service handles menu related operations
class MenuService extends ChangeNotifier {
  final String baseUrl = 'http://10.0.2.2:3000/api/menu';
  List<MenuItem> _menuItems = [];

  List<MenuItem> get menuItems => _menuItems;

  Future<void> fetchMenuItems() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      _menuItems = data.map((item) => MenuItem.fromJson(item)).toList();
      notifyListeners();
    } else {
      throw Exception('Menü verileri alınamadı');
    }
  }

  Future<void> addMenuItem(MenuItem item) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(item.toJson()),
    );
    if (response.statusCode == 201) {
      await fetchMenuItems();
    } else {
      throw Exception('Menü öğesi eklenemedi');
    }
  }

  Future<void> updateMenuItem(MenuItem updatedItem) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${updatedItem.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updatedItem.toJson()),
    );
    if (response.statusCode == 200) {
      await fetchMenuItems();
    } else {
      throw Exception('Menü öğesi güncellenemedi');
    }
  }

  Future<void> deleteMenuItem(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      await fetchMenuItems();
    } else {
      throw Exception('Menü öğesi silinemedi');
    }
  }

  List<String> get categories {
    return _menuItems.map((item) => item.category).toSet().toList()..sort();
  }

  List<MenuItem> getItemsByCategory(String category) {
    return _menuItems.where((item) => item.category == category).toList();
  }

  MenuItem getItemById(String id) {
    return _menuItems.firstWhere((item) => item.id == id);
  }
}
