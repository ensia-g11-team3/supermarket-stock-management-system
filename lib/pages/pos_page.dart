import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/page_header.dart';
import '../widgets/primary_button.dart';

/// ============================================================
/// POINT OF SALE (POS) PAGE - CLEAN ARCHITECTURE IMPLEMENTATION
/// ============================================================
/// 
/// This file follows Clean Architecture principles with three main layers:
/// 
/// 1. DOMAIN LAYER (Lines ~7-110)
///    - Pure business entities (Product, CartItem)
///    - Repository abstractions (POSRepository)
///    - Immutable state container (POSState)
///    - No dependencies on Flutter or external frameworks
/// 
/// 2. DATA LAYER (Lines ~112-210)
///    - Repository implementations (InMemoryPOSRepository)
///    - Data sources (mock products, barcode mappings)
///    - Implements domain abstractions
/// 
/// 3. PRESENTATION LAYER (Lines ~212+)
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
/// ============================================================

/// ------------------------------------------------------------
/// DOMAIN LAYER
/// ------------------------------------------------------------
/// 
/// This layer contains the core business entities and abstractions.
/// It defines what the application does, not how it does it.
/// ------------------------------------------------------------

/// Represents a product in the inventory system.
/// This is an immutable domain entity that contains product information.
class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final int stock;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
  });
}

/// Represents an item in the shopping cart.
/// Contains a product reference and its quantity.
class CartItem {
  final Product product;
  final int quantity;

  const CartItem({
    required this.product,
    this.quantity = 1,
  });

  /// Creates a copy of this CartItem with updated fields.
  /// Used for immutable state updates in the cart.
  CartItem copyWith({Product? product, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  /// Calculates the total price for this cart item (price × quantity).
  double get totalPrice => product.price * quantity;
}

/// Repository abstraction (Domain Layer)
/// 
/// Defines the contract for data access operations.
/// This allows us to swap implementations (in-memory, API, database)
/// without changing the business logic.
abstract class POSRepository {
  /// Fetches all available products from the data source.
  List<Product> fetchProducts();
  
  /// Finds a product by its barcode.
  /// Returns null if no product matches the barcode.
  Product? findByBarcode(String barcode);
}

/// Immutable state container for the POS feature.
/// 
/// This follows the immutable state pattern where all state changes
/// create a new state instance rather than mutating the existing one.
/// This makes state management predictable and easier to debug.
class POSState {
  final List<Product> products;
  final List<CartItem> cart;
  final String searchQuery;
  final String barcodeInput;
  final String paymentMethod;
  final double taxRate;

  const POSState({
    required this.products,
    required this.cart,
    required this.searchQuery,
    required this.barcodeInput,
    required this.paymentMethod,
    required this.taxRate,
  });

  POSState copyWith({
    List<Product>? products,
    List<CartItem>? cart,
    String? searchQuery,
    String? barcodeInput,
    String? paymentMethod,
    double? taxRate,
  }) {
    return POSState(
      products: products ?? this.products,
      cart: cart ?? this.cart,
      searchQuery: searchQuery ?? this.searchQuery,
      barcodeInput: barcodeInput ?? this.barcodeInput,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      taxRate: taxRate ?? this.taxRate,
    );
  }

  /// Filtered products by search query (name or category)
  List<Product> get filteredProducts {
    if (searchQuery.trim().isEmpty) return products;
    final query = searchQuery.toLowerCase();
    return products
        .where(
          (p) =>
              p.name.toLowerCase().contains(query) ||
              p.category.toLowerCase().contains(query),
        )
        .toList();
  }

  /// Calculates the subtotal by summing all cart item prices.
  double get subtotal =>
      cart.fold(0.0, (total, item) => total + item.totalPrice);

  /// Calculates the tax amount based on subtotal and tax rate.
  double get tax => subtotal * taxRate;

  /// Calculates the final total (subtotal + tax).
  double get total => subtotal + tax;
}

/// ------------------------------------------------------------
/// DATA LAYER
/// ------------------------------------------------------------

class InMemoryPOSRepository implements POSRepository {
  InMemoryPOSRepository();

  static const List<Product> _mockProducts = [
    Product(
      id: 'P001',
      name: 'Coca Cola 500ml',
      category: 'Beverages',
      price: 2.50,
      stock: 50,
    ),
    Product(
      id: 'P002',
      name: 'Lays Chips',
      category: 'Snacks',
      price: 1.99,
      stock: 30,
    ),
    Product(
      id: 'P003',
      name: 'Milk 1L',
      category: 'Dairy',
      price: 3.99,
      stock: 25,
    ),
    Product(
      id: 'P004',
      name: 'White Bread',
      category: 'Bakery',
      price: 2.49,
      stock: 40,
    ),
    Product(
      id: 'P005',
      name: 'Orange Juice 1L',
      category: 'Beverages',
      price: 4.99,
      stock: 20,
    ),
    Product(
      id: 'P006',
      name: 'Butter 250g',
      category: 'Dairy',
      price: 5.49,
      stock: 15,
    ),
    Product(
      id: 'P007',
      name: 'Coffee Beans 500g',
      category: 'Beverages',
      price: 12.99,
      stock: 10,
    ),
    Product(
      id: 'P008',
      name: 'Chocolate Bar',
      category: 'Snacks',
      price: 1.49,
      stock: 60,
    ),
  ];

  /// Barcode to Product ID mapping.
  /// 
  /// Maps scanned barcodes to product IDs for quick lookup.
  /// In a production system, this would typically be stored in a database
  /// and loaded dynamically. Each barcode maps to a unique product ID.
  /// 
  /// Example: Barcode '1001' → Product ID 'P001' (Coca Cola 500ml)
  final Map<String, String> barcodeMap = {
    '1001': 'P001', // Coca Cola 500ml
    '1002': 'P002', // Lays Chips
    '1003': 'P003', // Milk 1L
    '1004': 'P004', // White Bread
    '1005': 'P005', // Orange Juice 1L
    '1006': 'P006', // Butter 250g
    '1007': 'P007', // Coffee Beans 500g
    '1008': 'P008', // Chocolate Bar
  };

  @override
  List<Product> fetchProducts() {
    // In a real app, this might fetch from API/DB.
    return _mockProducts;
  }

  @override
  Product? findByBarcode(String barcode) {
    /// Looks up the product ID from the barcode mapping.
    /// Returns null if the barcode doesn't exist in the mapping.
    final productId = barcodeMap[barcode];
    if (productId == null) return null;
    
    /// Finds the product with the matching ID.
    /// Returns null if product not found (shouldn't happen in normal operation).
    try {
      return _mockProducts.firstWhere((p) => p.id == productId);
    } catch (e) {
      return null;
    }
  }
}

/// ------------------------------------------------------------
/// APPLICATION LAYER (CONTROLLER / USE CASES)
/// ------------------------------------------------------------
/// 
/// This layer contains the business logic and use cases.
/// It orchestrates domain entities and repository operations.
/// Controllers are pure functions that transform state.
/// ------------------------------------------------------------

/// Controller for Point of Sale operations.
/// 
/// Handles all business logic for the POS system including:
/// - Adding products to cart
/// - Managing cart quantities
/// - Processing barcode scans
/// - Calculating totals and taxes
class POSController {
  final POSRepository repository;

  const POSController({required this.repository});

  POSState initialState() {
    final products = repository.fetchProducts();
    return POSState(
      products: products,
      cart: const [],
      searchQuery: '',
      barcodeInput: '',
      paymentMethod: 'cash',
      taxRate: 0.1,
    );
  }

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

  /// Adds a product to the cart or increments its quantity if already present.
  /// 
  /// If the product already exists in the cart, increments its quantity by 1.
  /// Otherwise, adds a new cart item with quantity 1.
  /// Returns a new state with the updated cart.
  POSState addProductToCart(POSState state, Product product) {
    final List<CartItem> cart = List<CartItem>.from(state.cart);
    final index =
        cart.indexWhere((item) => item.product.id == product.id);

    if (index >= 0) {
      // Product already in cart - increment quantity
      final existing = cart[index];
      cart[index] = existing.copyWith(quantity: existing.quantity + 1);
    } else {
      // New product - add to cart with quantity 1
      cart.add(CartItem(product: product, quantity: 1));
    }

    return state.copyWith(cart: cart);
  }

  POSState updateCartItemQuantity(
    POSState state,
    CartItem item,
    int delta,
  ) {
    final List<CartItem> cart = List<CartItem>.from(state.cart);
    final index =
        cart.indexWhere((c) => c.product.id == item.product.id);
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
    return state.copyWith(
      cart: const [],
      paymentMethod: 'cash',
    );
  }

  /// Removes an item completely from the cart.
  /// 
  /// Unlike updateCartItemQuantity which can reduce to 0, this method
  /// immediately removes the item regardless of quantity.
  /// Returns a new state with the updated cart.
  POSState removeItem(POSState state, CartItem item) {
    final List<CartItem> cart = List<CartItem>.from(state.cart);
    cart.removeWhere((c) => c.product.id == item.product.id);
    return state.copyWith(cart: cart);
  }

  POSState addBarcodeToCart(POSState state) {
    final input = state.barcodeInput.trim();
    if (input.isEmpty) return state;

    final product = repository.findByBarcode(input);
    if (product == null) {
      // Could show error via UI if needed.
      return state.copyWith(barcodeInput: '');
    }

    final updated = addProductToCart(state, product);
    return updated.copyWith(barcodeInput: '');
  }
}

/// ------------------------------------------------------------
/// PRESENTATION LAYER
/// ------------------------------------------------------------

class POSPage extends StatefulWidget {
  const POSPage({super.key});

  @override
  State<POSPage> createState() => _POSPageState();
}

class _POSPageState extends State<POSPage> {
  late final POSController _controller;
  late POSState _state;

  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  bool _isSearchFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = POSController(repository: InMemoryPOSRepository());
    _state = _controller.initialState();

    _searchFocusNode.addListener(() {
      if (!mounted) return;
      setState(() {
        _isSearchFocused = _searchFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _barcodeController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  /// Handles search input changes.
  /// 
  /// Updates the search query in state, which triggers filteredProducts
  /// to recalculate and the UI to show matching products.
  void _onSearchChanged(String value) {
    setState(() {
      _state = _controller.setSearchQuery(_state, value);
    });
  }

  /// Processes a barcode scan and adds the corresponding product to cart.
  /// 
  /// The barcode is looked up in the barcodeMap to find the product,
  /// then added to the cart. The barcode input field is cleared after processing.
  void _addBarcodeToCart() {
    setState(() {
      _state = _controller.addBarcodeToCart(_state);
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

  /// Resets the search UI to show the cart view.
  /// 
  /// Clears the search query in state (which makes hasSearch = false),
  /// clears the search input field, and unfocuses the search field.
  /// This is called after adding a product to ensure the cart is visible.
  void _resetSearchUI() {
    setState(() {
      _state = _controller.resetSearch(_state);
    });
    _searchController.clear();
    _searchFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final products = _state.filteredProducts;
    
    /// IMPORTANT: Only check searchQuery, not _isSearchFocused
    /// 
    /// Why? FocusNode updates are asynchronous and can cause a ~50ms delay.
    /// If we check _isSearchFocused, the UI might show search results even
    /// after we've cleared the search query, causing the cart to not appear.
    /// 
    /// By only checking searchQuery (which is updated synchronously in setState),
    /// we ensure the UI switches to cart view immediately when search is cleared.
    final hasSearch = _state.searchQuery.isNotEmpty;

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
                // Left side - Search bar and Cart items list
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
                          onTap: () {
                            setState(() {
                              _isSearchFocused = true;
                            });
                          },
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
                      if (hasSearch)
                        Expanded(
                          child: Card(
                            child: _buildSearchableProductList(products),
                          ),
                        )
                      else
                        Expanded(
                          child: Card(
                            child: _buildCartItemsList(),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                // Right side - Barcode input and Payment summary
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
    );
  }

  /// -------------------- UI BUILDERS --------------------

  Widget _buildSearchableProductList(List<Product> products) {
    if (products.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
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

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return GestureDetector(
          onTap: () {
            /// When a product is tapped:
            /// 1. Add product to cart
            /// 2. Clear search query (this makes hasSearch = false)
            /// 3. Clear the search input field
            /// 4. Unfocus the search field
            /// 
            /// All state updates happen in one setState to ensure atomic updates.
            setState(() {
              // Add product to cart
              _state = _controller.addProductToCart(_state, product);
              // Clear search state - this ensures hasSearch becomes false immediately
              _state = _controller.resetSearch(_state);
            });
            
            // Clear controller and unfocus after state update
            // This happens outside setState to avoid triggering onChanged during state update
            _searchController.text = '';
            _searchFocusNode.unfocus();
          },
          child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
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
                  '\$${product.price.toStringAsFixed(2)}',
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
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 64,
                          color: AppTheme.textSecondary,
                        ),
                        SizedBox(height: 16),
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
                    itemCount: cart.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 24),
                    itemBuilder: (context, index) {
                      final item = cart[index];
                      return _CartItemRow(
                        item: item,
                        /// Increment quantity by 1
                        onIncrease: () {
                          setState(() {
                            _state = _controller.updateCartItemQuantity(
                              _state,
                              item,
                              1,
                            );
                          });
                        },
                        /// Decrement quantity by 1 (removes item if quantity reaches 0)
                        onDecrease: () {
                          setState(() {
                            _state = _controller.updateCartItemQuantity(
                              _state,
                              item,
                              -1,
                            );
                          });
                        },
                        /// Completely remove item from cart (regardless of quantity)
                        onRemove: () {
                          setState(() {
                            _state = _controller.removeItem(_state, item);
                          });
                        },
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
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _barcodeController,
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
              borderSide: const BorderSide(
                color: AppTheme.primaryBlue,
                width: 2,
              ),
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
          onChanged: (value) {
            setState(() {
              _state = _controller.setBarcodeInput(_state, value);
            });
          },
          onSubmitted: (_) {
            _addBarcodeToCart();
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      _KeypadButton('7',
                          onTap: () => _handleKeypadTap('7')),
                      const SizedBox(width: 12),
                      _KeypadButton('8',
                          onTap: () => _handleKeypadTap('8')),
                      const SizedBox(width: 12),
                      _KeypadButton('9',
                          onTap: () => _handleKeypadTap('9')),
                      const SizedBox(width: 12),
                      _KeypadButton('←',
                          onTap: () => _handleKeypadTap('←')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _KeypadButton('4',
                          onTap: () => _handleKeypadTap('4')),
                      const SizedBox(width: 12),
                      _KeypadButton('5',
                          onTap: () => _handleKeypadTap('5')),
                      const SizedBox(width: 12),
                      _KeypadButton('6',
                          onTap: () => _handleKeypadTap('6')),
                      const SizedBox(width: 12),
                      _KeypadButton('C',
                          onTap: () => _handleKeypadTap('C')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _KeypadButton('1',
                          onTap: () => _handleKeypadTap('1')),
                      const SizedBox(width: 12),
                      _KeypadButton('2',
                          onTap: () => _handleKeypadTap('2')),
                      const SizedBox(width: 12),
                      _KeypadButton('3',
                          onTap: () => _handleKeypadTap('3')),
                      const SizedBox(width: 12),
                      const SizedBox(width: 60),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const SizedBox(width: 60),
                      const SizedBox(width: 12),
                      _KeypadButton('0',
                          onTap: () => _handleKeypadTap('0')),
                      const SizedBox(width: 12),
                      const SizedBox(width: 60),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          _SummaryRow(label: 'Subtotal', value: _state.subtotal),
          const SizedBox(height: 8),
          _SummaryRow(label: 'Tax (10%)', value: _state.tax),
          const Divider(height: 32),
          _SummaryRow(
            label: 'Total',
            value: _state.total,
            isTotal: true,
          ),
          const SizedBox(height: 24),
          _buildPaymentMethodSelector(),
          const SizedBox(height: 24),
          PrimaryButton(
            onPressed: _state.cart.isEmpty
                ? null
                : () {
                    // Here you can also trigger printing logic.
                    setState(() {
                      _state = _controller.clearCart(_state);
                    });
                  },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.print, size: 20),
                SizedBox(width: 8),
                Text('Print Receipt'),
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
          onTap: () {
            setState(() {
              _state = _controller.setPaymentMethod(_state, id);
            });
          },
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
                color:
                    isSelected ? Colors.white : AppTheme.textPrimary,
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

/// ------------------------------------------------------------
/// PRESENTATION WIDGETS (small reusable pieces)
/// ------------------------------------------------------------

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
                ? const Icon(
                    Icons.backspace,
                    size: 20,
                    color: AppTheme.textPrimary,
                  )
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
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red, size: 20),
              onPressed: onRemove,
              tooltip: 'Remove item',
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              '\$${item.product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13,
              ),
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
