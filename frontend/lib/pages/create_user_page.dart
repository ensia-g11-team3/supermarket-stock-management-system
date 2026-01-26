import 'package:flutter/material.dart';
import 'package:se_project/l10n/app_localizations.dart';
import 'package:se_project/services/user_api.dart';
import '../widgets/page_header.dart';
import '../widgets/primary_button.dart';

class CreateUserPage extends StatefulWidget {
  final VoidCallback onNavigateBack;
  final VoidCallback onUserCreated;

  const CreateUserPage({
    super.key,
    required this.onNavigateBack,
    required this.onUserCreated,
  });

  @override
  State<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _selectedRole = 'Admin';
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  late List<String> _roles = [
    AppLocalizations.of(context)!.roleAdmin,
    AppLocalizations.of(context)!.roleInventoryManager,
    AppLocalizations.of(context)!.roleInventoryStaff,
    AppLocalizations.of(context)!.rolePOSWorker
  ];

  // Role-based default permissions
  final Map<String, List<String>> _rolePermissions = {
    'POS worker / Sales Clerk': ['View products list'],
    'Admin': [
      'View products list',
      'Add product',
      'Edit product',
      'Delete product',
      'View activities history',
      'Set alerts'
    ],
    'Inventory Manager': [
      'View products list',
      'Add product',
      'Edit product',
      'View activities history',
      'Set alerts'
    ],
    'Inventory Staff': [
      'View products list',
      'Add product',
      'Edit product',
      'View activities history'
    ],
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a role'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final data = {
      "username": _usernameController.text,
      "full_name": _fullNameController.text,
      "phone_number": _phoneController.text,
      "email": _emailController.text,
      "password": _passwordController.text,
      "role": _selectedRole,
      "is_active": true
    };

    try {
      await UserApi.addUser(data);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Utilisateur créé avec succès'),
            backgroundColor: Colors.green,
          ),
        );

        _resetForm();
        widget.onUserCreated.call();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Échec de l’ajout de l’utilisateur : $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _usernameController.clear();
    _fullNameController.clear();
    _phoneController.clear();
    _emailController.clear();
    _passwordController.clear();

    setState(() {
      _selectedRole = 'POS Worker';
    });
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName est requis';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'L\'adreese mail est requise';
    }
    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Entrez une adresse e-mail valide';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le mot-de-passe est requis';
    }
    if (value.length < 8) {
      return 'Le mot de passe doit comporter au moins 8 caractères';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Le mot de passe doit contenir au moins une lettre majuscule';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Le mot de passe doit contenir au moins un chiffre';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageHeader(
          title: AppLocalizations.of(context)!.createNewUser,
          description: AppLocalizations.of(context)!.addNewUserDescription,
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: widget.onNavigateBack,
                icon: const Icon(Icons.arrow_back),
                label: Text(AppLocalizations.of(context)!.backToUserList),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black87,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Form(
              key: _formKey,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey[300]!),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Basic Information Section
                        Text(
                          'Basic Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.brown[700],
                          ),
                        ),
                        const SizedBox(height: 24),

                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: _usernameController,
                                label: AppLocalizations.of(context)!.username,
                                hint:
                                    AppLocalizations.of(context)!.enterUsername,
                                validator: (val) => _validateRequired(val,
                                    AppLocalizations.of(context)!.username),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildTextField(
                                controller: _fullNameController,
                                label: AppLocalizations.of(context)!.fullName,
                                hint:
                                    AppLocalizations.of(context)!.enterFullName,
                                validator: (val) => _validateRequired(val,
                                    AppLocalizations.of(context)!.fullName),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: _phoneController,
                                label:
                                    AppLocalizations.of(context)!.phoneNumber,
                                hint: '0555555555',
                                validator: (val) => _validateRequired(val,
                                    AppLocalizations.of(context)!.phoneNumber),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildTextField(
                                controller: _emailController,
                                label: AppLocalizations.of(context)!.email,
                                hint: AppLocalizations.of(context)!.emailHint,
                                validator: _validateEmail,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        _buildPasswordField(),
                        const SizedBox(height: 4),
                        Text(
                          AppLocalizations.of(context)!.passwordRules,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),

                        const SizedBox(height: 40),
                        const Divider(),
                        const SizedBox(height: 32),

                        // Role Section
                        Text(
                          AppLocalizations.of(context)!.role,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.brown[700],
                          ),
                        ),
                        const SizedBox(height: 24),

                        _buildRoleDropdown(),

                        const SizedBox(height: 24),

                        // Action Buttons
                        Row(
                          children: [
                            PrimaryButton(
                              onPressed: _isLoading ? null : _handleSave,
                              isLoading: _isLoading,
                              size: ButtonSize.lg,
                              child: Text(
                                  AppLocalizations.of(context)!.createNewUser),
                            ),
                            const SizedBox(width: 16),
                            PrimaryButton(
                              onPressed:
                                  _isLoading ? null : widget.onNavigateBack,
                              variant: ButtonVariant.secondary,
                              size: ButtonSize.lg,
                              child: Text(AppLocalizations.of(context)!.cancel),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
            children: const [
              TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue[600]!, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: AppLocalizations.of(context)!.password,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
            children: const [
              TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          validator: _validatePassword,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.enterPassword,
            hintStyle: TextStyle(color: Colors.grey[400]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue[600]!, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey[600],
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRoleDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: AppLocalizations.of(context)!.role,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
            children: const [
              TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedRole,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue[600]!, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          items: _roles.map((role) {
            return DropdownMenuItem(
              value: role,
              child: Text(role),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedRole = value;
              });
            }
          },
        ),
      ],
    );
  }
}
