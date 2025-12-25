// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Stockify';

  @override
  String get posSubtitle => 'Inventory Management System';

  @override
  String get loginWelcome => 'Welcome Back';

  @override
  String get username => 'Username';

  @override
  String get enterUsername => 'Enter your username';

  @override
  String get password => 'Password';

  @override
  String get enterPassword => 'Enter your password';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get signIn => 'Sign In';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navPos => 'Sales (POS)';

  @override
  String get navSalesHistory => 'Sales History';

  @override
  String get navProductList => 'Product List';

  @override
  String get navAddProduct => 'Add Product';

  @override
  String get navCategories => 'Categories';

  @override
  String get navSuppliers => 'Suppliers & Orders';

  @override
  String get navLowStock => 'Low Stock Alerts';

  @override
  String get navStockMovement => 'Stock Movement';

  @override
  String get navUserManagement => 'User Management';

  @override
  String get logout => 'Logout';

  @override
  String loggedInAs(String role) {
    return 'Logged in as $role';
  }

  @override
  String get posTitle => 'Point of Sale';

  @override
  String get posScanSearch => 'Scan or search for products to add to cart';

  @override
  String get searchItem => 'Scan or search item...';

  @override
  String get cartItems => 'Cart Items';

  @override
  String get cartEmpty => 'Cart is empty';

  @override
  String get addProductsToStart => 'Add products to start a sale';

  @override
  String get barcodeInput => 'Barcode Input';

  @override
  String get orderSummary => 'Order Summary';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get productTitle => 'Product List';

  @override
  String get productSubtitle => 'Manage your inventory products.';

  @override
  String get addNewProduct => 'Add New Product';

  @override
  String get editProduct => 'Edit Product';

  @override
  String get updateDetails => 'Update product details';

  @override
  String get filters => 'Filters';

  @override
  String get nameOrBarcode => 'Name or barcode...';

  @override
  String get allCategories => 'All Categories';

  @override
  String get allStockLevels => 'All Stock Levels';

  @override
  String get productName => 'Product Name';

  @override
  String get enterProductName => 'Enter product name';

  @override
  String get barcode => 'Barcode';

  @override
  String get barcodeNumber => 'Barcode Number';

  @override
  String get enterBarcode => 'Enter barcode number';

  @override
  String get category => 'Category';

  @override
  String get selectCategory => 'Select category';

  @override
  String get supplier => 'Supplier';

  @override
  String get enterSupplier => 'Enter supplier name';

  @override
  String get initialQuantity => 'Initial Quantity';

  @override
  String get buyingPrice => 'Buying Price (DA)';

  @override
  String get sellingPrice => 'Selling Price (DA)';

  @override
  String get description => 'Description';

  @override
  String get enterDescription => 'Enter product description (optional)';

  @override
  String get stock => 'Stock';

  @override
  String get actions => 'Actions';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get saveProduct => 'Save Product';

  @override
  String get cancel => 'Cancel';

  @override
  String get resetForm => 'Reset Form';

  @override
  String get backToProductList => 'Back to Product List';

  @override
  String get categoryTitle => 'Category Management';

  @override
  String get categorySubtitle => 'Organize products by categories';

  @override
  String get addCategory => 'Add Category';

  @override
  String get editCategory => 'Edit Category';

  @override
  String get categoryName => 'Category Name';

  @override
  String get productCount => 'Product Count';

  @override
  String items(int count) {
    return '$count items';
  }

  @override
  String get salesHistoryTitle => 'Sales History';

  @override
  String get salesHistorySubtitle => 'View and manage all transactions';

  @override
  String get exportReport => 'Export Report';

  @override
  String get searchTransaction => 'Search Transaction';

  @override
  String get transactionId => 'Transaction ID';

  @override
  String get date => 'Date';

  @override
  String get paymentMethod => 'Payment Method';

  @override
  String get allMethods => 'All Methods';

  @override
  String get cashier => 'Cashier';

  @override
  String get allCashiers => 'All Cashiers';

  @override
  String get totalTransactions => 'Total Transactions';

  @override
  String get totalSales => 'Total Sales';

  @override
  String get averageTransaction => 'Average Transaction';

  @override
  String get dateTime => 'Date & Time';

  @override
  String get status => 'Status';

  @override
  String get deleteProduct => 'Delete Product';

  @override
  String deleteConfirm(String productName) {
    return 'Are you sure you want to delete $productName?';
  }

  @override
  String get delete => 'Delete';
}
