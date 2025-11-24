import 'package:flutter/material.dart';
import '../widgets/page_header.dart';

class CreateUserPage extends StatelessWidget {
  final VoidCallback onNavigateBack;
  final VoidCallback onUserCreated;

  const CreateUserPage({
    super.key,
    required this.onNavigateBack,
    required this.onUserCreated,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const PageHeader(
          title: 'Create User',
          description: 'Add a new user to the system',
        ),
        Expanded(
          child: Center(
            child: Text(
              'Create User Page - Coming Soon',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ),
      ],
    );
  }
}

