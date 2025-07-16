import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models.dart';
import '../../services/table_service.dart';
import 'table_detail_screen.dart';

class TableManagementScreen extends StatefulWidget {
  final int? userType;
  const TableManagementScreen({super.key, this.userType});

  @override
  State<TableManagementScreen> createState() => _TableManagementScreenState();
}

class _TableManagementScreenState extends State<TableManagementScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<TableService>(context, listen: false).fetchTables());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TableService>(
      builder: (context, tableService, child) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Restaurant Floor Plan',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: tableService.tables.length,
                  itemBuilder: (context, index) {
                    final table = tableService.tables[index];
                    return TableCard(table: table, userType: widget.userType);
                  },
                ),
              ),
              const SizedBox(height: 16),
              const TableLegend(),
            ],
          ),
        );
      },
    );
  }
}

class TableCard extends StatelessWidget {
  final RestaurantTable table;
  final int? userType;

  const TableCard({super.key, required this.table, this.userType});

  @override
  Widget build(BuildContext context) {
    Color tableColor;
    switch (table.status) {
      case TableStatus.available:
        tableColor = Colors.green;
        break;
      case TableStatus.occupied:
        tableColor = Colors.red;
        break;
      case TableStatus.reserved:
        tableColor = Colors.blue;
        break;
      case TableStatus.outOfService:
        tableColor = Colors.grey;
        break;
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TableDetailScreen(tableId: table.id, userType: userType),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: tableColor,
              width: 3,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                table.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.people, size: 16),
                  const SizedBox(width: 4),
                  Text('${table.capacity}'),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 1,
                ),
                decoration: BoxDecoration(
                  color: tableColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  table.status.toString().split('.').last,
                  style: TextStyle(
                    fontSize: 10,
                    color: tableColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TableLegend extends StatelessWidget {
  const TableLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildLegendItem('Available', Colors.green),
          _buildLegendItem('Occupied', Colors.red),
          _buildLegendItem('Reserved', Colors.blue),
          _buildLegendItem('Out of service', Colors.grey),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10),
        ),
      ],
    );
  }
}
