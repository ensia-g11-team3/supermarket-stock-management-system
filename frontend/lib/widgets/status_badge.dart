import 'package:flutter/material.dart';
import 'package:se_project/l10n/app_localizations.dart';

class StatusBadge extends StatelessWidget {
  final bool isActive;

  const StatusBadge({
    super.key,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        isActive
            ? AppLocalizations.of(context)!.active
            : AppLocalizations.of(context)!.inactive,
        style: TextStyle(
          fontSize: 14,
          color: isActive ? const Color(0xFF065F46) : const Color(0xFF991B1B),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
