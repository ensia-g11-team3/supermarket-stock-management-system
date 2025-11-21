import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({super.key});

  @override
  State<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final usernameCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final roleCtrl = TextEditingController(text: 'Stock Manager');
  final passwordCtrl = TextEditingController();
  bool loading = false;
  String error = '';

  Future<void> submit() async {
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
      // created_at will be filled by backend if not provided
    };

    try {
      final ok = await ApiService.createUser(payload);
      if (ok) Navigator.pop(context, true);
      else setState(() => error = 'Failed to create user');
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
      appBar: AppBar(title: const Text('Create User')),
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
                ElevatedButton(onPressed: loading ? null : submit, child: loading ? const CircularProgressIndicator() : const Text('Create')),
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
