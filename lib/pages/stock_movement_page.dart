import 'package:flutter/material.dart';
import '../widgets/page_header.dart';

class StockMovementPage extends StatelessWidget {
  const StockMovementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const PageHeader(
          title: 'Stock Movement',
          description: 'Track stock movements and history',
        ),
        Expanded(
          child: Center(
            child: Text(
              'Stock Movement Page - Coming Soon',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ),
      ],
    );
  }
}

