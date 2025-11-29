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
            padding: const EdgeInsets.all(32),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filters & Search Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Filters & Search',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          AppSearchBar(
                            placeholder: 'Name, email, phone, or role...',
                            value: _searchQuery,
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          Row(
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
                              const SizedBox(width: 16),
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
                              const SizedBox(width: 16),
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
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // User Table
                  Card(
                    child: Table(
                      columnWidths: const {
                        0: FlexColumnWidth(1.5),
                        1: FlexColumnWidth(1.5),
                        2: FlexColumnWidth(2),
                        3: FlexColumnWidth(1.5),
                        4: FlexColumnWidth(1.5),
                        5: FlexColumnWidth(1),
                        6: FlexColumnWidth(1.2),
                        7: FlexColumnWidth(1.5),
                      },
                      children: [
                        // Header Row
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
                            _TableHeaderCell(Text('Created')),
                            _TableHeaderCell(Text('Actions')),
                          ],
                        ),
                        // Data Rows
                        ..._filteredUsers.map((user) => TableRow(
                              children: [
                                _TableCell(Text(user['username'])),
                                _TableCell(Text(user['fullName'])),
                                _TableCell(Text(user['email'])),
                                _TableCell(Text(user['phone'])),
                                _TableCell(RoleBadge(role: user['role'])),
                                _TableCell(StatusBadge(isActive: user['status'])),
                                _TableCell(Text(user['created'])),
                                _TableCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, size: 20),
                                        onPressed: () => widget.onNavigateToEdit(user['id']),
                                        color: AppTheme.primaryBlue,
                                        tooltip: 'Edit',
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.lock, size: 20),
                                        onPressed: () {},
                                        color: AppTheme.brownGold,
                                        tooltip: 'Permissions',
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, size: 20),
                                        onPressed: () {},
                                        color: Colors.red,
                                        tooltip: 'Delete',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                ],
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
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
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
                horizontal: 16,
                vertical: 12,
              ),
            ),
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
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
      padding: const EdgeInsets.all(12),
      child: DefaultTextStyle(
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
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
      padding: const EdgeInsets.all(12),
      child: DefaultTextStyle(
        style: const TextStyle(
          fontSize: 14,
          color: AppTheme.textPrimary,
        ),
        child: child,
      ),
    );
  }
}
