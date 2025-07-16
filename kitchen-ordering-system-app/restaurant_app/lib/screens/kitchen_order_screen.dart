import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models.dart';
import '../../services/order_service.dart';
import 'package:intl/intl.dart';
import '../../services/table_service.dart';

class KitchenOrderScreen extends StatefulWidget {
  final int? userType; // 1: personel, 2: admin
  const KitchenOrderScreen({super.key, this.userType});

  @override
  State<KitchenOrderScreen> createState() => _KitchenOrderScreenState();
}

class _KitchenOrderScreenState extends State<KitchenOrderScreen> {
  OrderStatus? _selectedStatus; // null ise All

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<OrderService>().fetchKitchenOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderService>(
      builder: (context, orderService, child) {
        final kitchenOrders = orderService.getKitchenOrders();
        // Filtreleme
        final filteredOrders = _selectedStatus == null
            ? kitchenOrders
            : kitchenOrders.where((order) => order.items.any((item) => item.status == _selectedStatus)).toList();

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Kitchen Order System',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${filteredOrders.length} Orders',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Status filter chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildStatusChip('All', kitchenOrders.length, Colors.grey, null),
                      const SizedBox(width: 8),
                      _buildStatusChip(
                        'Pending',
                        _getOrderCountByStatus(kitchenOrders, OrderStatus.pending),
                        Colors.orange,
                        OrderStatus.pending,
                      ),
                      const SizedBox(width: 8),
                      _buildStatusChip(
                        'Preparing',
                        _getOrderCountByStatus(kitchenOrders, OrderStatus.preparing),
                        Colors.blue,
                        OrderStatus.preparing,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: filteredOrders.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.restaurant_menu,
                                size: 80,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No orders in kitchen queue',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredOrders.length,
                          itemBuilder: (context, index) {
                            final order = filteredOrders[index];
                            return KitchenOrderCard(
                              order: order,
                              onUpdateItemStatus: (orderItemId, status) {
                                if (widget.userType == 1) {
                                  orderService.updateOrderItemStatus(
                                    order.id,
                                    orderItemId,
                                    status,
                                  );
                                }
                              },
                              canUpdateStatus: widget.userType == 1,
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

  Widget _buildStatusChip(String label, int count, Color color, OrderStatus? status) {
    final isSelected = _selectedStatus == status;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedStatus = status;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  color: isSelected ? color : Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _getOrderCountByStatus(List<Order> orders, OrderStatus status) {
    return orders
        .expand((order) => order.items)
        .where((item) => item.status == status)
        .length;
  }
}

class KitchenOrderCard extends StatelessWidget {
  final Order order;
  final Function(String orderItemId, OrderStatus status) onUpdateItemStatus;
  final bool canUpdateStatus;

  const KitchenOrderCard({
    super.key,
    required this.order,
    required this.onUpdateItemStatus,
    required this.canUpdateStatus,
  });

  @override
  Widget build(BuildContext context) {
    final timeElapsed = DateTime.now().difference(order.createdAt);
    final timeColor = timeElapsed.inMinutes > 15 ? Colors.red : Colors.grey;
    final tableService = Provider.of<TableService>(context, listen: false);
    final table = tableService.getTableById(order.tableId);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border(
          left: BorderSide(
          color: _getOrderPriorityColor(timeElapsed),
          width: 6,)
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          table != null ? table.name : 'Table',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Order #${order.id.substring(order.id.length - 6)}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        DateFormat('HH:mm').format(order.createdAt.toLocal()),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${timeElapsed.inMinutes}m ago',
                        style: TextStyle(
                          color: timeColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Order items
              ...order.items.map((item) => KitchenOrderItemTile(
                    item: item,
                    onUpdateStatus: (status) => onUpdateItemStatus(item.id, status),
                    canUpdateStatus: canUpdateStatus,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Color _getOrderPriorityColor(Duration timeElapsed) {
    if (timeElapsed.inMinutes > 20) return Colors.red;
    if (timeElapsed.inMinutes > 15) return Colors.orange;
    return Colors.green;
  }
}

class KitchenOrderItemTile extends StatelessWidget {
  final OrderItem item;
  final Function(OrderStatus status) onUpdateStatus;
  final bool canUpdateStatus;

  const KitchenOrderItemTile({
    super.key,
    required this.item,
    required this.onUpdateStatus,
    required this.canUpdateStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _getStatusColor(item.status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getStatusColor(item.status),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${item.quantity}x ${item.menuItem.name}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (item.specialInstructions != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'Note: ${item.specialInstructions}',
                          style: TextStyle(
                            color: Colors.orange.shade700,
                            fontStyle: FontStyle.italic,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(item.status),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getStatusText(item.status),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Status update buttons
          Row(
            children: [
              if (canUpdateStatus && item.status == OrderStatus.pending) ...[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => onUpdateStatus(OrderStatus.preparing),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text('Start Preparing'),
                  ),
                ),
              ] else if (canUpdateStatus && item.status == OrderStatus.preparing) ...[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => onUpdateStatus(OrderStatus.ready),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Mark Ready'),
                  ),
                ),
              ] else if (canUpdateStatus && item.status == OrderStatus.ready) ...[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => onUpdateStatus(OrderStatus.served),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                    child: const Text('Mark Served'),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.preparing:
        return Colors.blue;
      case OrderStatus.ready:
        return Colors.green;
      case OrderStatus.served:
        return Colors.grey;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.ready:
        return 'Ready';
      case OrderStatus.served:
        return 'Served';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }
}