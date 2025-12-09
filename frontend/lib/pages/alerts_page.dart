import 'package:flutter/material.dart';
import '../widgets/page_header.dart';

class AlertsPage extends StatelessWidget {
  const AlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const PageHeader(
          title: 'Low Stock Alerts',
          description: 'Products with low stock levels',
        ),
        Expanded(
          child: Center(
            child: Text(
              'Low Stock Alerts Page - Coming Soon',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ),
      ],
    );
  }
}

