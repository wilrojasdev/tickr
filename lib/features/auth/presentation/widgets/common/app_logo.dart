import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/responsive/responsive.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool showShadow;
  final Color? backgroundColor;
  final Color? iconColor;
  final IconData? icon;

  const AppLogo({
    super.key,
    this.size = 80,
    this.showShadow = true,
    this.backgroundColor,
    this.iconColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final boxSize = Responsive.scaleWidth(context, size);
    return Container(
      width: boxSize,
      height: boxSize,
      decoration: BoxDecoration(
        gradient: backgroundColor != null ? null : AppColors.primaryGradient,
        color: backgroundColor,
        borderRadius: BorderRadius.circular(boxSize * 0.25),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ]
            : null,
      ),
      child: Image.asset(
        'assets/logo.png',
        width: boxSize * 0.6,
        height: boxSize * 0.6,
        fit: BoxFit.contain,
      ),
    );
  }
}
