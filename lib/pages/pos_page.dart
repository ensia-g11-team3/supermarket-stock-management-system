import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/page_header.dart';
import '../widgets/primary_button.dart';
import '../widgets/search_bar.dart';

class POSPage extends StatefulWidget {
  const POSPage({super.key});

  @override
  State<POSPage> createState() => _POSPageState();
}

class _POSPageState extends State<POSPage> {
  final List<_Product> _products = [
    _Product('Coca Cola 500ml', 'Beverages', 2.50, 50),
    _Product('Lays Chips', 'Snacks', 1.99, 30),
    _Product('Milk 1L', 'Dairy', 3.99, 25),
    _Product('White Bread', 'Bakery', 2.49, 40),
    _Product('Orange Juice 1L', 'Beverages', 4.99, 20),
    _Product('Butter 250g', 'Dairy', 5.49, 15),
    _Product('Coffee Beans 500g', 'Beverages', 12.99, 10),
    _Product('Chocolate Bar', 'Snacks', 1.49, 60),
  ];

  final List<_CartItem> _cart = [];
  final double _taxRate = 0.1;

  String _searchQuery = '';
  String _barcodeInput = '';
  String _paymentMethod = 'cash';
  final TextEditingController _barcodeController = TextEditingController();

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

  void _addBarcodeToCart() {
    if (_barcodeInput.isEmpty) return;
    // Demo behavior: add the first product for any barcode
    final _Product product = _products.first;
    _addToCart(product);
    setState(() {
      _barcodeInput = '';
      _barcodeController.clear();
    });
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
            TextField(
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
                  onPressed: _cart.isEmpty ? null : () {},
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.print, size: 20),
                      SizedBox(width: 8),
                      Text('Print Receipt'),
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
  final String name;
  final String category;
  final double price;
  final int stock;

  const _Product(this.name, this.category, this.price, this.stock);
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
