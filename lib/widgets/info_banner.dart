import 'package:flutter/material.dart';

enum BannerType { success, error, warning, info }

class InfoBanner extends StatelessWidget {
  final BannerType type;
  final String message;
  final VoidCallback? onClose;

  const InfoBanner({
    super.key,
    required this.type,
    required this.message,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color borderColor;
    Color textColor;
    Color iconColor;
    IconData icon;

    switch (type) {
      case BannerType.success:
        backgroundColor = const Color(0xFFD1FAE5);
        borderColor = const Color(0xFFBBF7D0);
        textColor = const Color(0xFF065F46);
        iconColor = const Color(0xFF10B981);
        icon = Icons.check_circle;
        break;
      case BannerType.error:
        backgroundColor = const Color(0xFFFEE2E2);
        borderColor = const Color(0xFFFECACA);
        textColor = const Color(0xFF991B1B);
        iconColor = const Color(0xFFEF4444);
        icon = Icons.cancel;
        break;
      case BannerType.warning:
        backgroundColor = const Color(0xFFFED7AA);
        borderColor = const Color(0xFFFED7AA);
        textColor = const Color(0xFF92400E);
        iconColor = const Color(0xFFF97316);
        icon = Icons.warning;
        break;
      case BannerType.info:
        backgroundColor = const Color(0xFFDBEAFE);
        borderColor = const Color(0xFFBFDBFE);
        textColor = const Color(0xFF1E40AF);
        iconColor = const Color(0xFF3B82F6);
        icon = Icons.info;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
              ),
            ),
          ),
          if (onClose != null)
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              color: textColor,
              onPressed: onClose,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }
}

