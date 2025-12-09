import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum ButtonVariant { primary, secondary, danger }
enum ButtonSize { sm, md, lg }

class PrimaryButton extends StatelessWidget {
  final Widget child;
  final ButtonVariant variant;
  final ButtonSize size;
  final VoidCallback? onPressed;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.child,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.md,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor;
    final Color textColor;

    switch (variant) {
      case ButtonVariant.primary:
        backgroundColor = AppTheme.primaryBlue;
        textColor = Colors.white;
        break;
      case ButtonVariant.secondary:
        backgroundColor = const Color(0xFFE5E7EB);
        textColor = const Color(0xFF1F2937);
        break;
      case ButtonVariant.danger:
        backgroundColor = const Color(0xFFDC2626);
        textColor = Colors.white;
        break;
    }

    final double horizontalPadding;
    final double verticalPadding;
    final double fontSize;

    switch (size) {
      case ButtonSize.sm:
        horizontalPadding = 12.0;
        verticalPadding = 6.0;
        fontSize = 14.0;
        break;
      case ButtonSize.md:
        horizontalPadding = 16.0;
        verticalPadding = 8.0;
        fontSize = 16.0;
        break;
      case ButtonSize.lg:
        horizontalPadding = 24.0;
        verticalPadding = 12.0;
        fontSize = 16.0;
        break;
    }

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
        disabledBackgroundColor: backgroundColor.withOpacity(0.5),
      ),
      child: isLoading
          ? SizedBox(
              height: fontSize,
              width: fontSize,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : DefaultTextStyle(
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
              child: child,
            ),
    );
  }
}

