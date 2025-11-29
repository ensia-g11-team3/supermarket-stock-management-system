import 'package:flutter/material.dart';
import '../widgets/page_header.dart';

class SuppliersPage extends StatelessWidget {
  const SuppliersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const PageHeader(
          title: 'Suppliers & Orders',
          description: 'Manage suppliers and orders',
        ),
        Expanded(
          child: Center(
            child: Text(
              'Suppliers Page - Coming Soon',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ),
      ],
    );
  }
}

