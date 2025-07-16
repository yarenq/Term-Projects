import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models.dart';
import '../../services/menu_service.dart';
import '../../services/order_service.dart';
import '../../services/table_service.dart';

class MenuScreen extends StatefulWidget {
  final String tableId;

  const MenuScreen({super.key, required this.tableId});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<MenuService>(context, listen: false).fetchMenuItems());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<MenuService, OrderService>(
      builder: (context, menuService, orderService, child) {
        final categories = ['All', ...menuService.categories];
        final activeCart = orderService.getCartForTable(widget.tableId);
        final cartItemCount = activeCart.values.fold(0, (sum, item) => sum + item.quantity);
        final tableService = Provider.of<TableService>(context, listen: false);
        final table = tableService.getTableById(widget.tableId);

        return Scaffold(
          appBar: AppBar(
            title: Flexible(
              child: Text(
                'Menu - ${table?.name ?? widget.tableId}',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            actions: [
              Stack(
                children: [
                  IconButton(
                    onPressed: () => _showCartDialog(context, orderService, activeCart),
                    icon: const Icon(Icons.shopping_cart),
                  ),
                  if (cartItemCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '$cartItemCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          body: Column(
            children: [
              // Category filter
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected = selectedCategory == category;
                    
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            selectedCategory = category;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              // Menu items
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _getFilteredItems(menuService).length,
                  itemBuilder: (context, index) {
                    final item = _getFilteredItems(menuService)[index];
                    return MenuItemCard(
                      item: item,
                      onAddToCart: (quantity, instructions) {
                        orderService.addToCart(
                          widget.tableId,
                          item,
                          quantity,
                          specialInstructions: instructions,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${item.name} added to cart'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: cartItemCount > 0
              ? FloatingActionButton.extended(
                  onPressed: () => _showCartDialog(context, orderService, activeCart),
                  label: Text('Cart ($cartItemCount)'),
                  icon: const Icon(Icons.shopping_cart),
                )
              : null,
        );
      },
    );
  }

  List<MenuItem> _getFilteredItems(MenuService menuService) {
    if (selectedCategory == 'All') {
      return menuService.menuItems.where((item) => item.isAvailable).toList();
    }
    return menuService.getItemsByCategory(selectedCategory)
        .where((item) => item.isAvailable).toList();
  }

  void _showCartDialog(BuildContext context, OrderService orderService, Map<String, OrderItem> cart) {
    showDialog(
      context: context,
      builder: (context) => CartDialog(
        tableId: widget.tableId,
        cartItems: cart,
        onSubmitOrder: () {
          final tableService = Provider.of<TableService>(context, listen: false);
          orderService.submitOrder(widget.tableId, tableService);
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Order submitted successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        },
        onUpdateQuantity: (itemId, quantity) {
          orderService.updateCartItemQuantity(widget.tableId, itemId, quantity);
        },
        onRemoveItem: (itemId) {
          orderService.removeFromCart(widget.tableId, itemId);
        },
      ),
    );
  }
}

class MenuItemCard extends StatelessWidget {
  final MenuItem item;
  final Function(int quantity, String? instructions) onAddToCart;

  const MenuItemCard({
    super.key,
    required this.item,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: const Icon(
              Icons.restaurant,
              size: 80,
              color: Colors.grey,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      '\$${item.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  item.description,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Chip(
                  label: Text(item.category),
                  backgroundColor: Colors.orange.shade100,
                  labelStyle: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _showAddToCartDialog(context),
                    child: const Text('Add to Cart'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddToCartDialog(BuildContext context) {
    int quantity = 1;
    String? specialInstructions;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Add ${item.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Quantity:'),
                  Row(
                    children: [
                      IconButton(
                        onPressed: quantity > 1
                            ? () => setState(() => quantity--)
                            : null,
                        icon: const Icon(Icons.remove),
                      ),
                      Text(quantity.toString()),
                      IconButton(
                        onPressed: () => setState(() => quantity++),
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Special Instructions (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                onChanged: (value) => specialInstructions = value.isEmpty ? null : value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                onAddToCart(quantity, specialInstructions);
                Navigator.of(context).pop();
              },
              child: const Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}

class CartDialog extends StatelessWidget {
  final String tableId;
  final Map<String, OrderItem> cartItems;
  final VoidCallback onSubmitOrder;
  final Function(String itemId, int quantity) onUpdateQuantity;
  final Function(String itemId) onRemoveItem;

  const CartDialog({
    super.key,
    required this.tableId,
    required this.cartItems,
    required this.onSubmitOrder,
    required this.onUpdateQuantity,
    required this.onRemoveItem,
  });

  @override
  Widget build(BuildContext context) {
    final totalAmount = cartItems.values.fold(0.0, (sum, item) => sum + item.totalPrice);
    final tableService = Provider.of<TableService>(context, listen: false);
    final table = tableService.getTableById(tableId);
    return AlertDialog(
      title: Text('Cart - ${table?.name ?? tableId}'),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: cartItems.isEmpty
            ? const Center(child: Text('Your cart is empty'))
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems.values.elementAt(index);
                        return CartItemTile(
                          item: item,
                          onUpdateQuantity: (quantity) => onUpdateQuantity(item.menuItem.id, quantity),
                          onRemove: () => onRemoveItem(item.menuItem.id),
                        );
                      },
                    ),
                  ),
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
                        '\$${totalAmount.toStringAsFixed(2)}',
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
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Continue Shopping'),
        ),
        if (cartItems.isNotEmpty)
          ElevatedButton(
            onPressed: onSubmitOrder,
            child: const Text('Submit Order'),
          ),
      ],
    );
  }
}

class CartItemTile extends StatelessWidget {
  final OrderItem item;
  final Function(int quantity) onUpdateQuantity;
  final VoidCallback onRemove;

  const CartItemTile({
    super.key,
    required this.item,
    required this.onUpdateQuantity,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.menuItem.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('\$${item.menuItem.price.toStringAsFixed(2)} each'),
          if (item.specialInstructions != null)
            Text(
              'Note: ${item.specialInstructions}',
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: item.quantity > 1
                ? () => onUpdateQuantity(item.quantity - 1)
                : null,
            icon: const Icon(Icons.remove),
          ),
          Text(item.quantity.toString()),
          IconButton(
            onPressed: () => onUpdateQuantity(item.quantity + 1),
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
    );
  }
}