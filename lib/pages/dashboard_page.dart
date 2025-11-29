import 'package:flutter/material.dart';
import '../widgets/page_header.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const PageHeader(
          title: 'Dashboard',
          description: 'Overview of your inventory',
        ),
        Expanded(
          child: Center(
            child: Text(
              'Dashboard - Coming Soon',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ),
      ],
    );
  }
}

