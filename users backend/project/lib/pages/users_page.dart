import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import 'create_user_page.dart';
import 'edit_user_page.dart';

class UsersPage extends StatefulWidget {
  final VoidCallback onLogout;
  const UsersPage({required this.onLogout, super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List<User> users = [];
  bool loading = false;
  String error = '';

  Future<void> loadUsers() async {
    setState(() {
      loading = true;
      error = '';
    });
    try {
      final data = await ApiService.getUsers();
      users = data.map((e) => User.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      error = 'Failed to load users: ${e.toString()}';
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> _deleteUser(int id) async {
    await ApiService.deleteUser(id);
    await loadUsers();
  }

  Future<void> _changeState(User u) async {
    if (u.id == null) return;
    await ApiService.changeState(u.id!, !u.isActive);
    await loadUsers();
  }

  Future<void> _openCreate() async {
    final created = await Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateUserPage()));
    if (created == true) await loadUsers();
  }

  Future<void> _openEdit(User u) async {
    final updated = await Navigator.push(context, MaterialPageRoute(builder: (_) => EditUserPage(user: u)));
    if (updated == true) await loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        actions: [
          TextButton(onPressed: widget.onLogout, child: const Text('Logout', style: TextStyle(color: Colors.white))),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                ElevatedButton(onPressed: _openCreate, child: const Text('Create User')),
                const SizedBox(width: 12),
                ElevatedButton(onPressed: loadUsers, child: const Text('Refresh')),
                const Spacer(),
                if (loading) const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (error.isNotEmpty) Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(error, style: const TextStyle(color: Colors.red)),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('ID')),
                        DataColumn(label: Text('Username')),
                        DataColumn(label: Text('Full Name')),
                        DataColumn(label: Text('Email')),
                        DataColumn(label: Text('Phone')),
                        DataColumn(label: Text('Role')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Created At')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows: users.map((u) {
                        return DataRow(
                          cells: [
                            DataCell(Text(u.id?.toString() ?? '-')),
                            DataCell(Text(u.username)),
                            DataCell(Text(u.fullName)),
                            DataCell(Text(u.email)),
                            DataCell(Text(u.phone)),
                            DataCell(Text(u.role)),
                            DataCell(Text(u.isActive ? 'Active' : 'Inactive')),
                            DataCell(Text(u.createdAt)),
                            DataCell(Row(
                              children: [
                                IconButton(icon: const Icon(Icons.edit), onPressed: () => _openEdit(u)),
                                IconButton(icon: const Icon(Icons.power_settings_new), onPressed: () => _changeState(u)),
                                IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () {
                                  if (u.id != null) _deleteUser(u.id!);
                                }),
                              ],
                            )),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
