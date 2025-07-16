import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../models.dart';

class TableService extends ChangeNotifier {
  final String tableUrl = 'http://10.0.2.2:3000/api/tables';
  final String staffUrl = 'http://10.0.2.2:3000/api/staff';
  List<RestaurantTable> _tables = [];
  List<Staff> _staff = [];

  List<RestaurantTable> get tables => _tables;
  List<Staff> get staff => _staff;

  Future<void> fetchTables() async {
    final response = await http.get(Uri.parse(tableUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      _tables = data.map((item) => RestaurantTable.fromJson(item)).toList();
      notifyListeners();
    } else {
      throw Exception('Masa verileri alınamadı');
    }
  }

  Future<void> fetchStaff() async {
    final response = await http.get(Uri.parse(staffUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      _staff = data.map((item) => Staff.fromJson(item)).toList();
      notifyListeners();
    } else {
      throw Exception('Personel verileri alınamadı');
    }
  }

  Future<void> updateTableStatus(String tableId, TableStatus status) async {
    final body = <String, dynamic>{'status': status.name};
    if (status != TableStatus.occupied) {
      body['serverId'] = null;
    }
    final response = await http.patch(
      Uri.parse('$tableUrl/$tableId/status'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );
    if (response.statusCode == 200) {
      await fetchTables();
    } else {
      throw Exception('Masa durumu güncellenemedi');
    }
  }

  Future<void> assignServerToTable(String tableId, String serverId) async {
    final response = await http.patch(
      Uri.parse('$tableUrl/$tableId/assign'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'serverId': serverId}),
    );
    if (response.statusCode == 200) {
      await fetchTables();
    } else {
      throw Exception('Garson ataması başarısız');
    }
  }

  RestaurantTable? getTableById(String id) {
    try {
      return _tables.firstWhere((table) => table.id == id);
    } catch (e) {
      return null;
    }
  }

  Staff? getStaffById(String id) {
    try {
      return _staff.firstWhere((member) => member.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Staff> getWaiters() {
    return _staff.where((member) => member.role == 'waiter').toList();
  }
}
