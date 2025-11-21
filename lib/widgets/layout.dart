import 'package:flutter/material.dart';
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
                        label: 'Dashboard',
                        isSelected: currentPage == 'dashboard',
                        onTap: () => onNavigate('dashboard'),
                      ),
                      _NavItem(
                        icon: Icons.point_of_sale,
                        label: 'Sales (POS)',
                        isSelected: currentPage == 'pos',
                        onTap: () => onNavigate('pos'),
                      ),
                      _NavItem(
                        icon: Icons.history,
                        label: 'Sales History',
                        isSelected: currentPage == 'history',
                        onTap: () => onNavigate('history'),
                      ),
                      _NavItem(
                        icon: Icons.inventory_2,
                        label: 'Product List',
                        isSelected: currentPage == 'products',
                        onTap: () => onNavigate('products'),
                      ),
                      _NavItem(
                        icon: Icons.add_box,
                        label: 'Add Product',
                        isSelected: currentPage == 'add-product',
                        onTap: () => onNavigate('add-product'),
                      ),
                      _NavItem(
                        icon: Icons.category,
                        label: 'Categories',
                        isSelected: currentPage == 'categories',
                        onTap: () => onNavigate('categories'),
                      ),
                      _NavItem(
                        icon: Icons.local_shipping,
                        label: 'Suppliers & Orders',
                        isSelected: currentPage == 'suppliers',
                        onTap: () => onNavigate('suppliers'),
                      ),
                      _NavItem(
                        icon: Icons.notifications_active,
                        label: 'Low Stock Alerts',
                        isSelected: currentPage == 'alerts',
                        onTap: () => onNavigate('alerts'),
                      ),
                      _NavItem(
                        icon: Icons.swap_horiz,
                        label: 'Stock Movement',
                        isSelected: currentPage == 'movements',
                        onTap: () => onNavigate('movements'),
                      ),
                      _NavItem(
                        icon: Icons.people,
                        label: 'User Management',
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
                        'Logged in as $username',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
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

