import 'package:flutter/material.dart';
import '../widgets/page_header.dart';

class SalesHistoryPage extends StatelessWidget {
  const SalesHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const PageHeader(
          title: 'Sales History',
          description: 'View all sales transactions',
        ),
        Expanded(
          child: Center(
            child: Text(
              'Sales History Page - Coming Soon',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ),
      ],
    );
  }
}

