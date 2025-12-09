import 'package:flutter/material.dart';

class StockBadge extends StatelessWidget {
  final int stock;
  final int minStock;

  const StockBadge({
    super.key,
    required this.stock,
    this.minStock = 10,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    IconData? icon;

    if (stock <= minStock / 2) {
      // Very low stock - red
      backgroundColor = const Color(0xFFFEE2E2);
      textColor = const Color(0xFFDC2626);
      icon = Icons.warning;
    } else if (stock <= minStock) {
      // Low stock - orange
      backgroundColor = const Color(0xFFFED7AA);
      textColor = const Color(0xFFEA580C);
      icon = Icons.warning;
    } else {
      // Good stock - green
      backgroundColor = const Color(0xFFD1FAE5);
      textColor = const Color(0xFF059669);
      icon = null;
    }

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            stock.toString(),
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          if (icon != null)
            Positioned(
              top: 2,
              right: 2,
              child: Icon(icon, color: textColor, size: 14),
            ),
        ],
      ),
    );
  }
}

