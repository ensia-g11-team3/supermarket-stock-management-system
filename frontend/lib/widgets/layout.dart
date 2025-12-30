import 'package:flutter/material.dart';
import 'package:se_project/l10n/app_localizations.dart';
import '../theme/app_theme.dart';

class Layout extends StatelessWidget {
  final String currentPage;
  final ValueChanged<String> onNavigate;
  final String username;
  final VoidCallback onLogout;
  final Widget child;

  const Layout({
    super.key,
    required this.currentPage,
    required this.onNavigate,
    required this.username,
    required this.onLogout,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 260,
            color: AppTheme.sidebarBackground,
            child: Column(
              children: [
                // Logo
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      const Icon(Icons.store, color: Colors.white, size: 32),
                      const SizedBox(width: 12),
                      const Text(
                        'Stockify',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.white24, height: 1),
                // Navigation Menu
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    children: [
                      _NavItem(
                        icon: Icons.dashboard,
                        label: AppLocalizations.of(context)!.navDashboard,
                        isSelected: currentPage == 'dashboard',
                        onTap: () => onNavigate('dashboard'),
                      ),
                      _NavItem(
                        icon: Icons.point_of_sale,
                        label: AppLocalizations.of(context)!.navPos,
                        isSelected: currentPage == 'pos',
                        onTap: () => onNavigate('pos'),
                      ),
                      _NavItem(
                        icon: Icons.history,
                        label: AppLocalizations.of(context)!.navSalesHistory,
                        isSelected: currentPage == 'history',
                        onTap: () => onNavigate('history'),
                      ),
                      _NavItem(
                        icon: Icons.inventory_2,
                        label: AppLocalizations.of(context)!.navProductList,
                        isSelected: currentPage == 'products',
                        onTap: () => onNavigate('products'),
                      ),
                      _NavItem(
                        icon: Icons.add_box,
                        label: AppLocalizations.of(context)!.navAddProduct,
                        isSelected: currentPage == 'add-product',
                        onTap: () => onNavigate('add-product'),
                      ),
                      _NavItem(
                        icon: Icons.category,
                        label: AppLocalizations.of(context)!.navCategories,
                        isSelected: currentPage == 'categories',
                        onTap: () => onNavigate('categories'),
                      ),
                      _NavItem(
                        icon: Icons.notifications_active,
                        label: AppLocalizations.of(context)!.navLowStock,
                        isSelected: currentPage == 'alerts',
                        onTap: () => onNavigate('alerts'),
                      ),
                      _NavItem(
                        icon: Icons.tune,
                        label: AppLocalizations.of(context)!
                            .navThresholds, // or just 'Thresholds'
                        isSelected: currentPage == 'thresholds' ||
                            currentPage == 'add-threshold' ||
                            currentPage == 'edit-threshold',
                        onTap: () => onNavigate('thresholds'),
                      ),
                      _NavItem(
                        icon: Icons.people,
                        label: AppLocalizations.of(context)!.navUserManagement,
                        isSelected: currentPage == 'users' ||
                            currentPage == 'create-user' ||
                            currentPage == 'edit-user',
                        onTap: () => onNavigate('users'),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.white24, height: 1),
                // User Section
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.loggedInAs + '$username',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: onLogout,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: Colors.red.withOpacity(0.5), width: 1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.logout,
                                color: Colors.white,
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Text(
                                AppLocalizations.of(context)!.logout,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: Container(
              color: Colors.white,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.sidebarSelected.withOpacity(0.3)
              : Colors.transparent,
          border: isSelected
              ? Border.all(color: AppTheme.sidebarSelected, width: 1)
              : null,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
