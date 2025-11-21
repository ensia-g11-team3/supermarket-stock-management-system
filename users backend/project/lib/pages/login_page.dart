import 'package:flutter/material.dart';
import '../services/api_service.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onSuccess;
  const LoginPage({required this.onSuccess, super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  bool loading = false;
  String error = '';

  Future<void> submit() async {
    setState(() {
      loading = true;
      error = '';
    });

    try {
      final ok = await ApiService.login(
        usernameCtrl.text.trim(),
        passwordCtrl.text.trim(),
      );
      if (ok) {
        widget.onSuccess();
      } else {
        setState(() => error = 'Invalid credentials or inactive user');
      }
    } catch (e) {
      setState(() => error = 'Error: ${e.toString()}');
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 360,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Login', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: usernameCtrl,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: passwordCtrl,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: loading ? null : submit,
                child: loading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Login'),
              ),
              if (error.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(error, style: const TextStyle(color: Colors.red)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
