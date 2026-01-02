import 'dart:convert';
import 'dart:io';
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

//localization: added by Nour
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

void _debugLog(String location, String message, Map<String, dynamic> data, String hypothesisId) {
  try {
    final logEntry = {
      'location': location,
      'message': message,
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'sessionId': 'debug-session',
      'runId': 'run1',
      'hypothesisId': hypothesisId,
    };
    final logPath = r'c:\Users\wailo\Desktop\project\.cursor\debug.log';
    final file = File(logPath);
    file.writeAsStringSync('${jsonEncode(logEntry)}\n', mode: FileMode.append);
  } catch (e) {}
}

class StockifyApp extends StatefulWidget {
  const StockifyApp({super.key});

  @override
  State<StockifyApp> createState() => _StockifyAppState();
}

class _StockifyAppState extends State<StockifyApp> {
  Locale _locale = const Locale('fr');

  void _changeLanguage(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    // #region agent log
    _debugLog('app.dart:34', 'StockifyApp build', {'timestamp': DateTime.now().toString(), 'locale': _locale.languageCode}, 'D');
    // #endregion
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
      locale: _locale,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: AppRouter(onLanguageChanged: _changeLanguage),
    );
  }
}

class AppRouter extends StatefulWidget {
  final ValueChanged<Locale> onLanguageChanged;
  
  const AppRouter({
    super.key,
    required this.onLanguageChanged,
  });

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
        return const POSPage(userId: null);
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
    // #region agent log
    _debugLog('app.dart:228', 'AppRouter build', {'isAuthenticated': _isAuthenticated, 'currentPage': _currentPage}, 'D');
    // #endregion
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
      onLanguageChanged: widget.onLanguageChanged,
      child: _renderPage(),
    );
  }
}

