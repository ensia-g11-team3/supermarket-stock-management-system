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

class StockifyApp extends StatelessWidget {
  const StockifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stockify',
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

  void _handleLogin(String username) {
    setState(() {
      _isAuthenticated = true;
      _username = username;
      _currentPage = 'dashboard';
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
      _currentPage = page;
    });
  }

  Widget _renderPage() {
    switch (_currentPage) {
      case 'dashboard':
        return const DashboardPage();
      case 'pos':
        return const POSPage();
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
        );
      case 'add-product':
        return const AddProductPage();
      case 'edit-product':
        return EditProductPage(
          productId: _editProductId ?? '1',
          onNavigateBack: () => _navigateToPage('products'),
          onProductUpdated: () => _navigateToPage('products'),
        );
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
      return LoginPage(
        onLogin: _handleLogin,
      );
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

