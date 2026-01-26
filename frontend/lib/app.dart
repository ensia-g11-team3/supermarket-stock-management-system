import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import 'widgets/layout.dart';
import 'pages/login.dart';
import 'pages/dashboard_page.dart';
import 'pages/pos_page.dart';
import 'pages/sales_history_page.dart';
import 'pages/product_list_page.dart';
import 'pages/add_product_page.dart';
import 'pages/edit_product_page.dart';
import 'pages/categories_page.dart';
import 'pages/suppliers_page.dart';
import 'pages/alerts_page.dart';
import 'pages/stock_movement_page.dart';
import 'pages/user_list_page.dart';
import 'pages/create_user_page.dart';
import 'pages/edit_user_page.dart';
import 'pages/threshold_list_page.dart';
import 'pages/add_threshold_page.dart';
import 'pages/edit_threshold_page.dart';
import 'pages/product_batch_list.dart';
import 'pages/edit_batch_page.dart';

//localization: added by Nour
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

class StockifyApp extends StatelessWidget {
  const StockifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stockify',
      supportedLocales: const [
        Locale('fr'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: const Locale('fr'),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AppRouter(),
    );
  }
}

class AppRouter extends StatefulWidget {
  const AppRouter({super.key});

  @override
  State<AppRouter> createState() => _AppRouterState();
}

class _AppRouterState extends State<AppRouter> {
  bool _isAuthenticated = false;
  String _username = 'user';
  String _currentPage = 'dashboard';
  String? _editUserId;
  String? _editProductId;
  String? _editThresholdId;
  String? _userId;

  Key _productListKey = UniqueKey();
  Key _batchListKey = UniqueKey();

  // Batch-related state
  String? _batchProductId;
  String? _batchProductName;
  String? _editBatchId;

  void _handleLogin(String userId) {
    setState(() {
      _isAuthenticated = true;
      _userId = userId;
      _currentPage = 'pos';
    });
  }

  void _handleLogout() {
    setState(() {
      _isAuthenticated = false;
      _username = 'user';
      _currentPage = 'dashboard';
    });
  }

  void _navigateToPage(String page) {
    setState(() {
      if (page == 'products') _productListKey = UniqueKey();
      if (page == 'batches') _batchListKey = UniqueKey();
      _currentPage = page;
    });
  }

  Widget _renderPage() {
    switch (_currentPage) {
      case 'dashboard':
        return const DashboardPage();
      case 'pos':
        return POSPage(userId: _userId!);
      case 'history':
        return const SalesHistoryPage();
      case 'products':
        return ProductListPage(
          onNavigateToAdd: () => _navigateToPage('add-product'),
          onNavigateToEdit: (String productId) {
            setState(() {
              _editProductId = productId;
              _currentPage = 'edit-product';
            });
          },
          onNavigateToBatches: (String productId, String productName) {
            setState(() {
              _batchProductId = productId;
              _batchProductName = productName;
              _currentPage = 'batches';
            });
          },
        );
      case 'add-product':
        return const AddProductPage();
      case 'edit-product':
        return EditProductPage(
          productId: _editProductId ?? '1',
          onNavigateBack: () => _navigateToPage('products'),
          onProductUpdated: () => _navigateToPage('products'),
        );

      // Threshold pages
      case 'thresholds':
        return ThresholdListPage(
          onNavigateToAdd: () => _navigateToPage('add-threshold'),
          onNavigateToEdit: (String thresholdId) {
            setState(() {
              _editThresholdId = thresholdId;
              _currentPage = 'edit-threshold';
            });
          },
        );
      case 'add-threshold':
        return AddThresholdPage(
          onNavigateBack: () => _navigateToPage('thresholds'),
          onThresholdCreated: () => _navigateToPage('thresholds'),
        );
      case 'edit-threshold':
        return EditThresholdPage(
          thresholdId: _editThresholdId ?? '1',
          onNavigateBack: () => _navigateToPage('thresholds'),
          onThresholdUpdated: () => _navigateToPage('thresholds'),
        );

      // Batch pages
      case 'batches':
        return ProductBatchListPage(
          key: _batchListKey,
          productId: _batchProductId ?? '1',
          productName: _batchProductName ?? 'Product',
          onNavigateBack: () => _navigateToPage('products'),
          onNavigateToEdit: (String batchId) {
            setState(() {
              _editBatchId = batchId;
              _currentPage = 'edit-batch';
            });
          },
          onNavigateToCreate: () => _navigateToPage('create-batch'),
        );
      case 'create-batch':
        return CreateBatchPage(
          productId: _batchProductId ?? '1',
          productName: _batchProductName ?? 'Product',
          onNavigateBack: () => _navigateToPage('batches'),
          onBatchSaved: () => _navigateToPage('batches'),
        );
      case 'edit-batch':
        return CreateBatchPage(
          productId: _batchProductId ?? '1',
          productName: _batchProductName ?? 'Product',
          batchId: _editBatchId,
          onNavigateBack: () => _navigateToPage('batches'),
          onBatchSaved: () => _navigateToPage('batches'),
        );

      // Other pages
      case 'categories':
        return const CategoriesPage();
      case 'suppliers':
        return const SuppliersPage();
      case 'alerts':
        return const AlertsPage();
      case 'movements':
        return const StockMovementPage();
      case 'users':
        return UserListPage(
          onNavigateToCreate: () => _navigateToPage('create-user'),
          onNavigateToEdit: (String userId) {
            setState(() {
              _editUserId = userId;
              _currentPage = 'edit-user';
            });
          },
        );
      case 'create-user':
        return CreateUserPage(
          onNavigateBack: () => _navigateToPage('users'),
          onUserCreated: () => _navigateToPage('users'),
        );
      case 'edit-user':
        return EditUserPage(
          userId: _editUserId ?? '1',
          onNavigateBack: () => _navigateToPage('users'),
          onUserUpdated: () => _navigateToPage('users'),
        );

      default:
        return const DashboardPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAuthenticated) {
      return LoginPage(onLogin: _handleLogin);
    }

    return Layout(
      currentPage: _currentPage,
      onNavigate: _navigateToPage,
      username: _username,
      onLogout: _handleLogout,
      child: _renderPage(),
    );
  }
}
