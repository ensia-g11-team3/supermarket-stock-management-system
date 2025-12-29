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
  /// **'Enter your username'**
  String get enterUsername;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
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
  /// **'Suppliers & Orders'**
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
  /// **'Select category'**
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

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

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
