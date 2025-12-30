import 'package:flutter/material.dart';
import 'package:se_project/l10n/app_localizations.dart';
import '../widgets/page_header.dart';
import '../widgets/search_bar.dart';
import '../widgets/primary_button.dart';
import '../widgets/stock_badge.dart';
import '../theme/app_theme.dart';
import '../services/product_api.dart';

class ProductListPage extends StatefulWidget {
  final ValueChanged<String>? onNavigateToEdit;
  final VoidCallback? onNavigateToAdd;
  final Function(String productId, String productName)? onNavigateToBatches;

  const ProductListPage({
    super.key,
    this.onNavigateToEdit,
    this.onNavigateToAdd,
    this.onNavigateToBatches,
  });

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  String _searchQuery = '';
  late String _selectedCategory;
  late String _selectedStockLevel;

  List<Map<String, dynamic>> _products = [];
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
        _products = data;
        _isLoading = false;
      });
    } catch (e) {
      print(AppLocalizations.of(context)!.errorLoadingProducts + "$e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> get _filteredProducts {
    return _products.where((Map<String, dynamic> product) {
      final String name = product['name']?.toString().toLowerCase() ?? '';
      final String barcode = product['barcode']?.toString() ?? '';
      final int qty = product['qty'] ?? 0;
      final int? threshold = product['product_threshold'];

      final bool matchesSearch = _searchQuery.isEmpty ||
          name.contains(_searchQuery.toLowerCase()) ||
          barcode.contains(_searchQuery);

      final bool matchesCategory =
          _selectedCategory == AppLocalizations.of(context)!.allCategories ||
              product['category'] == _selectedCategory;

      final bool matchesStockLevel = _selectedStockLevel ==
              AppLocalizations.of(context)!.allStockLevels ||
          (_selectedStockLevel == AppLocalizations.of(context)!.inStock &&
              (threshold != null ? qty > threshold : qty > 10)) ||
          (_selectedStockLevel == AppLocalizations.of(context)!.lowStock &&
              (threshold != null
                  ? (qty <= threshold && qty > threshold / 2)
                  : (qty <= 10 && qty > 5))) ||
          (_selectedStockLevel == AppLocalizations.of(context)!.veryLowStock &&
              (threshold != null
                  ? (qty <= threshold / 2 && qty > 0)
                  : (qty <= 5 && qty > 0)));

      return matchesSearch && matchesCategory && matchesStockLevel;
    }).toList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _selectedCategory = AppLocalizations.of(context)!.allCategories;
    _selectedStockLevel = AppLocalizations.of(context)!.allStockLevels;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageHeader(
          title: AppLocalizations.of(context)!.productTitle,
          description: AppLocalizations.of(context)!.productSubtitle,
          actions: [
            PrimaryButton(
              onPressed: widget.onNavigateToAdd,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, size: 20),
                  SizedBox(width: 8),
                  Text(AppLocalizations.of(context)!.addNewProduct),
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
                                Text(
                                  AppLocalizations.of(context)!.filters,
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
                                        placeholder:
                                            AppLocalizations.of(context)!
                                                .nameOrBarcode,
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
                                        label: AppLocalizations.of(context)!
                                            .category,
                                        value: _selectedCategory,
                                        items: [
                                          AppLocalizations.of(context)!
                                              .allCategories,
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
                                        label: AppLocalizations.of(context)!
                                            .stockLevel,
                                        value: _selectedStockLevel,
                                        items: [
                                          AppLocalizations.of(context)!
                                              .allStockLevels,
                                          AppLocalizations.of(context)!.inStock,
                                          AppLocalizations.of(context)!
                                              .lowStock,
                                          AppLocalizations.of(context)!
                                              .veryLowStock,
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
                              6: FlexColumnWidth(2),
                              7: FlexColumnWidth(1.5),
                            },
                            children: [
                              // Header Row
                              TableRow(
                                decoration: BoxDecoration(
                                  color: AppTheme.brownGold,
                                  border: Border(
                                    bottom:
                                        BorderSide(color: AppTheme.borderColor),
                                  ),
                                ),
                                children: [
                                  _TableHeaderCell(Text(
                                      AppLocalizations.of(context)!
                                          .productName)),
                                  _TableHeaderCell(Text(
                                      AppLocalizations.of(context)!.barcode)),
                                  _TableHeaderCell(Text(
                                      AppLocalizations.of(context)!.category)),
                                  _TableHeaderCell(Text(
                                      AppLocalizations.of(context)!.stock)),
                                  _TableHeaderCell(Text(
                                      AppLocalizations.of(context)!
                                          .buyingPrice)),
                                  _TableHeaderCell(Text(
                                      AppLocalizations.of(context)!
                                          .sellingPrice)),
                                  _TableHeaderCell(Text(
                                      AppLocalizations.of(context)!.supplier)),
                                  _TableHeaderCell(Text(
                                      AppLocalizations.of(context)!.actions)),
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
                                          stock: product['qty'],
                                          minStock:
                                              product['product_threshold'] !=
                                                      null
                                                  ? product['product_threshold']
                                                  : 0,
                                        ),
                                      ),
                                      _TableCell(Text(
                                          '${double.tryParse(product['buying_price'].toString()) ?? 0.0} DA')),
                                      _TableCell(Text(
                                          '${double.tryParse(product['selling_price'].toString()) ?? 0.0} DA')),
                                      _TableCell(Text(product['supplier'])),
                                      _TableCell(
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit,
                                                  size: 20),
                                              onPressed: () {
                                                widget.onNavigateToEdit?.call(
                                                    product['product_id']
                                                        .toString());
                                              },
                                              color: AppTheme.primaryBlue,
                                              tooltip:
                                                  AppLocalizations.of(context)!
                                                      .edit,
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete,
                                                  size: 20),
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    title: Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .deleteProduct),
                                                    content: Text(AppLocalizations
                                                                .of(context)!
                                                            .deleteConfirm +
                                                        ' ${product['name']}?'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        child: Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .cancel),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          Navigator.pop(
                                                              context); // Close dialog

                                                          await ProductApi.deleteProduct(
                                                              int.parse(product[
                                                                      'product_id']
                                                                  .toString()));

                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                                content: Text('${product['name']} ' +
                                                                    AppLocalizations.of(
                                                                            context)!
                                                                        .deleted)),
                                                          );

                                                          _fetchProducts(); // Refresh list
                                                        },
                                                        style: TextButton
                                                            .styleFrom(
                                                          foregroundColor:
                                                              Colors.red,
                                                        ),
                                                        child: Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .delete),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                              color: Colors.red,
                                              tooltip:
                                                  AppLocalizations.of(context)!
                                                      .delete,
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                  Icons.inventory_2,
                                                  size: 20),
                                              onPressed: () {
                                                widget.onNavigateToBatches
                                                    ?.call(
                                                  product['product_id']
                                                      .toString(),
                                                  product['name'],
                                                );
                                              },
                                              color: Colors.purple,
                                              tooltip:
                                                  AppLocalizations.of(context)!
                                                      .viewBatches,
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
                borderSide:
                    const BorderSide(color: AppTheme.primaryBlue, width: 2),
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
