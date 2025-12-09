import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class RoleBadge extends StatelessWidget {
  final String role;

  const RoleBadge({
    super.key,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        role,
        style: const TextStyle(
          fontSize: 12,
          color: AppTheme.primaryBlue,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

