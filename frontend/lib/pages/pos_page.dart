import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/page_header.dart';
import '../widgets/primary_button.dart';
import '../widgets/search_bar.dart';
import '../services/api_service.dart';

class POSPage extends StatefulWidget {
  const POSPage({super.key});

  @override
  State<POSPage> createState() => _POSPageState();
}

class _POSPageState extends State<POSPage> {
  List<_Product> _products = [];
  final List<_CartItem> _cart = [];
  final double _taxRate = 0.1;

  String _searchQuery = '';
  String _barcodeInput = '';
  String _paymentMethod = 'cash';
  final TextEditingController _barcodeController = TextEditingController();
  
  bool _isLoading = true;
  String? _errorMessage;
  bool _isProcessingTransaction = false;
  
  // Worker ID - In a real app, this would come from authentication
  // For now, using a default value of 1
  static const int _defaultWorkerId = 1;

  List<_Product> get _filteredProducts {
    if (_searchQuery.isEmpty) return _products;
    return _products
        .where(
          (product) =>
              product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              product.category
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  double get _subtotal =>
      _cart.fold(0, (total, item) => total + item.totalPrice);

  double get _tax => _subtotal * _taxRate;

  double get _total => _subtotal + _tax;

  void _addToCart(_Product product) {
    setState(() {
      final _CartItem? existing = _cart.where((_CartItem item) => item.product == product).firstOrNull;
      if (existing != null) {
        existing.quantity++;
      } else {
        _cart.add(_CartItem(product));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final productsData = await ApiService.getPosProducts();
      setState(() {
        _products = productsData.map((p) => _Product.fromApi(p)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  void _addBarcodeToCart() {
    if (_barcodeInput.isEmpty) return;
    
    // Find product by barcode
    final _Product? product = _products
        .where((p) => p.barcode.toLowerCase() == _barcodeInput.toLowerCase())
        .firstOrNull;
    
    if (product != null) {
      _addToCart(product);
      setState(() {
        _barcodeInput = '';
        _barcodeController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product with barcode $_barcodeInput not found'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _barcodeInput = '';
        _barcodeController.clear();
      });
    }
  }
  
  Future<void> _handleCheckout() async {
    if (_cart.isEmpty) return;

    setState(() {
      _isProcessingTransaction = true;
    });

    try {
      // Prepare items for API
      final items = _cart.map((cartItem) => {
        'product_id': cartItem.product.id,
        'quantity': cartItem.quantity,
      }).toList();

      // Call API to create transaction
      final result = await ApiService.createTransaction(
        workerId: _defaultWorkerId,
        totalAmount: _subtotal, // Using subtotal without tax as backend expects raw amount
        paymentMethod: _paymentMethod,
        items: items,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Transaction completed! ID: ${result['transaction_id']}',
            ),
            backgroundColor: Colors.green,
          ),
        );
        
        // Clear cart after successful transaction
        _clearCart();
        
        // Reload products to update stock
        await _loadProducts();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingTransaction = false;
        });
      }
    }
  }

  void _updateQuantity(_CartItem item, int delta) {
    setState(() {
      item.quantity += delta;
      if (item.quantity <= 0) {
        _cart.remove(item);
      }
    });
  }

  void _clearCart() {
    setState(() {
      _cart.clear();
      _paymentMethod = 'cash';
    });
  }

  @override
  void dispose() {
    _barcodeController.dispose();
    super.dispose();
  }

  void _handleKeypadTap(String value) {
    setState(() {
      if (value == 'C') {
        _barcodeInput = '';
        _barcodeController.clear();
      } else if (value == '←') {
        if (_barcodeInput.isNotEmpty) {
          _barcodeInput = _barcodeInput.substring(0, _barcodeInput.length - 1);
          _barcodeController
            ..text = _barcodeInput
            ..selection = TextSelection.collapsed(offset: _barcodeInput.length);
        }
      } else {
        _barcodeInput += value;
        _barcodeController
          ..text = _barcodeInput
          ..selection = TextSelection.collapsed(offset: _barcodeInput.length);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const PageHeader(
          title: 'Point of Sale',
          description: 'Scan or search for products to add to cart',
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 900),
                      child: _buildProductPanel(),
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                SizedBox(
                  width: 380,
                  child: _buildCartPanel(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductPanel() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading products...'),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              'Error loading products',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              onPressed: _loadProducts,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.refresh, size: 20),
                  SizedBox(width: 8),
                  Text('Retry'),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSearchBar(
            placeholder: 'Search by product name or barcode...',
            value: _searchQuery,
            onChanged: (value) => setState(() => _searchQuery = value),
          ),
          const SizedBox(height: 24),
          _buildManualEntryCard(),
          const SizedBox(height: 24),
          _buildProductGrid(),
        ],
      ),
    );
  }

  Widget _buildManualEntryCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Manual barcode entry',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _barcodeController,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: 'Enter barcode...',
                      hintStyle: const TextStyle(
                        color: AppTheme.textSecondary,
                      ),
                      filled: true,
                      fillColor: AppTheme.inputBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppTheme.borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppTheme.borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppTheme.primaryBlue, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 20,
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 18,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                PrimaryButton(
                  onPressed: _barcodeInput.isEmpty ? null : _addBarcodeToCart,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, size: 20),
                      SizedBox(width: 4),
                      Text('Add'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Keypad with specific layout
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          _KeypadButton('7', onTap: () => _handleKeypadTap('7')),
                          const SizedBox(width: 12),
                          _KeypadButton('8', onTap: () => _handleKeypadTap('8')),
                          const SizedBox(width: 12),
                          _KeypadButton('9', onTap: () => _handleKeypadTap('9')),
                          const SizedBox(width: 12),
                          _KeypadButton('←', onTap: () => _handleKeypadTap('←')),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _KeypadButton('4', onTap: () => _handleKeypadTap('4')),
                          const SizedBox(width: 12),
                          _KeypadButton('5', onTap: () => _handleKeypadTap('5')),
                          const SizedBox(width: 12),
                          _KeypadButton('6', onTap: () => _handleKeypadTap('6')),
                          const SizedBox(width: 12),
                          _KeypadButton('C', onTap: () => _handleKeypadTap('C')),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _KeypadButton('1', onTap: () => _handleKeypadTap('1')),
                          const SizedBox(width: 12),
                          _KeypadButton('2', onTap: () => _handleKeypadTap('2')),
                          const SizedBox(width: 12),
                          _KeypadButton('3', onTap: () => _handleKeypadTap('3')),
                          const SizedBox(width: 12),
                          const SizedBox(width: 60), // Spacer for alignment
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const SizedBox(width: 60), // Spacer
                          const SizedBox(width: 12),
                          _KeypadButton('0', onTap: () => _handleKeypadTap('0')),
                          const SizedBox(width: 12),
                          const SizedBox(width: 60), // Spacer
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductGrid() {
    final List<_Product> products = _filteredProducts;

    if (products.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text(
            'No products found',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.textSecondary,
            ),
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1.6,
      ),
      itemCount: products.length,
      itemBuilder: (BuildContext context, int index) {
        final _Product product = products[index];
        return _ProductCard(
          product: product,
          onTap: () => _addToCart(product),
        );
      },
    );
  }

  Widget _buildCartPanel() {
    return Column(
      children: [
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Sale',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _cart.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Cart is empty',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppTheme.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Add products to start a sale',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            itemCount: _cart.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              final item = _cart[index];
                              return _CartItemRow(
                                item: item,
                                onIncrease: () => _updateQuantity(item, 1),
                                onDecrease: () => _updateQuantity(item, -1),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _SummaryRow(label: 'Subtotal', value: _subtotal),
                const SizedBox(height: 8),
                _SummaryRow(label: 'Tax (10%)', value: _tax),
                const Divider(height: 32),
                _SummaryRow(
                  label: 'Total',
                  value: _total,
                  isTotal: true,
                ),
                const SizedBox(height: 24),
                _buildPaymentMethodSelector(),
                const SizedBox(height: 16),
                PrimaryButton(
                  onPressed: (_cart.isEmpty || _isProcessingTransaction)
                      ? null
                      : _handleCheckout,
                  child: _isProcessingTransaction
                      ? const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text('Processing...'),
                          ],
                        )
                      : const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle, size: 20),
                            SizedBox(width: 8),
                            Text('Complete Sale'),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSelector() {
    Widget buildOption(String id, String label) {
      final isSelected = _paymentMethod == id;
      return Expanded(
        child: GestureDetector(
          onTap: () => setState(() => _paymentMethod = id),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primaryBlue : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected
                    ? AppTheme.primaryBlue
                    : AppTheme.borderColor,
              ),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? Colors.white : AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Payment Method',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            buildOption('cash', 'Cash'),
            const SizedBox(width: 12),
            buildOption('card', 'Card'),
          ],
        ),
      ],
    );
  }
}

class _KeypadButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _KeypadButton(this.label, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: Center(
            child: label == '←'
                ? const Icon(Icons.backspace, size: 20, color: AppTheme.textPrimary)
                : Text(
                    label,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textPrimary,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final _Product product;
  final VoidCallback onTap;

  const _ProductCard({
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppTheme.borderColor, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // FIXED SPACING
          children: [
            // TOP SECTION (name + category)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product.category,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
            // BOTTOM SECTION (price + stock)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Stock: ${product.stock}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CartItemRow extends StatelessWidget {
  final _CartItem item;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const _CartItemRow({
    required this.item,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                item.product.name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              '\$${item.totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              '\$${item.product.price.toStringAsFixed(2)}',
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(width: 16),
            _QuantityButton(
              icon: Icons.remove,
              onPressed: onDecrease,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                item.quantity.toString(),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            _QuantityButton(
              icon: Icons.add,
              onPressed: onIncrease,
            ),
          ],
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final double value;
  final bool isTotal;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: AppTheme.textPrimary,
          ),
        ),
        Text(
          '\$${value.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: isTotal ? 22 : 14,
            fontWeight: FontWeight.w700,
            color: isTotal ? AppTheme.primaryBlue : AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _QuantityButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: const BorderSide(color: AppTheme.borderColor),
        ),
        child: Icon(
          icon,
          size: 18,
          color: AppTheme.textPrimary,
        ),
      ),
    );
  }
}

class _Product {
  final int id;
  final String name;
  final String barcode;
  final String category;
  final double price;
  final int stock;

  _Product({
    required this.id,
    required this.name,
    required this.barcode,
    required this.category,
    required this.price,
    required this.stock,
  });

  // Factory constructor to create from API response
  factory _Product.fromApi(Map<String, dynamic> data) {
    // Try to extract category from name or use a default
    // Since backend doesn't provide category, we'll use 'Uncategorized'
    String category = 'Uncategorized';
    final name = data['name'] as String? ?? '';
    
    // Simple category detection based on name keywords
    final nameLower = name.toLowerCase();
    if (nameLower.contains('cola') || nameLower.contains('juice') || nameLower.contains('drink')) {
      category = 'Beverages';
    } else if (nameLower.contains('chip') || nameLower.contains('snack') || nameLower.contains('chocolate')) {
      category = 'Snacks';
    } else if (nameLower.contains('milk') || nameLower.contains('butter') || nameLower.contains('dairy')) {
      category = 'Dairy';
    } else if (nameLower.contains('bread') || nameLower.contains('bakery')) {
      category = 'Bakery';
    }

    return _Product(
      id: data['id'] as int? ?? 0,
      name: name,
      barcode: data['barcode'] as String? ?? '',
      category: category,
      price: (data['selling_price'] as num?)?.toDouble() ?? 0.0,
      stock: (data['quantity_in_stock'] as int?) ?? 0,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _Product && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class _CartItem {
  final _Product product;
  int quantity;

  _CartItem(this.product) : quantity = 1;

  double get totalPrice => product.price * quantity;
}

extension FirstOrNullExtension<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
