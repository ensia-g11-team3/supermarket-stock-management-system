import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Stockify'**
  String get appName;

  /// No description provided for @posSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Inventory Management System'**
  String get posSubtitle;

  /// No description provided for @loginWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get loginWelcome;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @enterUsername.
  ///
  /// In en, this message translates to:
  /// **'Enter username'**
  String get enterUsername;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get enterPassword;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navPos.
  ///
  /// In en, this message translates to:
  /// **'Sales (POS)'**
  String get navPos;

  /// No description provided for @navSalesHistory.
  ///
  /// In en, this message translates to:
  /// **'Sales History'**
  String get navSalesHistory;

  /// No description provided for @navProductList.
  ///
  /// In en, this message translates to:
  /// **'Product List'**
  String get navProductList;

  /// No description provided for @navAddProduct.
  ///
  /// In en, this message translates to:
  /// **'Add Product'**
  String get navAddProduct;

  /// No description provided for @navCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get navCategories;

  /// No description provided for @navSuppliers.
  ///
  /// In en, this message translates to:
  /// **'Suppliers & Orders'**
  String get navSuppliers;

  /// No description provided for @navThresholds.
  ///
  /// In en, this message translates to:
  /// **'Thresholds'**
  String get navThresholds;

  /// No description provided for @navLowStock.
  ///
  /// In en, this message translates to:
  /// **'Low Stock Alerts'**
  String get navLowStock;

  /// No description provided for @navStockMovement.
  ///
  /// In en, this message translates to:
  /// **'Stock Movement'**
  String get navStockMovement;

  /// No description provided for @navUserManagement.
  ///
  /// In en, this message translates to:
  /// **'User Management'**
  String get navUserManagement;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @loggedInAs.
  ///
  /// In en, this message translates to:
  /// **'Logged in as '**
  String get loggedInAs;

  /// No description provided for @posTitle.
  ///
  /// In en, this message translates to:
  /// **'Point of Sale'**
  String get posTitle;

  /// No description provided for @posScanSearch.
  ///
  /// In en, this message translates to:
  /// **'Scan or search for products to add to cart'**
  String get posScanSearch;

  /// No description provided for @searchItem.
  ///
  /// In en, this message translates to:
  /// **'Scan or search item...'**
  String get searchItem;

  /// No description provided for @cartItems.
  ///
  /// In en, this message translates to:
  /// **'Cart Items'**
  String get cartItems;

  /// No description provided for @cartEmpty.
  ///
  /// In en, this message translates to:
  /// **'Cart is empty'**
  String get cartEmpty;

  /// No description provided for @addProductsToStart.
  ///
  /// In en, this message translates to:
  /// **'Add products to start a sale'**
  String get addProductsToStart;

  /// No description provided for @barcodeInput.
  ///
  /// In en, this message translates to:
  /// **'Barcode Input'**
  String get barcodeInput;

  /// No description provided for @orderSummary.
  ///
  /// In en, this message translates to:
  /// **'Purchase Summary'**
  String get orderSummary;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @tax_10.
  ///
  /// In en, this message translates to:
  /// **'Tax(10%)'**
  String get tax_10;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @card.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get card;

  /// No description provided for @complete_transaction.
  ///
  /// In en, this message translates to:
  /// **'Complete Transaction'**
  String get complete_transaction;

  /// No description provided for @productTitle.
  ///
  /// In en, this message translates to:
  /// **'Product List'**
  String get productTitle;

  /// No description provided for @productSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your inventory products.'**
  String get productSubtitle;

  /// No description provided for @addNewProduct.
  ///
  /// In en, this message translates to:
  /// **'Add New Product'**
  String get addNewProduct;

  /// No description provided for @editProduct.
  ///
  /// In en, this message translates to:
  /// **'Edit Product'**
  String get editProduct;

  /// No description provided for @updateDetails.
  ///
  /// In en, this message translates to:
  /// **'Update product details'**
  String get updateDetails;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @nameOrBarcode.
  ///
  /// In en, this message translates to:
  /// **'Name or barcode...'**
  String get nameOrBarcode;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All Categories'**
  String get allCategories;

  /// No description provided for @allStockLevels.
  ///
  /// In en, this message translates to:
  /// **'All Stock Levels'**
  String get allStockLevels;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @productName.
  ///
  /// In en, this message translates to:
  /// **'Product Name'**
  String get productName;

  /// No description provided for @enterProductName.
  ///
  /// In en, this message translates to:
  /// **'Enter product name'**
  String get enterProductName;

  /// No description provided for @barcode.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get barcode;

  /// No description provided for @barcodeNumber.
  ///
  /// In en, this message translates to:
  /// **'Barcode Number'**
  String get barcodeNumber;

  /// No description provided for @enterBarcode.
  ///
  /// In en, this message translates to:
  /// **'Enter barcode number'**
  String get enterBarcode;

  /// No description provided for @stockLevel.
  ///
  /// In en, this message translates to:
  /// **'Stock Level'**
  String get stockLevel;

  /// No description provided for @inStock.
  ///
  /// In en, this message translates to:
  /// **'In Stock'**
  String get inStock;

  /// No description provided for @lowStock.
  ///
  /// In en, this message translates to:
  /// **'Low Stock'**
  String get lowStock;

  /// No description provided for @veryLowStock.
  ///
  /// In en, this message translates to:
  /// **'Very Low Stock'**
  String get veryLowStock;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get selectCategory;

  /// No description provided for @supplier.
  ///
  /// In en, this message translates to:
  /// **'Supplier'**
  String get supplier;

  /// No description provided for @enterSupplier.
  ///
  /// In en, this message translates to:
  /// **'Enter supplier name'**
  String get enterSupplier;

  /// No description provided for @initialQuantity.
  ///
  /// In en, this message translates to:
  /// **'Initial Quantity'**
  String get initialQuantity;

  /// No description provided for @buyingPrice.
  ///
  /// In en, this message translates to:
  /// **'Buying Price (DA)'**
  String get buyingPrice;

  /// No description provided for @sellingPrice.
  ///
  /// In en, this message translates to:
  /// **'Selling Price (DA)'**
  String get sellingPrice;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @enterDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter product description (optional)'**
  String get enterDescription;

  /// No description provided for @stock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get stock;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @selectCategoryMsg.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get selectCategoryMsg;

  /// No description provided for @productAddedMsg.
  ///
  /// In en, this message translates to:
  /// **'Product added successfully'**
  String get productAddedMsg;

  /// No description provided for @failedToLoadProductMsg.
  ///
  /// In en, this message translates to:
  /// **'Failed to add product: '**
  String get failedToLoadProductMsg;

  /// No description provided for @enterProductDetails.
  ///
  /// In en, this message translates to:
  /// **'Enter product details to add to inventory'**
  String get enterProductDetails;

  /// No description provided for @plzEnterProductName.
  ///
  /// In en, this message translates to:
  /// **'Please enter product name'**
  String get plzEnterProductName;

  /// No description provided for @plzEnterInitialQty.
  ///
  /// In en, this message translates to:
  /// **'Please enter initial quantity'**
  String get plzEnterInitialQty;

  /// No description provided for @plzEnterValidNum.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get plzEnterValidNum;

  /// No description provided for @plzEnterPrice.
  ///
  /// In en, this message translates to:
  /// **'Please enter price'**
  String get plzEnterPrice;

  /// No description provided for @plzEnterValidPrice.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid price'**
  String get plzEnterValidPrice;

  /// No description provided for @plzSelectCategory.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get plzSelectCategory;

  /// No description provided for @productUpdatedMsg.
  ///
  /// In en, this message translates to:
  /// **'Product updated successfully!'**
  String get productUpdatedMsg;

  /// No description provided for @failedToUpdateProductMsg.
  ///
  /// In en, this message translates to:
  /// **'Failed to update product:'**
  String get failedToUpdateProductMsg;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @saveProduct.
  ///
  /// In en, this message translates to:
  /// **'Save Product'**
  String get saveProduct;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @resetForm.
  ///
  /// In en, this message translates to:
  /// **'Reset Form'**
  String get resetForm;

  /// No description provided for @backToProductList.
  ///
  /// In en, this message translates to:
  /// **'Back to Product List'**
  String get backToProductList;

  /// No description provided for @categoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Category Management'**
  String get categoryTitle;

  /// No description provided for @categorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Organize products by categories'**
  String get categorySubtitle;

  /// No description provided for @addCategory.
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get addCategory;

  /// No description provided for @editCategory.
  ///
  /// In en, this message translates to:
  /// **'Edit Category'**
  String get editCategory;

  /// No description provided for @categoryName.
  ///
  /// In en, this message translates to:
  /// **'Category Name'**
  String get categoryName;

  /// No description provided for @productCount.
  ///
  /// In en, this message translates to:
  /// **'Product Count'**
  String get productCount;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String items(int count);

  /// No description provided for @salesHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Sales History'**
  String get salesHistoryTitle;

  /// No description provided for @salesHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'View and manage all transactions'**
  String get salesHistorySubtitle;

  /// No description provided for @exportReport.
  ///
  /// In en, this message translates to:
  /// **'Export Report'**
  String get exportReport;

  /// No description provided for @searchTransaction.
  ///
  /// In en, this message translates to:
  /// **'Search Transaction'**
  String get searchTransaction;

  /// No description provided for @transactionId.
  ///
  /// In en, this message translates to:
  /// **'Transaction ID'**
  String get transactionId;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @allMethods.
  ///
  /// In en, this message translates to:
  /// **'All Methods'**
  String get allMethods;

  /// No description provided for @cashier.
  ///
  /// In en, this message translates to:
  /// **'Cashier'**
  String get cashier;

  /// No description provided for @allCashiers.
  ///
  /// In en, this message translates to:
  /// **'All Cashiers'**
  String get allCashiers;

  /// No description provided for @totalTransactions.
  ///
  /// In en, this message translates to:
  /// **'Total Transactions'**
  String get totalTransactions;

  /// No description provided for @totalSales.
  ///
  /// In en, this message translates to:
  /// **'Total Sales'**
  String get totalSales;

  /// No description provided for @averageTransaction.
  ///
  /// In en, this message translates to:
  /// **'Average Transaction'**
  String get averageTransaction;

  /// No description provided for @dateTime.
  ///
  /// In en, this message translates to:
  /// **'Date & Time'**
  String get dateTime;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  String get transactionIdPlaceholder;

  String get datePlaceholder;

  String get mobilePayment;

  String get loadMore;

  String get noTransactionsFound;

  String get total;

  String get payment;

  String get transactionDetails;

  String get totalAmount;

  String get paymentMethodLabel;

  String get cashierLabel;

  String get itemsPurchased;

  String get errorLoadingTransactions;

  String get errorLoadingDetails;

  String get noItemsFound;

  String get close;

  /// No description provided for @deleteProduct.
  ///
  /// In en, this message translates to:
  /// **'Delete Product'**
  String get deleteProduct;

  /// No description provided for @deleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete'**
  String get deleteConfirm;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleted.
  ///
  /// In en, this message translates to:
  /// **'deleted'**
  String get deleted;

  /// No description provided for @viewBatches.
  ///
  /// In en, this message translates to:
  /// **'View Batches'**
  String get viewBatches;

  /// No description provided for @productBatchesTitle.
  ///
  /// In en, this message translates to:
  /// **'Product Batches'**
  String get productBatchesTitle;

  /// No description provided for @manageBatchesDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage batches for this product'**
  String get manageBatchesDescription;

  /// No description provided for @backToProducts.
  ///
  /// In en, this message translates to:
  /// **'Back to Products'**
  String get backToProducts;

  /// No description provided for @createNewBatch.
  ///
  /// In en, this message translates to:
  /// **'Create New Batch'**
  String get createNewBatch;

  /// No description provided for @totalBatches.
  ///
  /// In en, this message translates to:
  /// **'Total Batches'**
  String get totalBatches;

  /// No description provided for @totalQuantity.
  ///
  /// In en, this message translates to:
  /// **'Total Quantity'**
  String get totalQuantity;

  /// No description provided for @expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// No description provided for @nearExpiry.
  ///
  /// In en, this message translates to:
  /// **'Near Expiry'**
  String get nearExpiry;

  /// No description provided for @noBatchesFound.
  ///
  /// In en, this message translates to:
  /// **'No batches found for this product'**
  String get noBatchesFound;

  /// No description provided for @createFirstBatch.
  ///
  /// In en, this message translates to:
  /// **'Create your first batch'**
  String get createFirstBatch;

  /// No description provided for @batchId.
  ///
  /// In en, this message translates to:
  /// **'Batch ID'**
  String get batchId;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @mfgDate.
  ///
  /// In en, this message translates to:
  /// **'Mfg. Date'**
  String get mfgDate;

  /// No description provided for @expiryDate.
  ///
  /// In en, this message translates to:
  /// **'Expiry Date'**
  String get expiryDate;

  /// No description provided for @units.
  ///
  /// In en, this message translates to:
  /// **'units'**
  String get units;

  /// No description provided for @noExpiry.
  ///
  /// In en, this message translates to:
  /// **'No Expiry'**
  String get noExpiry;

  /// No description provided for @expiresIn.
  ///
  /// In en, this message translates to:
  /// **'Expires in'**
  String get expiresIn;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @valid.
  ///
  /// In en, this message translates to:
  /// **'Valid'**
  String get valid;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @editBatch.
  ///
  /// In en, this message translates to:
  /// **'Edit Batch'**
  String get editBatch;

  /// No description provided for @deleteBatch.
  ///
  /// In en, this message translates to:
  /// **'Delete Batch'**
  String get deleteBatch;

  /// No description provided for @deleteConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this user?'**
  String get deleteConfirmation;

  /// No description provided for @deleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'deleted successfully'**
  String get deleteSuccess;

  /// No description provided for @loadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load batches'**
  String get loadError;

  /// No description provided for @deleteError.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete batch'**
  String get deleteError;

  /// No description provided for @na.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get na;

  /// No description provided for @productLabel.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get productLabel;

  /// No description provided for @backToBatches.
  ///
  /// In en, this message translates to:
  /// **'Back to Batches'**
  String get backToBatches;

  /// No description provided for @enterQuantityHint.
  ///
  /// In en, this message translates to:
  /// **'Enter batch quantity'**
  String get enterQuantityHint;

  /// No description provided for @pleaseEnterQuantity.
  ///
  /// In en, this message translates to:
  /// **'Please enter quantity'**
  String get pleaseEnterQuantity;

  /// No description provided for @enterValidNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get enterValidNumber;

  /// No description provided for @quantityGreaterThanZero.
  ///
  /// In en, this message translates to:
  /// **'Quantity must be greater than 0'**
  String get quantityGreaterThanZero;

  /// No description provided for @manufactureDate.
  ///
  /// In en, this message translates to:
  /// **'Manufacture Date'**
  String get manufactureDate;

  /// No description provided for @notSelected.
  ///
  /// In en, this message translates to:
  /// **'Not selected'**
  String get notSelected;

  /// No description provided for @updateBatch.
  ///
  /// In en, this message translates to:
  /// **'Update Batch'**
  String get updateBatch;

  /// No description provided for @createBatch.
  ///
  /// In en, this message translates to:
  /// **'Create Batch'**
  String get createBatch;

  /// No description provided for @batchUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Batch updated successfully!'**
  String get batchUpdatedSuccess;

  /// No description provided for @batchCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Batch created successfully!'**
  String get batchCreatedSuccess;

  /// No description provided for @failedToLoadBatch.
  ///
  /// In en, this message translates to:
  /// **'Failed to load batch'**
  String get failedToLoadBatch;

  /// No description provided for @failedToSaveBatch.
  ///
  /// In en, this message translates to:
  /// **'Failed to save batch'**
  String get failedToSaveBatch;

  /// No description provided for @lowStockDescription.
  ///
  /// In en, this message translates to:
  /// **'Monitor products with low inventory levels'**
  String get lowStockDescription;

  /// No description provided for @totalAlerts.
  ///
  /// In en, this message translates to:
  /// **'Total Alerts'**
  String get totalAlerts;

  /// No description provided for @lowStockItems.
  ///
  /// In en, this message translates to:
  /// **'Low stock items'**
  String get lowStockItems;

  /// No description provided for @searchAlertsHint.
  ///
  /// In en, this message translates to:
  /// **'Search by product name or category...'**
  String get searchAlertsHint;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @noLowStockAlerts.
  ///
  /// In en, this message translates to:
  /// **'No low stock alerts'**
  String get noLowStockAlerts;

  /// No description provided for @noAlertsMatch.
  ///
  /// In en, this message translates to:
  /// **'No alerts match your search'**
  String get noAlertsMatch;

  /// No description provided for @allStockSufficient.
  ///
  /// In en, this message translates to:
  /// **'All products have sufficient stock levels'**
  String get allStockSufficient;

  /// No description provided for @tryDifferentSearch.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term'**
  String get tryDifferentSearch;

  /// No description provided for @currentStock.
  ///
  /// In en, this message translates to:
  /// **'Current Stock'**
  String get currentStock;

  /// No description provided for @threshold.
  ///
  /// In en, this message translates to:
  /// **'Threshold'**
  String get threshold;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get notAvailable;

  /// No description provided for @critical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get critical;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @categoryManagement.
  ///
  /// In en, this message translates to:
  /// **'Category Management'**
  String get categoryManagement;

  /// No description provided for @totalCategories.
  ///
  /// In en, this message translates to:
  /// **'Total Categories'**
  String get totalCategories;

  /// No description provided for @totalProducts.
  ///
  /// In en, this message translates to:
  /// **'Total Products'**
  String get totalProducts;

  /// No description provided for @avgProducts.
  ///
  /// In en, this message translates to:
  /// **'Avg Products/Category'**
  String get avgProducts;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDelete;

  /// No description provided for @deleteConfirmationMsg.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this category? This action cannot be undone.'**
  String get deleteConfirmationMsg;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @successDelete.
  ///
  /// In en, this message translates to:
  /// **'Category deleted successfully'**
  String get successDelete;

  /// No description provided for @failDelete.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete category'**
  String get failDelete;

  /// No description provided for @itemsLabel.
  ///
  /// In en, this message translates to:
  /// **'items'**
  String get itemsLabel;

  /// No description provided for @errorDeletingCategory.
  ///
  /// In en, this message translates to:
  /// **'Error deleting category: '**
  String get errorDeletingCategory;

  /// No description provided for @errorLoadingCategories.
  ///
  /// In en, this message translates to:
  /// **'Error loading categories:'**
  String get errorLoadingCategories;

  /// No description provided for @errorLoadingProducts.
  ///
  /// In en, this message translates to:
  /// **'Error loading products: '**
  String get errorLoadingProducts;

  /// No description provided for @thresholdManagement.
  ///
  /// In en, this message translates to:
  /// **'Threshold Management'**
  String get thresholdManagement;

  /// No description provided for @thresholdSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage low-stock thresholds for products and categories'**
  String get thresholdSubtitle;

  /// No description provided for @addThreshold.
  ///
  /// In en, this message translates to:
  /// **'Add Threshold'**
  String get addThreshold;

  /// No description provided for @editThreshold.
  ///
  /// In en, this message translates to:
  /// **'Edit Threshold'**
  String get editThreshold;

  /// No description provided for @thresholdInfo.
  ///
  /// In en, this message translates to:
  /// **'Threshold Information'**
  String get thresholdInfo;

  /// No description provided for @thresholdType.
  ///
  /// In en, this message translates to:
  /// **'Threshold Type'**
  String get thresholdType;

  /// No description provided for @totalProductThresholds.
  ///
  /// In en, this message translates to:
  /// **'Total Product Thresholds'**
  String get totalProductThresholds;

  /// No description provided for @noThresholdsFound.
  ///
  /// In en, this message translates to:
  /// **'No thresholds found'**
  String get noThresholdsFound;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search by product or category name...'**
  String get searchPlaceholder;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @productCategory.
  ///
  /// In en, this message translates to:
  /// **'Product/Category'**
  String get productCategory;

  /// No description provided for @thresholdValue.
  ///
  /// In en, this message translates to:
  /// **'Threshold Value'**
  String get thresholdValue;

  /// No description provided for @createdAt.
  ///
  /// In en, this message translates to:
  /// **'Created At'**
  String get createdAt;

  /// No description provided for @product.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get product;

  /// No description provided for @setProductThreshold.
  ///
  /// In en, this message translates to:
  /// **'Set threshold for a specific product'**
  String get setProductThreshold;

  /// No description provided for @setCategoryThreshold.
  ///
  /// In en, this message translates to:
  /// **'Set threshold for all products in category'**
  String get setCategoryThreshold;

  /// No description provided for @selectProduct.
  ///
  /// In en, this message translates to:
  /// **'Select Product'**
  String get selectProduct;

  /// No description provided for @chooseProduct.
  ///
  /// In en, this message translates to:
  /// **'Choose a product...'**
  String get chooseProduct;

  /// No description provided for @chooseCategory.
  ///
  /// In en, this message translates to:
  /// **'Choose a category...'**
  String get chooseCategory;

  /// No description provided for @enterThresholdValue.
  ///
  /// In en, this message translates to:
  /// **'Enter threshold value...'**
  String get enterThresholdValue;

  /// No description provided for @backToList.
  ///
  /// In en, this message translates to:
  /// **'Back to List'**
  String get backToList;

  /// No description provided for @saveThreshold.
  ///
  /// In en, this message translates to:
  /// **'Save Threshold'**
  String get saveThreshold;

  /// No description provided for @deleteThreshold.
  ///
  /// In en, this message translates to:
  /// **'Delete Threshold'**
  String get deleteThreshold;

  /// No description provided for @deleteThresholdConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the threshold for this item?'**
  String get deleteThresholdConfirm;

  /// No description provided for @errorLoadingThresholds.
  ///
  /// In en, this message translates to:
  /// **'Error loading thresholds:'**
  String get errorLoadingThresholds;

  /// No description provided for @errorLoadingData.
  ///
  /// In en, this message translates to:
  /// **'Error loading data:'**
  String get errorLoadingData;

  /// No description provided for @errorDeletingThreshold.
  ///
  /// In en, this message translates to:
  /// **'Error deleting threshold:'**
  String get errorDeletingThreshold;

  /// No description provided for @errorCreatingThreshold.
  ///
  /// In en, this message translates to:
  /// **'Error creating threshold:'**
  String get errorCreatingThreshold;

  /// No description provided for @thresholdDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Threshold deleted successfully'**
  String get thresholdDeleteSuccess;

  /// No description provided for @thresholdCreateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Threshold created successfully'**
  String get thresholdCreateSuccess;

  /// No description provided for @thresholdUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Threshold updated successfully'**
  String get thresholdUpdateSuccess;

  /// No description provided for @pleaseSelectProduct.
  ///
  /// In en, this message translates to:
  /// **'Please select a product'**
  String get pleaseSelectProduct;

  /// No description provided for @pleaseSelectCategory.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get pleaseSelectCategory;

  /// No description provided for @pleaseEnterValue.
  ///
  /// In en, this message translates to:
  /// **'Please enter a threshold value'**
  String get pleaseEnterValue;

  /// No description provided for @pleaseEnterPositive.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid positive number'**
  String get pleaseEnterPositive;

  /// No description provided for @addThresholdDescription.
  ///
  /// In en, this message translates to:
  /// **'Create a new low-stock threshold for a product or category'**
  String get addThresholdDescription;

  /// No description provided for @editThresholdDescription.
  ///
  /// In en, this message translates to:
  /// **'Modify the low-stock threshold value'**
  String get editThresholdDescription;

  /// No description provided for @thresholdInformation.
  ///
  /// In en, this message translates to:
  /// **'Threshold Information'**
  String get thresholdInformation;

  /// No description provided for @productThreshold.
  ///
  /// In en, this message translates to:
  /// **'Product Threshold'**
  String get productThreshold;

  /// No description provided for @categoryThreshold.
  ///
  /// In en, this message translates to:
  /// **'Category Threshold'**
  String get categoryThreshold;

  /// No description provided for @categoryWarningNote.
  ///
  /// In en, this message translates to:
  /// **'Note: Updating this threshold will apply to all products in this category'**
  String get categoryWarningNote;

  /// No description provided for @thresholdValueLabel.
  ///
  /// In en, this message translates to:
  /// **'Threshold Value'**
  String get thresholdValueLabel;

  /// No description provided for @thresholdValueHint.
  ///
  /// In en, this message translates to:
  /// **'Enter threshold value...'**
  String get thresholdValueHint;

  /// No description provided for @removeThreshold.
  ///
  /// In en, this message translates to:
  /// **'Remove Threshold'**
  String get removeThreshold;

  /// No description provided for @updateThreshold.
  ///
  /// In en, this message translates to:
  /// **'Update Threshold'**
  String get updateThreshold;

  /// No description provided for @confirmUpdateTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Threshold Update'**
  String get confirmUpdateTitle;

  /// No description provided for @confirmUpdateBody.
  ///
  /// In en, this message translates to:
  /// **'Old threshold'**
  String get confirmUpdateBody;

  /// No description provided for @newThreshold.
  ///
  /// In en, this message translates to:
  /// **'New threshold'**
  String get newThreshold;

  /// No description provided for @categoryWarningDetail.
  ///
  /// In en, this message translates to:
  /// **'This will update ALL products in the category: '**
  String get categoryWarningDetail;

  /// No description provided for @productSuccessDetail.
  ///
  /// In en, this message translates to:
  /// **'This will update the threshold only for: '**
  String get productSuccessDetail;

  /// No description provided for @removeConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove Threshold'**
  String get removeConfirmTitle;

  /// No description provided for @removeConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this threshold? \n\nNote: For product thresholds, this will set the threshold to null. For category thresholds, this will set threshold to null for all products under this category.'**
  String get removeConfirmBody;

  /// No description provided for @successUpdate.
  ///
  /// In en, this message translates to:
  /// **'Threshold updated successfully'**
  String get successUpdate;

  /// No description provided for @successRemove.
  ///
  /// In en, this message translates to:
  /// **'Threshold removed successfully'**
  String get successRemove;

  /// No description provided for @errorUpdate.
  ///
  /// In en, this message translates to:
  /// **'Error updating threshold: '**
  String get errorUpdate;

  /// No description provided for @errorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading threshold: '**
  String get errorLoading;

  /// No description provided for @validationEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter a threshold value'**
  String get validationEmpty;

  /// No description provided for @validationInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid positive number'**
  String get validationInvalid;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @userManagement.
  ///
  /// In en, this message translates to:
  /// **'User Management'**
  String get userManagement;

  /// No description provided for @userManagementDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage system users and their permissions.'**
  String get userManagementDesc;

  /// No description provided for @addUser.
  ///
  /// In en, this message translates to:
  /// **'Add User'**
  String get addUser;

  /// No description provided for @filtersAndSearch.
  ///
  /// In en, this message translates to:
  /// **'Filters & Search'**
  String get filtersAndSearch;

  /// No description provided for @userSearchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search by name, email, phone, or role...'**
  String get userSearchPlaceholder;

  /// No description provided for @filterByRole.
  ///
  /// In en, this message translates to:
  /// **'Filter by Role'**
  String get filterByRole;

  /// No description provided for @filterByStatus.
  ///
  /// In en, this message translates to:
  /// **'Filter by Status'**
  String get filterByStatus;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get sortBy;

  /// No description provided for @allRoles.
  ///
  /// In en, this message translates to:
  /// **'All Roles'**
  String get allRoles;

  /// No description provided for @allStatus.
  ///
  /// In en, this message translates to:
  /// **'All Status'**
  String get allStatus;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @sortName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get sortName;

  /// No description provided for @sortDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get sortDate;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @deleteUser.
  ///
  /// In en, this message translates to:
  /// **'Delete User'**
  String get deleteUser;

  /// No description provided for @cannotBeUndone.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get cannotBeUndone;

  /// No description provided for @userDeleted.
  ///
  /// In en, this message translates to:
  /// **'deleted'**
  String get userDeleted;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @errorLoadingUsers.
  ///
  /// In en, this message translates to:
  /// **'Failed to load users: '**
  String get errorLoadingUsers;

  /// No description provided for @errorDeletingUser.
  ///
  /// In en, this message translates to:
  /// **'Could not delete user. Check your connection.'**
  String get errorDeletingUser;

  /// No description provided for @errorUnexpected.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred: '**
  String get errorUnexpected;

  /// No description provided for @noUsersFound.
  ///
  /// In en, this message translates to:
  /// **'No users found matching your criteria.'**
  String get noUsersFound;

  /// No description provided for @createNewUser.
  ///
  /// In en, this message translates to:
  /// **'Create New User'**
  String get createNewUser;

  /// No description provided for @addNewUserDescription.
  ///
  /// In en, this message translates to:
  /// **'Add a new user to the system'**
  String get addNewUserDescription;

  /// No description provided for @backToUserList.
  ///
  /// In en, this message translates to:
  /// **'Back to User List'**
  String get backToUserList;

  /// No description provided for @basicInformation.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInformation;

  /// No description provided for @enterFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter full name'**
  String get enterFullName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'user@example.com'**
  String get emailHint;

  /// No description provided for @passwordRules.
  ///
  /// In en, this message translates to:
  /// **'Must contain at least 8 characters, one uppercase letter, and one number'**
  String get passwordRules;

  /// No description provided for @rolePermissions.
  ///
  /// In en, this message translates to:
  /// **'Role & Permissions'**
  String get rolePermissions;

  /// No description provided for @roleAutoFill.
  ///
  /// In en, this message translates to:
  /// **'Selecting a role will auto-fill default permissions'**
  String get roleAutoFill;

  /// No description provided for @permissions.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get permissions;

  /// No description provided for @createUser.
  ///
  /// In en, this message translates to:
  /// **'Create User'**
  String get createUser;

  /// No description provided for @usernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get usernameRequired;

  /// No description provided for @fullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get fullNameRequired;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneRequired;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get emailInvalid;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordMinLength;

  /// No description provided for @passwordUppercase.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one uppercase letter'**
  String get passwordUppercase;

  /// No description provided for @passwordNumber.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one number'**
  String get passwordNumber;

  /// No description provided for @userCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'User created successfully'**
  String get userCreatedSuccess;

  /// No description provided for @failedAddUser.
  ///
  /// In en, this message translates to:
  /// **'Failed to add user'**
  String get failedAddUser;

  /// No description provided for @editUser.
  ///
  /// In en, this message translates to:
  /// **'Edit User'**
  String get editUser;

  /// No description provided for @editingUser.
  ///
  /// In en, this message translates to:
  /// **'Editing user:'**
  String get editingUser;

  /// No description provided for @userInformation.
  ///
  /// In en, this message translates to:
  /// **'User Information'**
  String get userInformation;

  /// No description provided for @userStatus.
  ///
  /// In en, this message translates to:
  /// **'Status: '**
  String get userStatus;

  /// No description provided for @user_created.
  ///
  /// In en, this message translates to:
  /// **'Created: '**
  String get user_created;

  /// No description provided for @pleaseEnterUsername.
  ///
  /// In en, this message translates to:
  /// **'Please enter username'**
  String get pleaseEnterUsername;

  /// No description provided for @pleaseEnterFullName.
  ///
  /// In en, this message translates to:
  /// **'Please enter full name'**
  String get pleaseEnterFullName;

  /// No description provided for @pleaseEnterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter phone number'**
  String get pleaseEnterPhoneNumber;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter email'**
  String get pleaseEnterEmail;

  /// No description provided for @pleaseEnterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get pleaseEnterValidEmail;

  /// No description provided for @selectRoleRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a role'**
  String get selectRoleRequired;

  /// No description provided for @roleResetPermissions.
  ///
  /// In en, this message translates to:
  /// **'Selecting a role will reset permissions to defaults'**
  String get roleResetPermissions;

  /// No description provided for @userUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'User updated successfully!'**
  String get userUpdatedSuccess;

  /// No description provided for @failedLoadUser.
  ///
  /// In en, this message translates to:
  /// **'Failed to load user: '**
  String get failedLoadUser;

  /// No description provided for @failedUpdateUser.
  ///
  /// In en, this message translates to:
  /// **'Failed to update user: '**
  String get failedUpdateUser;

  /// No description provided for @roleAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get roleAdmin;

  /// No description provided for @roleInventoryManager.
  ///
  /// In en, this message translates to:
  /// **'Inventory Manager'**
  String get roleInventoryManager;

  /// No description provided for @roleInventoryStaff.
  ///
  /// In en, this message translates to:
  /// **'Inventory Staff'**
  String get roleInventoryStaff;

  /// No description provided for @rolePOSWorker.
  ///
  /// In en, this message translates to:
  /// **'POS Worker'**
  String get rolePOSWorker;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
