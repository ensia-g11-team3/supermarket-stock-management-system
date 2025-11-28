import 'package:flutter/material.dart';
import '../widgets/page_header.dart';
import '../widgets/primary_button.dart';

class StockMovementPage extends StatefulWidget {
  const StockMovementPage({super.key});

  @override
  State<StockMovementPage> createState() => _StockMovementPageState();
}

class _StockMovementPageState extends State<StockMovementPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String _selectedMovementType = 'All Types';
  String _selectedUser = 'All Users';

  final List<StockMovement> _movements = [
    StockMovement(
      dateTime: DateTime(2025, 11, 16, 9, 30),
      product: 'Coca Cola 500ml',
      type: 'Stock Out',
      quantity: -3,
      user: 'John Doe',
      reference: 'TRX001',
      notes: 'Sale transaction',
    ),
    StockMovement(
      dateTime: DateTime(2025, 11, 16, 8, 15),
      product: 'Milk 1L',
      type: 'Stock In',
      quantity: 50,
      user: 'Admin',
      reference: 'ORD001',
      notes: 'Supplier delivery',
    ),
    StockMovement(
      dateTime: DateTime(2025, 11, 16, 10, 45),
      product: 'Lays Chips',
      type: 'Stock Out',
      quantity: -5,
      user: 'Jane Smith',
      reference: 'TRX002',
      notes: 'Sale transaction',
    ),
    StockMovement(
      dateTime: DateTime(2025, 11, 15, 16, 20),
      product: 'Coffee Beans 500g',
      type: 'Adjustment',
      quantity: -2,
      user: 'Admin',
      reference: 'ADJ001',
      notes: 'Damaged items',
    ),
    StockMovement(
      dateTime: DateTime(2025, 11, 15, 14, 10),
      product: 'Butter 250g',
      type: 'Stock Out',
      quantity: -1,
      user: 'John Doe',
      reference: 'TRX005',
      notes: 'Sale transaction',
    ),
    StockMovement(
      dateTime: DateTime(2025, 11, 15, 11, 0),
      product: 'White Bread',
      type: 'Stock In',
      quantity: 80,
      user: 'Admin',
      reference: 'ORD002',
      notes: 'Supplier delivery',
    ),
    StockMovement(
      dateTime: DateTime(2025, 11, 15, 9, 30),
      product: 'Orange Juice 1L',
      type: 'Stock Out',
      quantity: -2,
      user: 'Jane Smith',
      reference: 'TRX003',
      notes: 'Sale transaction',
    ),
    StockMovement(
      dateTime: DateTime(2025, 11, 14, 15, 45),
      product: 'Chocolate Bar',
      type: 'Stock In',
      quantity: 100,
      user: 'Admin',
      reference: 'ORD003',
      notes: 'Supplier delivery',
    ),
    StockMovement(
      dateTime: DateTime(2025, 11, 14, 13, 20),
      product: 'Milk 1L',
      type: 'Adjustment',
      quantity: 5,
      user: 'Admin',
      reference: 'ADJ002',
      notes: 'Stock count correction',
    ),
    StockMovement(
      dateTime: DateTime(2025, 11, 14, 11, 15),
      product: 'Coca Cola 500ml',
      type: 'Stock Out',
      quantity: -6,
      user: 'John Doe',
      reference: 'TRX004',
      notes: 'Sale transaction',
    ),
  ];

  int get _totalMovements => _movements.length;
  int get _stockIn => _movements
      .where((m) => m.type == 'Stock In')
      .fold(0, (sum, m) => sum + m.quantity);
  int get _stockOut => _movements
      .where((m) => m.type == 'Stock Out')
      .fold(0, (sum, m) => sum + m.quantity);

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Stock In':
        return Colors.green.shade50;
      case 'Stock Out':
        return Colors.pink.shade50;
      case 'Adjustment':
        return Colors.blue.shade50;
      default:
        return Colors.grey.shade50;
    }
  }

  Color _getTypeTextColor(String type) {
    switch (type) {
      case 'Stock In':
        return Colors.green.shade700;
      case 'Stock Out':
        return Colors.pink.shade700;
      case 'Adjustment':
        return Colors.blue.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _exportReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exporting report...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(24),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Stock Movement History',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.brown.shade700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Complete audit trail of all inventory movements',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              PrimaryButton(
                onPressed: _exportReport,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.download, size: 18),
                    SizedBox(width: 8),
                    Text('Export Report'),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Main Content
        Expanded(
          child: Container(
            color: Colors.grey.shade50,
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Filters
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Filters',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Search',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                    hintText: 'Product or reference...',
                                    prefixIcon: Icon(Icons.search, size: 20, color: Colors.grey.shade400),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: Colors.grey.shade300),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: Colors.grey.shade300),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Date',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _dateController,
                                  decoration: InputDecoration(
                                    hintText: 'mm/dd/yyyy',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: Colors.grey.shade300),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: Colors.grey.shade300),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Movement Type',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                DropdownButtonFormField<String>(
                                  value: _selectedMovementType,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: Colors.grey.shade300),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: Colors.grey.shade300),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  ),
                                  items: ['All Types', 'Stock In', 'Stock Out', 'Adjustment']
                                      .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                                      .toList(),
                                  onChanged: (value) => setState(() => _selectedMovementType = value!),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'User',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                DropdownButtonFormField<String>(
                                  value: _selectedUser,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: Colors.grey.shade300),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: Colors.grey.shade300),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  ),
                                  items: ['All Users', 'Admin', 'John Doe', 'Jane Smith']
                                      .map((user) => DropdownMenuItem(value: user, child: Text(user)))
                                      .toList(),
                                  onChanged: (value) => setState(() => _selectedUser = value!),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Stats Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard('Total Movements', _totalMovements.toString(), Colors.grey.shade700),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard('Stock In', '+$_stockIn', Colors.green.shade600),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard('Stock Out', _stockOut.toString(), Colors.red.shade600),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Table
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        // Table Header
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                          ),
                          child: Row(
                            children: [
                              Expanded(flex: 2, child: _buildHeaderCell('Date & Time')),
                              Expanded(flex: 2, child: _buildHeaderCell('Product')),
                              Expanded(flex: 2, child: _buildHeaderCell('Type')),
                              Expanded(flex: 1, child: _buildHeaderCell('Quantity')),
                              Expanded(flex: 1, child: _buildHeaderCell('User')),
                              Expanded(flex: 1, child: _buildHeaderCell('Reference')),
                              Expanded(flex: 2, child: _buildHeaderCell('Notes')),
                            ],
                          ),
                        ),
                        // Table Body
                        Expanded(
                          child: ListView.builder(
                            itemCount: _movements.length,
                            itemBuilder: (context, index) {
                              final movement = _movements[index];
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        _formatDateTime(movement.dateTime),
                                        style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        movement.product,
                                        style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: _getTypeColor(movement.type),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          movement.type,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: _getTypeTextColor(movement.type),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        movement.quantity > 0 ? '+${movement.quantity}' : movement.quantity.toString(),
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: movement.quantity > 0 ? Colors.green.shade700 : Colors.red.shade700,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        movement.user,
                                        style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        movement.reference,
                                        style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        movement.notes,
                                        style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color valueColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade700,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _dateController.dispose();
    super.dispose();
  }
}

class StockMovement {
  final DateTime dateTime;
  final String product;
  final String type;
  final int quantity;
  final String user;
  final String reference;
  final String notes;

  StockMovement({
    required this.dateTime,
    required this.product,
    required this.type,
    required this.quantity,
    required this.user,
    required this.reference,
    required this.notes,
  });
}