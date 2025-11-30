import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../theme/app_theme.dart';
import '../widgets/page_header.dart';
import '../widgets/primary_button.dart';

/// ============================================================
/// COMPLETE POS PAGE - CLEAN ARCHITECTURE IMPLEMENTATION
/// ============================================================
///
///
/// This file follows Clean Architecture principles with three main layers:
///
/// 1. DOMAIN LAYER
///    - Pure business entities (Product, CartItem)
///    - Repository abstractions (POSRepository)
///    - Immutable state container (POSState)
///    - No dependencies on Flutter or external frameworks
///
/// 2. DATA LAYER
///    - Repository implementations (InMemoryPOSRepository)
///    - Data sources (mock products, barcode mappings)
///    - Implements domain abstractions
///
/// 3. PRESENTATION LAYER
///    - UI widgets and state management (POSPage, _POSPageState)
///    - User interactions and event handlers
///    - Flutter-specific code
///
/// KEY DESIGN DECISIONS:
/// - Immutable state pattern: All state changes create new instances
/// - Controller pattern: Business logic separated from UI
/// - Single source of truth: State is managed in POSState
/// - Search logic: Only checks searchQuery, not focus state (see build method)
///
/// DOMAIN LAYER
class Product {
  final int id;
  final String barcode;
  final String name;
  final String category;
  final double sellingPrice;
  final int stock;

  const Product({
    required this.id,
    required this.barcode,
    required this.name,
    required this.category,
    required this.sellingPrice,
    required this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'],
        barcode: json['barcode'] ?? '',
        name: json['name'],
        category: json['category'] ?? '',
        sellingPrice: double.parse(json['selling_price'].toString()),
        stock: json['quantity_in_stock'] ?? 0,
      );
}

class CartItem {
  final Product product;
  final int quantity;

  const CartItem({
    required this.product,
    this.quantity = 1,
  });

  CartItem copyWith({Product? product, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  double get totalPrice => product.sellingPrice * quantity;
}

abstract class POSRepository {
  Future<List<Product>> fetchProducts();
  Future<Product?> findByBarcode(String barcode);
}

/// Immutable state container for the POS feature.
class POSState {
  final List<Product> products;
  final List<CartItem> cart;
  final String searchQuery;
  final String barcodeInput;
  final String paymentMethod;
  final double taxRate;
  final bool isLoading;

  const POSState({
    required this.products,
    required this.cart,
    required this.searchQuery,
    required this.barcodeInput,
    required this.paymentMethod,
    required this.taxRate,
    this.isLoading = false,
  });

  POSState copyWith({
    List<Product>? products,
    List<CartItem>? cart,
    String? searchQuery,
    String? barcodeInput,
    String? paymentMethod,
    double? taxRate,
    bool? isLoading,
  }) {
    return POSState(
      products: products ?? this.products,
      cart: cart ?? this.cart,
      searchQuery: searchQuery ?? this.searchQuery,
      barcodeInput: barcodeInput ?? this.barcodeInput,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      taxRate: taxRate ?? this.taxRate,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  /// Filtered products by search query (name)
  List<Product> get filteredProducts {
    if (searchQuery.trim().isEmpty) return products;
    final query = searchQuery.toLowerCase();
    return products
        .where((p) =>
            p.name.toLowerCase().contains(query) ||
            p.category.toLowerCase().contains(query) ||
            p.barcode.contains(query))
        .toList();
  }

  double get subtotal =>
      cart.fold(0.0, (total, item) => total + item.totalPrice);

  double get tax => subtotal * taxRate;

  double get total => subtotal + tax;
}

/// DATA LAYER
class ApiPOSRepository implements POSRepository {
  static const String baseUrl = 'http://127.0.0.1:5000'; // CHANGE THIS IP!
  static const String productsUrl = '$baseUrl/pos/products';
  static const String transactionsUrl = '$baseUrl/pos/transactions';

  @override
  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(productsUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['products'] as List)
            .map((p) => Product.fromJson(p))
            .toList();
      }
      throw Exception('Failed to load products: ${response.statusCode}');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  @override
  Future<Product?> findByBarcode(String barcode) async {
    final products = await fetchProducts();
    try {
      return products.firstWhere((p) => p.barcode == barcode);
    } catch (e) {
      return null;
    }
  }
}

/// CONTROLLER LAYER
class POSController {
  final POSRepository repository;

  const POSController({required this.repository});

  POSState setSearchQuery(POSState state, String query) {
    return state.copyWith(searchQuery: query);
  }

  POSState resetSearch(POSState state) {
    return state.copyWith(searchQuery: '');
  }

  POSState setBarcodeInput(POSState state, String barcodeInput) {
    return state.copyWith(barcodeInput: barcodeInput);
  }

  POSState setPaymentMethod(POSState state, String paymentMethod) {
    return state.copyWith(paymentMethod: paymentMethod);
  }

  POSState addProductToCart(POSState state, Product product) {
    final List<CartItem> cart = List<CartItem>.from(state.cart);
    final index = cart.indexWhere((item) => item.product.id == product.id);

    if (index >= 0) {
      final existing = cart[index];
      cart[index] = existing.copyWith(quantity: existing.quantity + 1);
    } else {
      cart.add(CartItem(product: product));
    }
    return state.copyWith(cart: cart);
  }

  POSState updateCartItemQuantity(POSState state, CartItem item, int delta) {
    final List<CartItem> cart = List<CartItem>.from(state.cart);
    final index = cart.indexWhere((c) => c.product.id == item.product.id);
    if (index < 0) return state;

    final existing = cart[index];
    final newQuantity = existing.quantity + delta;
    if (newQuantity <= 0) {
      cart.removeAt(index);
    } else {
      cart[index] = existing.copyWith(quantity: newQuantity);
    }
    return state.copyWith(cart: cart);
  }

  POSState clearCart(POSState state) {
    return state.copyWith(cart: const [], paymentMethod: 'cash');
  }

  POSState removeItem(POSState state, CartItem item) {
    final List<CartItem> cart = List<CartItem>.from(state.cart);
    cart.removeWhere((c) => c.product.id == item.product.id);
    return state.copyWith(cart: cart);
  }

  Future<POSState> addBarcodeToCart(POSState state) async {
    final input = state.barcodeInput.trim();
    if (input.isEmpty) return state;

    try {
      final product = await repository.findByBarcode(input);
      if (product == null) return state.copyWith(barcodeInput: '');

      final updated = addProductToCart(state, product);
      return updated.copyWith(barcodeInput: '');
    } catch (e) {
      return state.copyWith(barcodeInput: '');
    }
  }
}

/// PRESENTATION LAYER
class POSPage extends StatefulWidget {
  const POSPage({super.key});

  @override
  State<POSPage> createState() => _POSPageState();
}

class _POSPageState extends State<POSPage> {
  late final POSController _controller;
  POSState _state = const POSState(
    products: [],
    cart: [],
    searchQuery: '',
    barcodeInput: '',
    paymentMethod: 'cash',
    taxRate: 0.1,
  );

  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = POSController(repository: ApiPOSRepository());
    _loadProducts();
    _searchFocusNode.addListener(() {
      if (!mounted) return;
      setState(() {});
    });
  }

  Future<void> _loadProducts() async {
    setState(() => _state = _state.copyWith(isLoading: true));
    try {
      final products = await _controller.repository.fetchProducts();
      setState(
          () => _state = _state.copyWith(products: products, isLoading: false));
    } catch (e) {
      setState(() => _state = _state.copyWith(isLoading: false));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load products: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _barcodeController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _state = _controller.setSearchQuery(_state, value);
    });
  }

  Future<void> _addBarcodeToCart() async {
    final newState = await _controller.addBarcodeToCart(_state);
    setState(() {
      _state = newState;
      _barcodeController.clear();
    });
  }

  void _handleKeypadTap(String value) {
    setState(() {
      String current = _barcodeController.text;
      if (value == 'C') {
        current = '';
      } else if (value == '←') {
        if (current.isNotEmpty) {
          current = current.substring(0, current.length - 1);
        }
      } else {
        current += value;
      }
      _barcodeController
        ..text = current
        ..selection = TextSelection.collapsed(offset: current.length);
      _state = _controller.setBarcodeInput(_state, current);
    });
  }

  void _resetSearchUI() {
    setState(() {
      _state = _controller.resetSearch(_state);
    });
    _searchController.clear();
    _searchFocusNode.unfocus();
  }

  Future<void> _submitTransaction() async {
    if (_state.cart.isEmpty) return;

    setState(() => _state = _state.copyWith(isLoading: true));

    try {
      final response = await http.post(
        Uri.parse(ApiPOSRepository.transactionsUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'worker_id': 1,
          'total_amount': _state.total,
          'payment_method': _state.paymentMethod,
          'items': _state.cart
              .map((item) => {
                    'product_id': item.product.id,
                    'quantity': item.quantity,
                  })
              .toList(),
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        setState(() => _state = _controller.clearCart(_state));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                duration: Duration(seconds: 2),
                content: Text('Transaction completed successfully'),
                backgroundColor: const Color.fromARGB(255, 87, 213, 91)),
          );
        }
      } else {
        throw Exception('Failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ ERROR: $e'); // Console will show exact issue
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('❌ $e'), duration: Duration(seconds: 2)));
      }
    } finally {
      if (mounted) setState(() => _state = _state.copyWith(isLoading: false));
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = _state.filteredProducts;
    final hasSearch = _state.searchQuery.isNotEmpty;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const PageHeader(
            title: 'Point of Sale',
            description: 'Scan or search for products to add to cart',
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: _state.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 4,
                      ),
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left side - Search & Cart
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(
                                height: 60,
                                child: TextField(
                                  controller: _searchController,
                                  focusNode: _searchFocusNode,
                                  onChanged: _onSearchChanged,
                                  decoration: InputDecoration(
                                    hintText: 'Scan or search item...',
                                    prefixIcon: const Icon(
                                      Icons.search,
                                      color: Color(0xFF9CA3AF),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFE5E5E5),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFE5E5E5),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                        color: AppTheme.primaryBlue,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Expanded(
                                child: Card(
                                  child: hasSearch
                                      ? _buildSearchableProductList(products)
                                      : _buildCartItemsList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        // Right side - Barcode & Summary
                        SizedBox(
                          width: 400,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: _buildBarcodeInput(),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Expanded(
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(24),
                                    child: _buildPaymentSummary(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchableProductList(List<Product> products) {
    if (products.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No products found',
            style: TextStyle(fontSize: 16, color: AppTheme.textSecondary),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return GestureDetector(
          onTap: () {
            setState(() {
              _state = _controller.addProductToCart(_state, product);
              _state = _controller.resetSearch(_state);
            });
            _searchController.clear();
            _searchFocusNode.unfocus();
          },
          child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
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
                        '${product.category} • Stock: ${product.stock}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${product.sellingPrice.toStringAsFixed(2)} DA',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryBlue,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCartItemsList() {
    final cart = _state.cart;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cart Items',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: cart.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_outlined,
                            size: 64, color: AppTheme.textSecondary),
                        SizedBox(height: 16),
                        Text('Cart is empty',
                            style: TextStyle(
                                fontSize: 16,
                                color: AppTheme.textSecondary,
                                fontWeight: FontWeight.w500)),
                        SizedBox(height: 8),
                        Text('Add products to start a sale',
                            style: TextStyle(
                                fontSize: 14, color: AppTheme.textSecondary)),
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount: cart.length,
                    separatorBuilder: (_, __) => const Divider(height: 24),
                    itemBuilder: (context, index) {
                      final item = cart[index];
                      return _CartItemRow(
                        item: item,
                        onIncrease: () => setState(() {
                          _state = _controller.updateCartItemQuantity(
                              _state, item, 1);
                        }),
                        onDecrease: () => setState(() {
                          _state = _controller.updateCartItemQuantity(
                              _state, item, -1);
                        }),
                        onRemove: () => setState(() {
                          _state = _controller.removeItem(_state, item);
                        }),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarcodeInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Barcode Input',
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.textPrimary),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _barcodeController,
          decoration: InputDecoration(
            hintText: 'Enter barcode...',
            hintStyle: const TextStyle(color: AppTheme.textSecondary),
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
              borderSide:
                  const BorderSide(color: AppTheme.primaryBlue, width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          ),
          style: const TextStyle(fontSize: 18, color: AppTheme.textPrimary),
          onChanged: (value) => setState(() {
            _state = _controller.setBarcodeInput(_state, value);
          }),
          onSubmitted: (_) => _addBarcodeToCart(),
        ),
        const SizedBox(height: 16),
        _buildKeypad(),
      ],
    );
  }

  Widget _buildKeypad() {
    return Column(
      children: [
        Row(children: [
          _KeypadButton('7', onTap: () => _handleKeypadTap('7')),
          const SizedBox(width: 12),
          _KeypadButton('8', onTap: () => _handleKeypadTap('8')),
          const SizedBox(width: 12),
          _KeypadButton('9', onTap: () => _handleKeypadTap('9')),
          const SizedBox(width: 12),
          _KeypadButton('←', onTap: () => _handleKeypadTap('←')),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          _KeypadButton('4', onTap: () => _handleKeypadTap('4')),
          const SizedBox(width: 12),
          _KeypadButton('5', onTap: () => _handleKeypadTap('5')),
          const SizedBox(width: 12),
          _KeypadButton('6', onTap: () => _handleKeypadTap('6')),
          const SizedBox(width: 12),
          _KeypadButton('C', onTap: () => _handleKeypadTap('C')),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          _KeypadButton('1', onTap: () => _handleKeypadTap('1')),
          const SizedBox(width: 12),
          _KeypadButton('2', onTap: () => _handleKeypadTap('2')),
          const SizedBox(width: 12),
          _KeypadButton('3', onTap: () => _handleKeypadTap('3')),
          const SizedBox(width: 60),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          const SizedBox(width: 60),
          const SizedBox(width: 12),
          _KeypadButton('0', onTap: () => _handleKeypadTap('0')),
          const SizedBox(width: 12),
          const SizedBox(width: 60),
        ]),
      ],
    );
  }

  Widget _buildPaymentSummary() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary),
          ),
          const SizedBox(height: 24),
          _SummaryRow(label: 'Subtotal', value: _state.subtotal),
          const SizedBox(height: 8),
          _SummaryRow(label: 'Tax (10%)', value: _state.tax),
          const Divider(height: 32),
          _SummaryRow(label: 'Total', value: _state.total, isTotal: true),
          const SizedBox(height: 24),
          _buildPaymentMethodSelector(),
          const SizedBox(height: 24),
          PrimaryButton(
            onPressed: _state.isLoading || _state.cart.isEmpty
                ? null
                : _submitTransaction,
            child: _state.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white)),
                  )
                : const Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, size: 20),
                      SizedBox(width: 8),
                      Text('Complete Transaction'),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSelector() {
    Widget buildOption(String id, String label) {
      final isSelected = _state.paymentMethod == id;
      return Expanded(
        child: GestureDetector(
          onTap: () => setState(() {
            _state = _controller.setPaymentMethod(_state, id);
          }),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primaryBlue : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color:
                      isSelected ? AppTheme.primaryBlue : AppTheme.borderColor),
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
                color: AppTheme.textPrimary),
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

/// UI COMPONENTS
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
                ? const Icon(Icons.backspace,
                    size: 20, color: AppTheme.textPrimary)
                : Text(
                    label,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textPrimary),
                  ),
          ),
        ),
      ),
    );
  }
}

class _CartItemRow extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;

  const _CartItemRow({
    required this.item,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Expanded(
            child: Text(item.product.name,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          ),
          Text('${item.totalPrice.toStringAsFixed(2)} DA',
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red, size: 20),
            onPressed: onRemove,
            tooltip: 'Remove item',
          ),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          Text('${item.product.sellingPrice.toStringAsFixed(2)} DA',
              style:
                  const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
          const SizedBox(width: 16),
          _QuantityButton(icon: Icons.remove, onPressed: onDecrease),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(item.quantity.toString(),
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          _QuantityButton(icon: Icons.add, onPressed: onIncrease),
        ]),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final double value;
  final bool isTotal;

  const _SummaryRow(
      {required this.label, required this.value, this.isTotal = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: isTotal ? 18 : 14,
                fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
                color: AppTheme.textPrimary)),
        Text('${value.toStringAsFixed(2)} DA',
            style: TextStyle(
                fontSize: isTotal ? 22 : 14,
                fontWeight: FontWeight.w700,
                color: isTotal ? AppTheme.primaryBlue : AppTheme.textPrimary)),
      ],
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _QuantityButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          side: const BorderSide(color: AppTheme.borderColor),
        ),
        child: Icon(icon, size: 18, color: AppTheme.textPrimary),
      ),
    );
  }
}
