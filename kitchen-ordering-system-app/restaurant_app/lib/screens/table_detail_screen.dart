import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models.dart';
import '../../services/table_service.dart';
import '../../services/order_service.dart';
import 'menu_screen.dart';
import 'payment_screen.dart';

class TableDetailScreen extends StatefulWidget {
  final String tableId;
  final bool isCustomer;
  final int? userType; // 1: personel, 2: admin

  const TableDetailScreen({super.key, required this.tableId, this.isCustomer = false, this.userType});

  @override
  State<TableDetailScreen> createState() => _TableDetailScreenState();
}

class _TableDetailScreenState extends State<TableDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<TableService, OrderService>(
      builder: (context, tableService, orderService, child) {
        final table = tableService.getTableById(widget.tableId);

        if (table == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Table Not Found'),
            ),
            body: const Center(
              child: Text('The table you requested was not found.'),
            ),
          );
        }

        final orders = orderService.getOrdersForTable(widget.tableId);
        final activeCart = orderService.getCartForTable(widget.tableId);
        final totalUnpaid = orderService.getTotalAmountForTable(widget.tableId);

        String serverName = 'Not assigned';
        if (table.serverId != null && table.serverId != '') {
          final server = tableService.getStaffById(table.serverId!);
          if (server != null) {
            serverName = server.name;
          }
        }

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            title: Row(
              children: [
                widget.isCustomer 
                    ? Text('Order Page - ${table.name}', overflow: TextOverflow.ellipsis)
                    : Text(table.name, overflow: TextOverflow.ellipsis),
                if (widget.isCustomer) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: widget.userType == 2
                            ? [const Color(0xFFe65100), const Color(0xFFd84315)] // Orange gradient
                            : widget.userType == 1
                            ? [const Color(0xFFe65100), const Color(0xFFd84315)] // Amber-Orange gradient
                            : [const Color(0xFFe65100), const Color(0xFFd84315)], // Light orange gradient
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.4),
                          offset: const Offset(0, 4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Text(
                      'CUSTOMER',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ]
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!widget.isCustomer)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _getStatusColor(table.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _getStatusColor(table.status),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Capacity: ${table.capacity} people',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Status: ${table.status.toString().split('.').last}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: _getStatusColor(table.status),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Server: $serverName',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                orders.isNotEmpty
                                    ? Text(
                                  'Orders: ${orders.length}',
                                  style: const TextStyle(fontSize: 16),
                                )
                                    : const Text(
                                  'No orders yet',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (widget.userType == 2)
                          Wrap(
                            spacing: 12,
                            runSpacing: 8,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () => _assignServer(context, tableService, table),
                                      icon: const Icon(Icons.person, size: 16),
                                      label: const Text('Assign Server', style: TextStyle(fontSize: 12)),
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(0, 32),
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: table.serverId != null
                                          ? () => _unassignServer(context, tableService, table)
                                          : null,
                                      icon: const Icon(Icons.person_off, size: 16),
                                      label: const Text('Unassign Server', style: TextStyle(fontSize: 12)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        minimumSize: const Size(0, 32),
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () => _changeStatus(context, tableService, table),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(120, 32),
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.update, size: 16),
                                    SizedBox(width: 8),
                                    Text('Change Status', style: TextStyle(fontSize: 12)),
                                  ],
                                ),
                              )
                            ],
                          ),
                      ],
                    ),
                  ),

                const SizedBox(height: 20),

                // Current Cart Section
                const Text(
                  'Current Cart',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                if (activeCart.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: Text('Cart is empty'),
                      ),
                    ),
                  )
                else
                  Expanded(
                    flex: 2,
                    child: Card(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: activeCart.length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          final item = activeCart.values.elementAt(index);
                          return ListTile(
                            title: Text(item.menuItem.name),
                            subtitle: Text(
                              item.specialInstructions != null &&
                                  item.specialInstructions!.isNotEmpty
                                  ? 'Note: ${item.specialInstructions}'
                                  : 'No special instructions',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () {
                                    orderService.updateCartItemQuantity(
                                      widget.tableId,
                                      item.menuItem.id,
                                      item.quantity - 1,
                                    );
                                  },
                                ),
                                Text(
                                  '${item.quantity}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () {
                                    orderService.updateCartItemQuantity(
                                      widget.tableId,
                                      item.menuItem.id,
                                      item.quantity + 1,
                                    );
                                  },
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${(item.menuItem.price * item.quantity).toStringAsFixed(2)} ₺',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                // Order actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (widget.isCustomer)
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MenuScreen(tableId: widget.tableId.toString()),
                            ),
                          );
                        },
                        icon: const Icon(Icons.restaurant_menu),
                        label: const Text('Browse Menu'),
                      ),
                    if (activeCart.isNotEmpty && widget.isCustomer)
                      ElevatedButton.icon(
                        onPressed: () {
                          final tableService = Provider.of<TableService>(context, listen: false);
                          orderService.submitOrder(widget.tableId, tableService);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Order submitted to kitchen!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        icon: const Icon(Icons.send),
                        label: const Text('Submit Order'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 20),

                // Existing orders
                const Text(
                  'Table Orders',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                if (orders.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: Text('No orders for this table'),
                      ),
                    ),
                  )
                else
                  Expanded(
                    flex: 3,
                    child: Card(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          final order = orders[index];
                          return ExpansionTile(
                            title: Row(
                              children: [
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context).style,
                                      children: [
                                        TextSpan(
                                          text: 'Order #${order.id.toString().length >= 8 ? order.id.toString().substring(0, 8) : order.id.toString().padLeft(4, '0')} ',                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: order.isPaid ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    order.isPaid ? 'PAID' : 'open bill',
                                    style: TextStyle(
                                      color: order.isPaid ? Colors.green : Colors.orange,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              '${order.totalAmount.toStringAsFixed(2)} ₺',
                            ),
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: order.items.length,
                                itemBuilder: (context, itemIndex) {
                                  final item = order.items[itemIndex];
                                  return ListTile(
                                    dense: true,
                                    title: Text(item.menuItem.name),
                                    subtitle: Text('${item.quantity}x • ${item.menuItem.price.toStringAsFixed(2)} ₺'),
                                    trailing: order.isPaid
                                      ? null
                                      : Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: _getOrderStatusColor(item.status).withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            item.status.toString().split('.').last,
                                            style: TextStyle(
                                              color: _getOrderStatusColor(item.status),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                  );
                                },
                              ),
                              if (widget.userType == 1)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: !order.isPaid
                                      ? Builder(
                                          builder: (context) {
                                            final hasReadyOrder = order.items.any((item) => item.status == OrderStatus.ready);
                                            return ElevatedButton.icon(
                                              onPressed: hasReadyOrder
                                                  ? () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => PaymentScreen(
                                                            tableId: widget.tableId,
                                                            orderId: order.id,
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  : () {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(
                                                          content: Text('Müşteri yemeğini yemedi, ödeme yemekten sonra alınacaktır'),
                                                          backgroundColor: Colors.red,
                                                        ),
                                                      );
                                                    },
                                              icon: const Icon(Icons.payment),
                                              label: const Text('Take Payment'),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: hasReadyOrder ? Colors.green : Colors.grey,
                                                foregroundColor: Colors.white,
                                              ),
                                            );
                                          },
                                        )
                                      : Text(
                                          'Paid via ${order.paymentMethod}',
                                          style: const TextStyle(fontStyle: FontStyle.italic),
                                        ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),

                if (widget.userType == 1 && totalUnpaid > 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: Builder(
                        builder: (context) {
                          // Masadaki en az bir sipariş ready mi?
                          final hasReadyOrder = orders.any((order) => order.items.any((item) => item.status == OrderStatus.ready));
                          return ElevatedButton.icon(
                            onPressed: hasReadyOrder
                                ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PaymentScreen(
                                          tableId: widget.tableId, orderId: '',
                                        ),
                                      ),
                                    );
                                  }
                                : () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Müşteri yemeğini yemedi, ödeme yemekten sonra alınacaktır'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  },
                            icon: const Icon(Icons.payment),
                            label: const Text('Take Payment'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: hasReadyOrder ? Colors.green : Colors.grey,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(TableStatus status) {
    switch (status) {
      case TableStatus.available:
        return Colors.green;
      case TableStatus.occupied:
        return Colors.red;
      case TableStatus.reserved:
        return Colors.blue;
      case TableStatus.outOfService:
        return Colors.grey;
    }
  }

  Color _getOrderStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.preparing:
        return Colors.blue;
      case OrderStatus.ready:
        return Colors.green;
      case OrderStatus.served:
        return Colors.purple;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }

  void _assignServer(BuildContext context, TableService tableService, RestaurantTable table) {
    showDialog(
      context: context,
      builder: (context) {
        final waiters = tableService.getWaiters();
        String? selectedServerId = table.serverId;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Assign Server'),
              content: waiters.isEmpty
                  ? const Text('Atanabilir garson yok.')
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: waiters.map((waiter) {
                        return RadioListTile<String>(
                          title: Text(waiter.name),
                          value: waiter.id,
                          groupValue: selectedServerId,
                          onChanged: (value) {
                            setState(() {
                              selectedServerId = value;
                            });
                          },
                        );
                      }).toList(),
                    ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                if (waiters.isNotEmpty)
                  ElevatedButton(
                    onPressed: selectedServerId != null
                        ? () {
                            tableService.assignServerToTable(table.id, selectedServerId!);
                            Navigator.pop(context);
                          }
                        : null,
                    child: const Text('Assign'),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  void _changeStatus(BuildContext context, TableService tableService, RestaurantTable table) {
    showDialog(
      context: context,
      builder: (context) {
        TableStatus selectedStatus = table.status;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Change Table Status'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: TableStatus.values.map((status) {
                  return RadioListTile<TableStatus>(
                    title: Text(status.toString().split('.').last),
                    value: status,
                    groupValue: selectedStatus,
                    onChanged: (value) {
                      setState(() {
                        selectedStatus = value!;
                      });
                    },
                  );
                }).toList(),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    tableService.updateTableStatus(table.id, selectedStatus);
                    Navigator.pop(context);
                  },
                  child: const Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _unassignServer(BuildContext context, TableService tableService, RestaurantTable table) async {
    await tableService.assignServerToTable(table.id, '');
    await tableService.fetchTables();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Garson ataması kaldırıldı!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}