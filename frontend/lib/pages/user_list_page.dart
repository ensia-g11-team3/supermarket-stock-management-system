import 'package:flutter/material.dart';
import '../widgets/page_header.dart';
import '../widgets/primary_button.dart';
import '../widgets/search_bar.dart';
import '../widgets/status_badge.dart';
import '../widgets/role_badge.dart';
import '../theme/app_theme.dart';

class UserListPage extends StatefulWidget {
  final VoidCallback onNavigateToCreate;
  final ValueChanged<String> onNavigateToEdit;

  const UserListPage({
    super.key,
    required this.onNavigateToCreate,
    required this.onNavigateToEdit,
  });

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  String _searchQuery = '';
  String _selectedRole = 'All Roles';
  String _selectedStatus = 'All Status';
  String _sortBy = 'Name';

  final List<Map<String, dynamic>> _users = [
    {
      'id': '1',
      'username': 'admin',
      'fullName': 'John Administrator',
      'email': 'admin@stockify.com',
      'phone': '+1234567890',
      'role': 'Admin',
      'status': true,
      'created': 'Jan 15, 2024',
    },
    {
      'id': '2',
      'username': 'sarah.manager',
      'fullName': 'Sarah Johnson',
      'email': 'sarah.j@stockify.com',
      'phone': '+1234567891',
      'role': 'Stock Manager',
      'status': true,
      'created': 'Feb 10, 2024',
    },
    {
      'id': '3',
      'username': 'mike.pos',
      'fullName': 'Mike Williams',
      'email': 'mike.w@stockify.com',
      'phone': '+1234567892',
      'role': 'POS Worker',
      'status': true,
      'created': 'Feb 20, 2024',
    },
    {
      'id': '4',
      'username': 'emma.pos',
      'fullName': 'Emma Davis',
      'email': 'emma.d@stockify.com',
      'phone': '+1234567893',
      'role': 'POS Worker',
      'status': false,
      'created': 'Mar 5, 2024',
    },
    {
      'id': '5',
      'username': 'david.manager',
      'fullName': 'David Brown',
      'email': 'david.b@stockify.com',
      'phone': '+1234567894',
      'role': 'Stock Manager',
      'status': true,
      'created': 'Mar 15, 2024',
    },
  ];

  List<Map<String, dynamic>> get _filteredUsers {
    return _users.where((Map<String, dynamic> user) {
      final bool matchesSearch = _searchQuery.isEmpty ||
          user['username'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          user['fullName'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          user['email'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          user['phone'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          user['role'].toString().toLowerCase().contains(_searchQuery.toLowerCase());

      final bool matchesRole = _selectedRole == 'All Roles' || user['role'] == _selectedRole;
      final bool matchesStatus = _selectedStatus == 'All Status' ||
          (_selectedStatus == 'Active' && user['status'] == true) ||
          (_selectedStatus == 'Inactive' && user['status'] == false);

      return matchesSearch && matchesRole && matchesStatus;
    }).toList()
      ..sort((Map<String, dynamic> a, Map<String, dynamic> b) {
        switch (_sortBy) {
          case 'Name':
            return a['fullName'].compareTo(b['fullName']);
          case 'Date':
            return b['created'].compareTo(a['created']);
          default:
            return 0;
        }
      });
  }

  void _showDeleteConfirmation(BuildContext context, Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.warning_rounded,
                  color: Colors.red,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Delete User',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Are you sure you want to delete this user?',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.inputBackground,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Username', user['username']),
                    const SizedBox(height: 8),
                    _buildInfoRow('Full Name', user['fullName']),
                    const SizedBox(height: 8),
                    _buildInfoRow('Role', user['role']),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'This action cannot be undone.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          actions: [
            PrimaryButton(
              onPressed: () => Navigator.of(context).pop(),
              variant: ButtonVariant.secondary,
              child: const Text('Cancel'),
            ),
            PrimaryButton(
              onPressed: () {
                setState(() {
                  _users.removeWhere((u) => u['id'] == user['id']);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('User "${user['username']}" has been deleted'),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              variant: ButtonVariant.danger,
              child: const Text('Delete User'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            '$label:',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageHeader(
          title: 'User Management',
          description: 'Manage system users and their permissions.',
          actions: [
            PrimaryButton(
              onPressed: widget.onNavigateToCreate,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, size: 20),
                  SizedBox(width: 8),
                  Text('Add User'),
                ],
              ),
            ),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Filters & Search Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Filters & Search',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            AppSearchBar(
                              placeholder: 'Search by name, email, phone, or role...',
                              value: _searchQuery,
                              onChanged: (value) {
                                setState(() {
                                  _searchQuery = value;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            LayoutBuilder(
                              builder: (context, constraints) {
                                if (constraints.maxWidth < 800) {
                                  return Column(
                                    children: [
                                      _buildDropdown(
                                        label: 'Filter by Role',
                                        value: _selectedRole,
                                        items: const [
                                          'All Roles',
                                          'Admin',
                                          'Stock Manager',
                                          'POS Worker',
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedRole = value!;
                                          });
                                        },
                                      ),
                                      const SizedBox(height: 12),
                                      _buildDropdown(
                                        label: 'Filter by Status',
                                        value: _selectedStatus,
                                        items: const [
                                          'All Status',
                                          'Active',
                                          'Inactive',
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedStatus = value!;
                                          });
                                        },
                                      ),
                                      const SizedBox(height: 12),
                                      _buildDropdown(
                                        label: 'Sort By',
                                        value: _sortBy,
                                        items: const [
                                          'Name',
                                          'Date',
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            _sortBy = value!;
                                          });
                                        },
                                      ),
                                    ],
                                  );
                                }
                                return Row(
                                  children: [
                                    Expanded(
                                      child: _buildDropdown(
                                        label: 'Filter by Role',
                                        value: _selectedRole,
                                        items: const [
                                          'All Roles',
                                          'Admin',
                                          'Stock Manager',
                                          'POS Worker',
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedRole = value!;
                                          });
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildDropdown(
                                        label: 'Filter by Status',
                                        value: _selectedStatus,
                                        items: const [
                                          'All Status',
                                          'Active',
                                          'Inactive',
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedStatus = value!;
                                          });
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildDropdown(
                                        label: 'Sort By',
                                        value: _sortBy,
                                        items: const [
                                          'Name',
                                          'Date',
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            _sortBy = value!;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // User Table with Smart Horizontal Scroll
                    Card(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          const double tableMinWidth = 950;
                          final bool needsScroll = constraints.maxWidth < tableMinWidth;
                          
                          return Scrollbar(
                            thumbVisibility: needsScroll,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth: needsScroll ? tableMinWidth : constraints.maxWidth,
                                ),
                                child: Table(
                                  columnWidths: needsScroll ? const {
                                    0: FixedColumnWidth(130),
                                    1: FixedColumnWidth(150),
                                    2: FixedColumnWidth(200),
                                    3: FixedColumnWidth(130),
                                    4: FixedColumnWidth(130),
                                    5: FixedColumnWidth(90),
                                    6: FixedColumnWidth(120),
                                  } : const {
                                    0: FlexColumnWidth(1.3),
                                    1: FlexColumnWidth(1.5),
                                    2: FlexColumnWidth(2.0),
                                    3: FlexColumnWidth(1.3),
                                    4: FlexColumnWidth(1.3),
                                    5: FlexColumnWidth(0.9),
                                    6: FlexColumnWidth(1.2),
                                  },
                                  children: [
                                    TableRow(
                                      decoration: BoxDecoration(
                                        color: AppTheme.brownGold,
                                        border: Border(
                                          bottom: BorderSide(color: AppTheme.borderColor),
                                        ),
                                      ),
                                      children: const [
                                        _TableHeaderCell(Text('Username')),
                                        _TableHeaderCell(Text('Full Name')),
                                        _TableHeaderCell(Text('Email')),
                                        _TableHeaderCell(Text('Phone')),
                                        _TableHeaderCell(Text('Role')),
                                        _TableHeaderCell(Text('Status')),
                                        _TableHeaderCell(Text('Actions')),
                                      ],
                                    ),
                                    ..._filteredUsers.map((user) => TableRow(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: AppTheme.borderColor.withOpacity(0.5),
                                          ),
                                        ),
                                      ),
                                      children: [
                                        _TableCell(Text(user['username'])),
                                        _TableCell(Text(user['fullName'])),
                                        _TableCell(Text(user['email'])),
                                        _TableCell(Text(user['phone'])),
                                        _TableCell(RoleBadge(role: user['role'])),
                                        _TableCell(StatusBadge(isActive: user['status'])),
                                        _TableCell(
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.edit, size: 18),
                                                onPressed: () => widget.onNavigateToEdit(user['id']),
                                                color: AppTheme.primaryBlue,
                                                tooltip: 'Edit',
                                                padding: const EdgeInsets.all(4),
                                                constraints: const BoxConstraints(),
                                              ),
                                              const SizedBox(width: 8),
                                              IconButton(
                                                icon: const Icon(Icons.delete, size: 18),
                                                onPressed: () => _showDeleteConfirmation(context, user),
                                                color: Colors.red,
                                                tooltip: 'Delete',
                                                padding: const EdgeInsets.all(4),
                                                constraints: const BoxConstraints(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.inputBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppTheme.inputBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppTheme.primaryBlue, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(fontSize: 13),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class _TableHeaderCell extends StatelessWidget {
  final Widget child;

  const _TableHeaderCell(this.child);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: DefaultTextStyle(
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
          color: Colors.white,
        ),
        child: child,
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  final Widget child;

  const _TableCell(this.child);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: DefaultTextStyle(
        style: const TextStyle(
          fontSize: 13,
          color: AppTheme.textPrimary,
        ),
        child: child,
      ),
    );
  }
}