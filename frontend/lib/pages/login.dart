import 'package:flutter/material.dart';
import '../widgets/primary_button.dart';

class LoginPage extends StatefulWidget {
  final ValueChanged<String> onLogin;
  
  const LoginPage({
    super.key,
    required this.onLogin,
  });
  
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _userCtrl = TextEditingController();
  var _passCtrl = TextEditingController();
  var _remember = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFFCBA052),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Icons.storefront, size: 50, color: Colors.white),
              ),
              SizedBox(height: 16),
              Text('Stockify', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w300, color: Color(0xFFCBA052))),
              Text('Point of Sale System', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
              SizedBox(height: 40),
              Container(
                width: 400,
                padding: EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: Text('Welcome Back', style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic, color: Colors.grey[700]))),
                    SizedBox(height: 32),
                    Text('Username', style: TextStyle(color: Colors.grey[700])),
                    SizedBox(height: 8),
                    TextField(
                      controller: _userCtrl,
                      decoration: InputDecoration(
                        hintText: 'Enter your username',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        prefixIcon: Icon(Icons.person_outline, color: Colors.grey[400]),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text('Password', style: TextStyle(color: Colors.grey[700])),
                    SizedBox(height: 8),
                    TextField(
                      controller: _passCtrl,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[400]),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 24, height: 24, child: Checkbox(value: _remember, onChanged: (v) => setState(() => _remember = v!))),
                            SizedBox(width: 8),
                            Text('Remember me', style: TextStyle(color: Colors.grey[700])),
                          ],
                        ),
                        TextButton(onPressed: () {}, child: Text('Forgot password?', style: TextStyle(color: Color(0xFFCBA052)))),
                      ],
                    ),
                    SizedBox(height: 24),
                    Center(
                      child: PrimaryButton(
                        onPressed: () {
                          if (_userCtrl.text.isNotEmpty) {
                            widget.onLogin(_userCtrl.text);
                          }
                        },
                        size: ButtonSize.lg,
                        child: const Text('Sign In'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}