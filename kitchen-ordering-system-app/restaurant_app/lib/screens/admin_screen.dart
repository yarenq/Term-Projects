import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models.dart';
import '../../services/menu_service.dart';
import '../../services/order_service.dart';
import '../../services/table_service.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    Future.microtask(() {
      Provider.of<MenuService>(context, listen: false).fetchMenuItems();
      Provider.of<TableService>(context, listen: false).fetchTables();
      Provider.of<TableService>(context, listen: false).fetchStaff();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        backgroundColor: Colors.orangeAccent,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white, // Seçili tab'ın rengi
          //unselectedLabelColor: Colors.white70, // Seçili olmayan tab'ların rengi
          tabs: const [
            Tab(icon: Icon(Icons.restaurant_menu), text: 'Menu'),
            Tab(icon: Icon(Icons.inventory), text: 'Inventory'),
            Tab(icon: Icon(Icons.assessment), text: 'Reports'),
            Tab(icon: Icon(Icons.people), text: 'Staff'),
            Tab(icon: Icon(Icons.settings), text: 'Settings'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          MenuManagementTab(),
          InventoryManagementTab(),
          ReportsTab(),
          StaffManagementTab(),
          SettingsTab(),
        ],
      ),
    );
  }
}

class MenuManagementTab extends StatelessWidget {
  const MenuManagementTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MenuService>(
      builder: (context, menuService, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Menu Items',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showAddMenuItemDialog(context, menuService),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Item'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: menuService.menuItems.length,
                  itemBuilder: (context, index) {
                    final item = menuService.menuItems[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          child: Text(
                            item.category[0].toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(item.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.description),
                            const SizedBox(height: 4),
                            Text(
                              'Category: ${item.category} • \$${item.price.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit),
                                  SizedBox(width: 8),
                                  Text('Edit'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Delete', style: TextStyle(color: Colors.red)),
                                ],
                              ),
                            ),
                          ],
                          onSelected: (value) {
                            if (value == 'edit') {
                              _showEditMenuItemDialog(context, menuService, item);
                            } else if (value == 'delete') {
                              _showDeleteConfirmation(context, menuService, item);
                            }
                          },
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddMenuItemDialog(BuildContext context, MenuService menuService) {
    _showMenuItemDialog(context, menuService, null);
  }

  void _showEditMenuItemDialog(BuildContext context, MenuService menuService, MenuItem item) {
    _showMenuItemDialog(context, menuService, item);
  }

  void _showMenuItemDialog(BuildContext context, MenuService menuService, MenuItem? existingItem) {
    final nameController = TextEditingController(text: existingItem?.name ?? '');
    final descriptionController = TextEditingController(text: existingItem?.description ?? '');
    final priceController = TextEditingController(text: existingItem?.price.toString() ?? '');
    String selectedCategory = existingItem?.category ?? 'Ana Yemek';

    final categories = ['Ana Yemek', 'Çorba', 'Salata', 'Tatlı', 'İçecek'];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(existingItem == null ? 'Add Menu Item' : 'Edit Menu Item'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: priceController,
                      decoration: const InputDecoration(
                        labelText: 'Price',
                        border: OutlineInputBorder(),
                        prefixText: '\$',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      items: categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty &&
                        descriptionController.text.isNotEmpty &&
                        priceController.text.isNotEmpty) {
                      final price = double.tryParse(priceController.text);
                      if (price != null) {
                        final newItem = MenuItem(
                          id: existingItem?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                          name: nameController.text,
                          description: descriptionController.text,
                          price: price,
                          category: selectedCategory,
                        );

                        if (existingItem == null) {
                          menuService.addMenuItem(newItem);
                        } else {
                          menuService.updateMenuItem(newItem);
                        }

                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(existingItem == null 
                                ? 'Menu item added successfully' 
                                : 'Menu item updated successfully'),
                          ),
                        );
                      }
                    }
                  },
                  child: Text(existingItem == null ? 'Add' : 'Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, MenuService menuService, MenuItem item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Menu Item'),
          content: Text('Are you sure you want to delete "${item.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                menuService.deleteMenuItem(item.id);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Menu item deleted successfully'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

class InventoryManagementTab extends StatelessWidget {
  const InventoryManagementTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'Inventory Management',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'This function has not been implemented yet.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          SizedBox(height: 16),
          Text(
            'Future features:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            '• Track ingredient levels\n• Low stock notifications\n• Automatic reorder alerts\n• Supplier management',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class ReportsTab extends StatefulWidget {
  const ReportsTab({super.key});

  @override
  State<ReportsTab> createState() => _ReportsTabState();
}

class _ReportsTabState extends State<ReportsTab> {
  @override
  void initState() {
    super.initState();
    // Raporlama verilerini yükle
    Future.microtask(() {
      context.read<OrderService>()
        ..fetchReportSummary()
        ..fetchDailyReport();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderService>(
      builder: (context, orderService, child) {
        final reportSummary = orderService.reportSummary;
        final dailyReport = orderService.dailyReport;

        double totalRevenue = (reportSummary['totalRevenue'] ?? 0).toDouble();
        int totalOrders = (reportSummary['totalOrders'] ?? 0) as int;
        int paidOrders = (reportSummary['paidOrders'] ?? 0) as int;
        int pendingOrders = (reportSummary['pendingOrders'] ?? 0) as int;
        List popularItems = reportSummary['popularItems'] ?? [];

        int dailyOrders = (dailyReport['dailyOrders'] ?? 0) as int;
        double dailyRevenue = (dailyReport['dailyRevenue'] ?? 0).toDouble();

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sales Reports',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                // Statistics Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Total Revenue',
                        '\$${totalRevenue.toStringAsFixed(2)}',
                        Icons.attach_money,
                        Colors.green,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        'Total Orders',
                        '$totalOrders',
                        Icons.receipt,
                        Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Paid Orders',
                        '$paidOrders',
                        Icons.check_circle,
                        Colors.green,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        'Pending Payments',
                        '$pendingOrders',
                        Icons.pending,
                        Colors.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Daily Report
                const Text(
                  'Today\'s Report',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Today\'s Orders',
                        '$dailyOrders',
                        Icons.today,
                        Colors.purple,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        'Today\'s Revenue',
                        '\$${dailyRevenue.toStringAsFixed(2)}',
                        Icons.attach_money,
                        Colors.indigo,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Popular Items
                const Text(
                  'Popular Items',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 300,
                  child: popularItems.isEmpty
                      ? const Center(
                          child: Text(
                            'No orders yet',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: popularItems.length,
                          itemBuilder: (context, index) {
                            final item = popularItems[index];
                            final name = item['name'] ?? '-';
                            final totalRevenue = (item['totalRevenue'] ?? 0).toDouble();
                            final totalQuantity = item['totalQuantity'] ?? 0;
                            return Card(
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Text('${index + 1}'),
                                ),
                                title: Text(name),
                                subtitle: Text(
                                  'Revenue: \$${totalRevenue.toStringAsFixed(2)}',
                                  style: const TextStyle(color: Colors.green),
                                ),
                                trailing: Text(
                                  '$totalQuantity sold',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class StaffManagementTab extends StatelessWidget {
  const StaffManagementTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TableService>(
      builder: (context, tableService, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Staff Management',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              Expanded(
                child: ListView.builder(
                  itemCount: tableService.staff.length,
                  itemBuilder: (context, index) {
                    final staff = tableService.staff[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _getRoleColor(staff.role),
                          child: Text(
                            staff.name[0].toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(staff.name),
                        subtitle: Text('Role: ${staff.role}'),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getRoleColor(staff.role).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            staff.role.toUpperCase(),
                            style: TextStyle(
                              color: _getRoleColor(staff.role),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 16),
              const Center(
                child: Column(
                  children: [
                    Text(
                      'Advanced Staff Management',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Features like scheduling, permissions, and payroll\nhave not been implemented yet.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'manager':
        return Colors.purple;
      case 'chef':
        return Colors.orange;
      case 'waiter':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderService>(
      builder: (context, orderService, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sistem Ayarları',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sistem Sıfırlama',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Bu işlem tüm siparişleri, masa durumlarını ve raporları sıfırlayacaktır. Bu işlem geri alınamaz!',
                        style: TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => _showResetConfirmation(context, orderService),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Sistemi Sıfırla'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showResetConfirmation(BuildContext context, OrderService orderService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sistem Sıfırlama Onayı'),
        content: const Text(
          'Tüm siparişler, masa durumları ve raporlar sıfırlanacaktır. Bu işlem geri alınamaz! Devam etmek istediğinizden emin misiniz?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await orderService.resetSystem();
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Sistem başarıyla sıfırlandı'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Sistem sıfırlanırken hata oluştu: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sistemi Sıfırla'),
          ),
        ],
      ),
    );
  }
}