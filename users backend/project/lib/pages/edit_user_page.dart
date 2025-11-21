import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class EditUserPage extends StatefulWidget {
  final User user;
  const EditUserPage({required this.user, super.key});

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  late TextEditingController usernameCtrl;
  late TextEditingController nameCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController phoneCtrl;
  late TextEditingController roleCtrl;
  late TextEditingController passwordCtrl;
  bool loading = false;
  String error = '';

  @override
  void initState() {
    super.initState();
    usernameCtrl = TextEditingController(text: widget.user.username);
    nameCtrl = TextEditingController(text: widget.user.fullName);
    emailCtrl = TextEditingController(text: widget.user.email);
    phoneCtrl = TextEditingController(text: widget.user.phone);
    roleCtrl = TextEditingController(text: widget.user.role);
    passwordCtrl = TextEditingController(text: widget.user.password);
  }

  Future<void> submit() async {
    if (widget.user.id == null) return;
    setState(() {
      loading = true;
      error = '';
    });

    final payload = {
      'username': usernameCtrl.text.trim(),
      'full_name': nameCtrl.text.trim(),
      'email': emailCtrl.text.trim(),
      'phone': phoneCtrl.text.trim(),
      'role': roleCtrl.text.trim(),
      'password': passwordCtrl.text,
    };

    try {
      final ok = await ApiService.updateUser(widget.user.id!, payload);
      if (ok) Navigator.pop(context, true);
      else setState(() => error = 'Failed to update user');
    } catch (e) {
      setState(() => error = 'Error: ${e.toString()}');
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    usernameCtrl.dispose();
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    roleCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit User')),
      body: Center(
        child: SizedBox(
          width: 520,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(controller: usernameCtrl, decoration: const InputDecoration(labelText: 'Username')),
                const SizedBox(height: 8),
                TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Full Name')),
                const SizedBox(height: 8),
                TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
                const SizedBox(height: 8),
                TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Phone')),
                const SizedBox(height: 8),
                TextField(controller: roleCtrl, decoration: const InputDecoration(labelText: 'Role')),
                const SizedBox(height: 8),
                TextField(controller: passwordCtrl, decoration: const InputDecoration(labelText: 'Password')),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: loading ? null : submit, child: loading ? const CircularProgressIndicator() : const Text('Save')),
                if (error.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(error, style: const TextStyle(color: Colors.red)),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
