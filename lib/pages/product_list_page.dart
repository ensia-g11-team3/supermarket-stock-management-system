import 'package:flutter/material.dart';
import '../widgets/page_header.dart';
import '../widgets/search_bar.dart';
import '../widgets/primary_button.dart';
import '../widgets/stock_badge.dart';
import '../theme/app_theme.dart';

class ProductListPage extends StatefulWidget {
  final ValueChanged<String>? onNavigateToEdit;
  final VoidCallback? onNavigateToAdd;

  const ProductListPage({
    super.key,
    this.onNavigateToEdit,
    this.onNavigateToAdd,
  });

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  String _searchQuery = '';
  String _selectedCategory = 'All Categories';
  String _selectedStockLevel = 'All Stock Levels';

  final List<Map<String, dynamic>> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
    final data = await ProductApi.getProducts();
    setState(() {
      _products = List<Map<String, dynamic>>.from(data);
      _isLoading = false;
    });
   } catch (e) {
    print("Error loading products: $e");
    setState(() {
      _isLoading = false;
    });
  }
  }
  
  List<Map<String, dynamic>> get _filteredProducts {
    return _products.where((Map<String, dynamic> product) {
      final bool matchesSearch = _searchQuery.isEmpty ||
          product['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product['barcode'].toString().contains(_searchQuery);

      final bool matchesCategory =
          _selectedCategory == 'All Categories' || product['category'] == _selectedCategory;

      final bool matchesStockLevel = _selectedStockLevel == 'All Stock Levels' ||
          (_selectedStockLevel == 'In Stock' && product['stock']! > product['minStock']!) ||
          (_selectedStockLevel == 'Low Stock' &&
              product['stock']! <= product['minStock']! &&
              product['stock']! > product['minStock']! / 2) ||
          (_selectedStockLevel == 'Very Low Stock' && product['stock']! <= product['minStock']! / 2);

      return matchesSearch && matchesCategory && matchesStockLevel;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageHeader(
          title: 'Product List',
          description: 'Manage your inventory products.',
          actions: [
            PrimaryButton(
              onPressed: widget.onNavigateToAdd,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, size: 20),
                  SizedBox(width: 8),
                  Text('Add New Product'),
                ],
              ),
            ),
          ],
        ),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filters Section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Filters',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: AppSearchBar(
                                  placeholder: 'Name or barcode...',
                                  value: _searchQuery,
                                  onChanged: (value) {
                                    setState(() {
                                      _searchQuery = value;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildDropdown(
                                  label: 'Category',
                                  value: _selectedCategory,
                                  items: [
                                    'All Categories',
                                    'Beverages',
                                    'Snacks',
                                    'Dairy',
                                    'Bakery',
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCategory = value!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildDropdown(
                                  label: 'Stock Level',
                                  value: _selectedStockLevel,
                                  items: [
                                    'All Stock Levels',
                                    'In Stock',
                                    'Low Stock',
                                    'Very Low Stock',
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedStockLevel = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Product Table
                  Card(
                    child: Table(
                      columnWidths: const {
                        0: FlexColumnWidth(2),
                        1: FlexColumnWidth(1.5),
                        2: FlexColumnWidth(1.5),
                        3: FlexColumnWidth(1),
                        4: FlexColumnWidth(1),
                        5: FlexColumnWidth(2),
                        6: FlexColumnWidth(1.5),
                      },
                      children: [
                        // Header Row
                        TableRow(
                          decoration: BoxDecoration(
                            color: AppTheme.brownGold,
                            border: Border(
                              bottom: BorderSide(color: AppTheme.borderColor),
                            ),
                          ),
                          children: const [
                            _TableHeaderCell(Text('Product Name')),
                            _TableHeaderCell(Text('Barcode')),
                            _TableHeaderCell(Text('Category')),
                            _TableHeaderCell(Text('Stock')),
                            _TableHeaderCell(Text('Price')),
                            _TableHeaderCell(Text('Supplier')),
                            _TableHeaderCell(Text('Actions')),
                          ],
                        ),
                        // Data Rows
                        ..._filteredProducts.map((product) => TableRow(
                              children: [
                                _TableCell(Text(product['name'])),
                                _TableCell(Text(product['barcode'])),
                                _TableCell(Text(product['category'])),
                                _TableCell(
                                  StockBadge(
                                    stock: product['stock'],
                                    minStock: product['minStock'],
                                  ),
                                ),
                                _TableCell(Text('\$${product['price'].toStringAsFixed(2)}')),
                                _TableCell(Text(product['supplier'])),
                                _TableCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, size: 20),
                                        onPressed: () async {
                                          await widget.onNavigateToEdit?.call(product['id'].toString());
                                          _fetchProducts(); // Refresh list after edit
                                        },
                                        color: AppTheme.primaryBlue,
                                        tooltip: 'Edit',
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, size: 20),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text('Delete Product'),
                                              content: Text(
                                                  'Are you sure you want to delete ${product['name']}?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context),
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                     Navigator.pop(context); // Close dialog

                                                     await ProductApi.deleteProduct(int.parse(product['id'].toString()));

                                                     ScaffoldMessenger.of(context).showSnackBar(
                                                       SnackBar(content: Text('${product['name']} deleted')),
                                                      );

                                                      _fetchProducts(); // Refresh list
                                                  },
                                                  style: TextButton.styleFrom(
                                                    foregroundColor: Colors.red,
                                                  ),
                                                  child: const Text('Delete'),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        color: Colors.red,
                                        tooltip: 'Delete',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.inputBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppTheme.inputBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppTheme.primaryBlue, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class _TableHeaderCell extends StatelessWidget {
  final Widget child;

  const _TableHeaderCell(this.child);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: DefaultTextStyle(
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: Colors.white,
        ),
        child: child,
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  final Widget child;

  const _TableCell(this.child);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: DefaultTextStyle(
        style: const TextStyle(
          fontSize: 14,
          color: AppTheme.textPrimary,
        ),
        child: child,
      ),
    );
  }
}
