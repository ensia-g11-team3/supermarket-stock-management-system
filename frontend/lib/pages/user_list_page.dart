import 'package:flutter/material.dart';
import 'package:se_project/l10n/app_localizations.dart';
import 'package:se_project/l10n/app_localizations_en.dart';
import '../widgets/page_header.dart';
import '../widgets/primary_button.dart';
import '../widgets/search_bar.dart';
import '../widgets/status_badge.dart';
import '../widgets/role_badge.dart';
import '../theme/app_theme.dart';
import '../services/user_api.dart';

class UserListPage extends StatefulWidget {
  final VoidCallback onNavigateToCreate;
  final ValueChanged<String>? onNavigateToEdit;

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
  late String _selectedRole;
  late String _selectedStatus;
  late String _sortBy;

  List<Map<String, dynamic>> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final data = await UserApi.getUsers();
      setState(() {
        _users = data;
        _isLoading = false;
      });
    } catch (e) {
      print(AppLocalizations.of(context)!.errorLoadingUsers + " $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> get _filteredUsers {
    return _users.where((Map<String, dynamic> user) {
      final bool matchesSearch = _searchQuery.isEmpty ||
          user['username']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          user['full_name']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          user['email']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          user['phone_number']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          user['role']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
      user['created_at']
          .toString()
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());

      final bool matchesRole =
          _selectedRole == AppLocalizations.of(context)!.allRoles ||
              user['role'] == _selectedRole;

      final bool matchesStatus =
          _selectedStatus == AppLocalizations.of(context)!.allStatus ||
              (_selectedStatus == AppLocalizations.of(context)!.active &&
                  user['is_active'] == 1) ||
              (_selectedStatus == AppLocalizations.of(context)!.inactive &&
                  user['is_active'] == 0);

      return matchesSearch && matchesRole && matchesStatus;
    }).toList()
      ..sort((Map<String, dynamic> a, Map<String, dynamic> b) {
        switch (_sortBy) {
          case 'name':
            return a['full_name'].compareTo(b['full_name']);
          case 'name':
            return b['created_at'].compareTo(a['created_at']);
          default:
            return 0;
        }
      });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _selectedRole = AppLocalizations.of(context)!.allRoles;
    _selectedStatus = AppLocalizations.of(context)!.allStatus;
    _sortBy = AppLocalizations.of(context)!.name;
  }

  void _showDeleteConfirmation(
      BuildContext context, Map<String, dynamic> user) {
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
              Text(
                AppLocalizations.of(context)!.deleteUser,
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
              Text(
                AppLocalizations.of(context)!.deleteConfirmation,
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
                    _buildInfoRow(AppLocalizations.of(context)!.username,
                        user['username']),
                    const SizedBox(height: 8),
                    _buildInfoRow(AppLocalizations.of(context)!.fullName,
                        user['full_name']),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                        AppLocalizations.of(context)!.role, user['role']),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.cannotBeUndone,
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
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            PrimaryButton(
              onPressed: () async {
                Navigator.pop(context); // Close dialog

                await UserApi.deleteUser(int.parse(user['user_id'].toString()));

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${user['full_name']} ' +
                        AppLocalizations.of(context)!.deleted),
                    backgroundColor: Colors.green.withOpacity(0.8),
                  ),
                );

                _fetchUsers(); // Refresh list
              },
              variant: ButtonVariant.danger,
              child: Text(AppLocalizations.of(context)!.deleteUser),
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
          title: AppLocalizations.of(context)!.userManagement,
          description: AppLocalizations.of(context)!.userManagementDesc,
          actions: [
            PrimaryButton(
              onPressed: widget.onNavigateToCreate,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add, size: 20),
                  const SizedBox(width: 8),
                  Text(AppLocalizations.of(context)!.addUser),
                ],
              ),
            ),
          ],
        ),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
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
                                  Text(
                                    AppLocalizations.of(context)!
                                        .filtersAndSearch,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  AppSearchBar(
                                    placeholder: AppLocalizations.of(context)!
                                        .userSearchPlaceholder,
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
                                              label:
                                                  AppLocalizations.of(context)!
                                                      .filterByRole,
                                              value: _selectedRole,
                                              items: [
                                                AppLocalizations.of(context)!
                                                    .roleAdmin,
                                                AppLocalizations.of(context)!
                                                    .roleInventoryManager,
                                                AppLocalizations.of(context)!
                                                    .roleInventoryStaff,
                                                AppLocalizations.of(context)!
                                                    .rolePOSWorker
                                              ],
                                              onChanged: (value) {
                                                setState(() {
                                                  _selectedRole = value!;
                                                });
                                              },
                                            ),
                                            const SizedBox(height: 12),
                                            _buildDropdown(
                                              label:
                                                  AppLocalizations.of(context)!
                                                      .filterByStatus,
                                              value: _selectedStatus,
                                              items: [
                                                AppLocalizations.of(context)!
                                                    .allStatus,
                                                AppLocalizations.of(context)!
                                                    .active,
                                                AppLocalizations.of(context)!
                                                    .inactive,
                                              ],
                                              onChanged: (value) {
                                                setState(() {
                                                  _selectedStatus = value!;
                                                });
                                              },
                                            ),
                                            const SizedBox(height: 12),
                                            _buildDropdown(
                                              label:
                                                  AppLocalizations.of(context)!
                                                      .sortBy,
                                              value: _sortBy,
                                              items: [
                                                AppLocalizations.of(context)!
                                                    .name,
                                                AppLocalizations.of(context)!
                                                    .date,
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
                                              label:
                                                  AppLocalizations.of(context)!
                                                      .filterByRole,
                                              value: _selectedRole,
                                              items: [
                                                AppLocalizations.of(context)!
                                                    .allRoles,
                                                AppLocalizations.of(context)!
                                                    .roleAdmin,
                                                AppLocalizations.of(context)!
                                                    .roleInventoryManager,
                                                AppLocalizations.of(context)!
                                                    .roleInventoryStaff,
                                                AppLocalizations.of(context)!
                                                    .rolePOSWorker
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
                                              label:
                                                  AppLocalizations.of(context)!
                                                      .filterByStatus,
                                              value: _selectedStatus,
                                              items: [
                                                AppLocalizations.of(context)!
                                                    .allStatus,
                                                AppLocalizations.of(context)!
                                                    .active,
                                                AppLocalizations.of(context)!
                                                    .inactive,
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
                                              label:
                                                  AppLocalizations.of(context)!
                                                      .sortBy,
                                              value: _sortBy,
                                              items: [
                                                AppLocalizations.of(context)!
                                                    .name,
                                                AppLocalizations.of(context)!
                                                    .date,
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
                                final bool needsScroll =
                                    constraints.maxWidth < tableMinWidth;

                                return Scrollbar(
                                  thumbVisibility: needsScroll,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        minWidth: needsScroll
                                            ? tableMinWidth
                                            : constraints.maxWidth,
                                      ),
                                      child: Table(
                                        columnWidths: needsScroll
                                            ? const {
                                                0: FixedColumnWidth(130),
                                                1: FixedColumnWidth(150),
                                                2: FixedColumnWidth(200),
                                                3: FixedColumnWidth(130),
                                                4: FixedColumnWidth(130),
                                                5: FixedColumnWidth(90),
                                                6: FixedColumnWidth(120),
                                              }
                                            : const {
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
                                                bottom: BorderSide(
                                                    color:
                                                        AppTheme.borderColor),
                                              ),
                                            ),
                                            children: [
                                              _TableHeaderCell(Text(
                                                  AppLocalizations.of(context)!
                                                      .username)),
                                              _TableHeaderCell(Text(
                                                  AppLocalizations.of(context)!
                                                      .fullName)),
                                              _TableHeaderCell(Text(
                                                  AppLocalizations.of(context)!
                                                      .email)),
                                              _TableHeaderCell(Text(
                                                  AppLocalizations.of(context)!
                                                      .phone)),
                                              _TableHeaderCell(Text(
                                                  AppLocalizations.of(context)!
                                                      .role)),
                                              _TableHeaderCell(Text(
                                                  AppLocalizations.of(context)!
                                                      .status)),
                                              _TableHeaderCell(Text(
                                                  AppLocalizations.of(context)!
                                                      .actions)),
                                            ],
                                          ),
                                          ..._filteredUsers.map((user) =>
                                              TableRow(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      color: AppTheme
                                                          .borderColor
                                                          .withOpacity(0.5),
                                                    ),
                                                  ),
                                                ),
                                                children: [
                                                  _TableCell(
                                                      Text(user['username'])),
                                                  _TableCell(
                                                      Text(user['full_name'])),
                                                  _TableCell(
                                                      Text(user['email'])),
                                                  _TableCell(Text(
                                                      user['phone_number'])),
                                                  _TableCell(RoleBadge(
                                                      role: user['role'])),
                                                  _TableCell(StatusBadge(
                                                      isActive:
                                                          user['is_active'] ==
                                                              1)),
                                                  _TableCell(
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        IconButton(
                                                          icon: const Icon(
                                                              Icons.edit,
                                                              size: 18),
                                                          onPressed: () {
                                                            widget
                                                                .onNavigateToEdit
                                                                ?.call(user[
                                                                        'user_id']
                                                                    .toString());
                                                          },
                                                          color: AppTheme
                                                              .primaryBlue,
                                                          tooltip:
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .edit,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4),
                                                          constraints:
                                                              const BoxConstraints(),
                                                        ),
                                                        const SizedBox(
                                                            width: 8),
                                                        IconButton(
                                                          icon: const Icon(
                                                              Icons.delete,
                                                              size: 18),
                                                          onPressed: () =>
                                                              _showDeleteConfirmation(
                                                                  context,
                                                                  user),
                                                          color: Colors.red,
                                                          tooltip:
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .delete,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4),
                                                          constraints:
                                                              const BoxConstraints(),
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
                borderSide:
                    const BorderSide(color: AppTheme.primaryBlue, width: 2),
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
