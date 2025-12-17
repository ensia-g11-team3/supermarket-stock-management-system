import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/page_header.dart';
import '../widgets/search_bar.dart';
import '../assets/colors.dart';

class ThresholdPage extends StatefulWidget {
  const ThresholdPage({super.key});

  @override
  State<ThresholdPage> createState() => _ThresholdPageState();
}

class _ThresholdPageState extends State<ThresholdPage> {
  String _searchQuery = '';
  String? _editingProductId;
  final Map<String, TextEditingController> _thresholdControllers = {};

  final List<Map<String, dynamic>> _products = [
    {
      'id': '1',
      'name': 'Coca Cola 500ml',
      'category': 'Beverages',
      'stock': 50,
      'minStock': 10,
    },
    {
      'id': '2',
      'name': 'Lays Chips',
      'category': 'Snacks',
      'stock': 30,
      'minStock': 10,
    },
    {
      'id': '3',
      'name': 'Milk 1L',
      'category': 'Dairy',
      'stock': 25,
      'minStock': 10,
    },
    {
      'id': '4',
      'name': 'White Bread',
      'category': 'Bakery',
      'stock': 40,
      'minStock': 10,
    },
    {
      'id': '5',
      'name': 'Orange Juice 1L',
      'category': 'Beverages',
      'stock': 20,
      'minStock': 10,
    },
    {
      'id': '6',
      'name': 'Butter 250g',
      'category': 'Dairy',
      'stock': 5,
      'minStock': 10,
    },
    {
      'id': '7',
      'name': 'Coffee Beans 500g',
      'category': 'Beverages',
      'stock': 8,
      'minStock': 15,
    },
    {
      'id': '8',
      'name': 'Olive Oil 500ml',
      'category': 'Pantry',
      'stock': 3,
      'minStock': 10,
    },
    {
      'id': '9',
      'name': 'Honey 250g',
      'category': 'Pantry',
      'stock': 6,
      'minStock': 12,
    },
  ];

  List<Map<String, dynamic>> get _filteredProducts {
    return _products.where((product) {
      if (_searchQuery.isEmpty) return true;
      return product['name']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          product['category']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  void dispose() {
    for (var controller in _thresholdControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _startEditing(String productId, int currentThreshold) {
    setState(() {
      _editingProductId = productId;
      _thresholdControllers[productId] = TextEditingController(
        text: currentThreshold.toString(),
      );
    });
  }

  void _cancelEditing() {
    setState(() {
      if (_editingProductId != null) {
        _thresholdControllers[_editingProductId]?.dispose();
        _thresholdControllers.remove(_editingProductId);
        _editingProductId = null;
      }
    });
  }

  void _saveThreshold(String productId) {
    final controller = _thresholdControllers[productId];
    if (controller == null) return;

    final newThreshold = int.tryParse(controller.text);
    if (newThreshold == null || newThreshold <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid positive number'),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    setState(() {
      final productIndex = _products.indexWhere((p) => p['id'] == productId);
      if (productIndex != -1) {
        _products[productIndex]['minStock'] = newThreshold;
      }
      _thresholdControllers[productId]?.dispose();
      _thresholdControllers.remove(productId);
      _editingProductId = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Threshold updated successfully'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const PageHeader(
          title: 'Stock Thresholds',
          description: 'Manage minimum stock levels for products',
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatsCard(),
                const SizedBox(height: 32),
                _buildSearchBar(),
                const SizedBox(height: 24),
                _buildDataTable(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.brownGold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.tune,
              color: AppColors.brownGold,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Total Products',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _products.length.toString(),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Search Products',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          AppSearchBar(
            placeholder: 'Search by product name or category...',
            value: _searchQuery,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(2.5), // Product Name
          1: FlexColumnWidth(1.5), // Category
          2: FlexColumnWidth(1), // Current Stock
          3: FlexColumnWidth(1.5), // Threshold
          4: FlexColumnWidth(1.5), // Actions
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          // Header Row
          TableRow(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.borderColor)),
              color: Color(0xFFFAFAFA),
            ),
            children: [
              _buildHeaderCell('Product Name'),
              _buildHeaderCell('Category'),
              _buildHeaderCell('Current Stock'),
              _buildHeaderCell('Min Stock Threshold'),
              _buildHeaderCell('Actions', alignment: Alignment.center),
            ],
          ),
          // Data Rows
          ..._filteredProducts.map((product) => _buildDataRow(product)),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text,
      {Alignment alignment = Alignment.centerLeft}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Align(
        alignment: alignment,
        child: Text(
          text,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  TableRow _buildDataRow(Map<String, dynamic> product) {
    final String productId = product['id'];
    final bool isEditing = _editingProductId == productId;
    final int currentStock = product['stock'];
    final int minStock = product['minStock'];
    final bool isLowStock = currentStock <= minStock;

    return TableRow(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderColor)),
      ),
      children: [
        // Product Name
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: isLowStock ? AppColors.red : AppColors.brownGold,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  product['name'],
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Category
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Text(
            product['category'],
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
            ),
          ),
        ),
        // Current Stock
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: isLowStock
                  ? AppColors.red.withOpacity(0.1)
                  : AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              currentStock.toString(),
              style: TextStyle(
                color: isLowStock ? AppColors.red : AppColors.success,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
        // Threshold (editable)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: isEditing
              ? Container(
                  constraints: const BoxConstraints(maxWidth: 100),
                  child: TextField(
                    controller: _thresholdControllers[productId],
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: AppColors.primaryBlue,
                          width: 2,
                        ),
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : Text(
                  minStock.toString(),
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
        // Actions
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: isEditing
                ? [
                    // Save Button
                    ElevatedButton(
                      onPressed: () => _saveThreshold(productId),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Cancel Button
                    OutlinedButton(
                      onPressed: _cancelEditing,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        side: const BorderSide(color: AppColors.borderColor),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ]
                : [
                    // Edit Button
                    ElevatedButton.icon(
                      onPressed: () => _startEditing(productId, minStock),
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ],
          ),
        ),
      ],
    );
  }
}
