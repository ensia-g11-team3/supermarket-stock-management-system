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
  String get navThresholds => 'Thresholds';

  @override
  String get navLowStock => 'Low Stock Alerts';

  @override
  String get navStockMovement => 'Stock Movement';

  @override
  String get navUserManagement => 'User Management';

  @override
  String get logout => 'Logout';

  @override
  String get loggedInAs => 'Logged in as ';

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
  String get orderSummary => 'Purchase Summary';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get tax_10 => 'Tax(10%)';

  @override
  String get cash => 'Cash';

  @override
  String get card => 'Card';

  @override
  String get complete_transaction => 'Complete Transaction';

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
  String get edit => 'Edit';

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
  String get stockLevel => 'Stock Level';

  @override
  String get inStock => 'In Stock';

  @override
  String get lowStock => 'Low Stock';

  @override
  String get veryLowStock => 'Very Low Stock';

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
  String get selectCategoryMsg => 'Please select a category';

  @override
  String get productAddedMsg => 'Product added successfully';

  @override
  String get failedToLoadProductMsg => 'Failed to add product: ';

  @override
  String get enterProductDetails => 'Enter product details to add to inventory';

  @override
  String get plzEnterProductName => 'Please enter product name';

  @override
  String get plzEnterInitialQty => 'Please enter initial quantity';

  @override
  String get plzEnterValidNum => 'Please enter a valid number';

  @override
  String get plzEnterPrice => 'Please enter price';

  @override
  String get plzEnterValidPrice => 'Please enter a valid price';

  @override
  String get plzSelectCategory => 'Please select a category';

  @override
  String get productUpdatedMsg => 'Product updated successfully!';

  @override
  String get failedToUpdateProductMsg => 'Failed to update product:';

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
  String get deleteConfirm => 'Are you sure you want to delete';

  @override
  String get delete => 'Delete';

  @override
  String get deleted => 'deleted';

  @override
  String get viewBatches => 'View Batches';

  @override
  String get productBatchesTitle => 'Product Batches';

  @override
  String get manageBatchesDescription => 'Manage batches for this product';

  @override
  String get backToProducts => 'Back to Products';

  @override
  String get createNewBatch => 'Create New Batch';

  @override
  String get totalBatches => 'Total Batches';

  @override
  String get totalQuantity => 'Total Quantity';

  @override
  String get expired => 'Expired';

  @override
  String get nearExpiry => 'Near Expiry';

  @override
  String get noBatchesFound => 'No batches found for this product';

  @override
  String get createFirstBatch => 'Create your first batch';

  @override
  String get batchId => 'Batch ID';

  @override
  String get quantity => 'Quantity';

  @override
  String get mfgDate => 'Mfg. Date';

  @override
  String get expiryDate => 'Expiry Date';

  @override
  String get units => 'units';

  @override
  String get noExpiry => 'No Expiry';

  @override
  String get expiresIn => 'Expires in';

  @override
  String get days => 'days';

  @override
  String get valid => 'Valid';

  @override
  String get unknown => 'Unknown';

  @override
  String get editBatch => 'Edit Batch';

  @override
  String get deleteBatch => 'Delete Batch';

  @override
  String get deleteConfirmation => 'Are you sure you want to delete this batch?';

  @override
  String get deleteSuccess => 'deleted successfully';

  @override
  String get loadError => 'Failed to load batches';

  @override
  String get deleteError => 'Failed to delete batch';

  @override
  String get na => 'N/A';

  @override
  String get productLabel => 'Product';

  @override
  String get backToBatches => 'Back to Batches';

  @override
  String get enterQuantityHint => 'Enter batch quantity';

  @override
  String get pleaseEnterQuantity => 'Please enter quantity';

  @override
  String get enterValidNumber => 'Please enter a valid number';

  @override
  String get quantityGreaterThanZero => 'Quantity must be greater than 0';

  @override
  String get manufactureDate => 'Manufacture Date';

  @override
  String get notSelected => 'Not selected';

  @override
  String get updateBatch => 'Update Batch';

  @override
  String get createBatch => 'Create Batch';

  @override
  String get batchUpdatedSuccess => 'Batch updated successfully!';

  @override
  String get batchCreatedSuccess => 'Batch created successfully!';

  @override
  String get failedToLoadBatch => 'Failed to load batch';

  @override
  String get failedToSaveBatch => 'Failed to save batch';

  @override
  String get lowStockDescription => 'Monitor products with low inventory levels';

  @override
  String get totalAlerts => 'Total Alerts';

  @override
  String get lowStockItems => 'Low stock items';

  @override
  String get searchAlertsHint => 'Search by product name or category...';

  @override
  String get refresh => 'Refresh';

  @override
  String get noLowStockAlerts => 'No low stock alerts';

  @override
  String get noAlertsMatch => 'No alerts match your search';

  @override
  String get allStockSufficient => 'All products have sufficient stock levels';

  @override
  String get tryDifferentSearch => 'Try a different search term';

  @override
  String get currentStock => 'Current Stock';

  @override
  String get threshold => 'Threshold';

  @override
  String get notAvailable => 'N/A';

  @override
  String get critical => 'Critical';

  @override
  String get warning => 'Warning';

  @override
  String get categoryManagement => 'Category Management';

  @override
  String get totalCategories => 'Total Categories';

  @override
  String get totalProducts => 'Total Products';

  @override
  String get avgProducts => 'Avg Products/Category';

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String get deleteConfirmationMsg => 'Are you sure you want to delete this category? This action cannot be undone.';

  @override
  String get save => 'Save';

  @override
  String get successDelete => 'Category deleted successfully';

  @override
  String get failDelete => 'Failed to delete category';

  @override
  String get itemsLabel => 'items';

  @override
  String get errorDeletingCategory => 'Error deleting category: ';

  @override
  String get errorLoadingCategories => 'Error loading categories:';
}
