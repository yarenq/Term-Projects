import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models.dart';
import '../../services/order_service.dart';
import '../../services/table_service.dart';
import 'package:intl/intl.dart';

class PaymentScreen extends StatefulWidget {
  final String tableId;

  const PaymentScreen({super.key, required this.tableId, required String orderId});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedPaymentMethod = 'cash';
  bool showTip = false;
  double tipAmount = 0.0;
  double tipPercentage = 15.0;

  @override
  Widget build(BuildContext context) {
    return Consumer2<OrderService, TableService>(
      builder: (context, orderService, tableService, child) {
        final orders = orderService.getOrdersForTable(widget.tableId);
        final unpaidOrders = orders.where((order) => !order.isPaid).toList();
        final totalAmount = orderService.getTotalAmountForTable(widget.tableId);
        final taxAmount = totalAmount * 0.08;
        final finalAmount = totalAmount + tipAmount + taxAmount;

        return Scaffold(
          appBar: AppBar(
            title: Flexible(
              child: Text(
                'Payment - Table \\${widget.tableId}',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          body: unpaidOrders.isEmpty
              ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle,
                  size: 80,
                  color: Colors.green,
                ),
                SizedBox(height: 16),
                Text(
                  'All orders have been paid',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          )
              : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order summary
                const Text(
                  'Order Summary',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ...unpaidOrders.map((order) => OrderSummaryCard(order: order)),
                const SizedBox(height: 16),

                // Bill breakdown
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Subtotal:'),
                          Text('\$${totalAmount.toStringAsFixed(2)}'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Tax (8%):'),
                          Text('\$${taxAmount.toStringAsFixed(2)}'),
                        ],
                      ),
                      if (showTip) ...[
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Tip (${tipPercentage.toInt()}%):'),
                            Text('\$${tipAmount.toStringAsFixed(2)}'),
                          ],
                        ),
                      ],
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$${finalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Tip section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Add Tip',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Switch(
                      value: showTip,
                      onChanged: (value) {
                        setState(() {
                          showTip = value;
                          if (value) {
                            tipAmount = totalAmount * (tipPercentage / 100);
                          } else {
                            tipAmount = 0;
                          }
                        });
                      },
                    ),
                  ],
                ),

                if (showTip) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TipButton(
                          percentage: 10,
                          isSelected: tipPercentage == 10,
                          onTap: () => _updateTip(10, totalAmount),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TipButton(
                          percentage: 15,
                          isSelected: tipPercentage == 15,
                          onTap: () => _updateTip(15, totalAmount),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TipButton(
                          percentage: 20,
                          isSelected: tipPercentage == 20,
                          onTap: () => _updateTip(20, totalAmount),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TipButton(
                          percentage: 25,
                          isSelected: tipPercentage == 25,
                          onTap: () => _updateTip(25, totalAmount),
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 24),

                // Payment method selection
                const Text(
                  'Payment Method',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                PaymentMethodCard(
                  title: 'Cash',
                  subtitle: 'Pay with cash to staff',
                  icon: Icons.attach_money,
                  isSelected: selectedPaymentMethod == 'cash',
                  onTap: () => setState(() => selectedPaymentMethod = 'cash'),
                ),

                PaymentMethodCard(
                  title: 'Credit Card',
                  subtitle: 'Pay with credit/debit card',
                  icon: Icons.credit_card,
                  isSelected: selectedPaymentMethod == 'card',
                  onTap: () => setState(() => selectedPaymentMethod = 'card'),
                ),

                PaymentMethodCard(
                  title: 'Mobile Payment',
                  subtitle: 'Apple Pay, Google Pay, etc.',
                  icon: Icons.phone_android,
                  isSelected: selectedPaymentMethod == 'mobile',
                  onTap: () => setState(() => selectedPaymentMethod = 'mobile'),
                ),

                const SizedBox(height: 32),

                // Process payment button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => _processPayment(context, orderService, tableService, unpaidOrders),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Process Payment (\$${finalAmount.toStringAsFixed(2)})',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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

  void _updateTip(double percentage, double totalAmount) {
    setState(() {
      tipPercentage = percentage;
      tipAmount = totalAmount * (percentage / 100);
    });
  }

  void _processPayment(
      BuildContext context,
      OrderService orderService,
      TableService tableService,
      List<Order> unpaidOrders,
      ) {
    final totalAmount = orderService.getTotalAmountForTable(widget.tableId);
    final taxAmount = totalAmount * 0.08;
    final finalAmount = totalAmount + tipAmount + taxAmount;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Payment Details:'),
            const SizedBox(height: 8),
            Text('Subtotal: \$${totalAmount.toStringAsFixed(2)}'),
            Text('Tax (8%): \$${taxAmount.toStringAsFixed(2)}'),
            if (showTip)
              Text('Tip (${tipPercentage.toInt()}%): \$${tipAmount.toStringAsFixed(2)}'),
            const Divider(),
            Text(
              'Total: \$${finalAmount.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('Payment method: ${_getPaymentMethodName()}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Mark all unpaid orders as paid
              for (final order in unpaidOrders) {
                orderService.markOrderAsPaid(order.id, selectedPaymentMethod, tableService);
              }

              // Update table status to available
              tableService.updateTableStatus(widget.tableId, TableStatus.available).then((_) async {
                await tableService.fetchTables();
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to table detail
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Payment processed successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            child: const Text(
              'Confirm Payment',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  String _getPaymentMethodName() {
    switch (selectedPaymentMethod) {
      case 'cash':
        return 'Cash';
      case 'card':
        return 'Credit Card';
      case 'mobile':
        return 'Mobile Payment';
      default:
        return 'Unknown';
    }
  }
}

class OrderSummaryCard extends StatelessWidget {
  final Order order;

  const OrderSummaryCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order.id.substring(order.id.length - 6)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  DateFormat('HH:mm').format(order.createdAt),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...order.items.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text('${item.quantity}x ${item.menuItem.name}'),
                  ),
                  Text('\$${item.totalPrice.toStringAsFixed(2)}'),
                ],
              ),
            )),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Order Total:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${order.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TipButton extends StatelessWidget {
  final double percentage;
  final bool isSelected;
  final VoidCallback onTap;

  const TipButton({
    super.key,
    required this.percentage,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.orange : Colors.grey.shade300,
          ),
        ),
        child: Text(
          '${percentage.toInt()}%',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

class PaymentMethodCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.orange : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? Colors.orange : Colors.grey.shade600,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.orange : Colors.black,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Colors.orange,
              ),
          ],
        ),
      ),
    );
  }
}