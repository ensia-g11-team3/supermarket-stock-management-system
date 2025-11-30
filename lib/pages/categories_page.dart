import 'package:flutter/material.dart';
import '../widgets/page_header.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const PageHeader(
          title: 'Categories',
          description: 'Manage product categories',
        ),
        Expanded(
          child: Center(
            child: Text(
              'Categories Page - Coming Soon',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ),
      ],
    );
  }
}

