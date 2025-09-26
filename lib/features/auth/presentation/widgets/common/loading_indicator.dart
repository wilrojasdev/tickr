import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';

class LoadingIndicator extends StatelessWidget {
  final double size;
  final double strokeWidth;
  final Color? color;
  final String? text;
  final EdgeInsetsGeometry? padding;
  final bool showBackground;

  const LoadingIndicator({
    super.key,
    this.size = 40,
    this.strokeWidth = 3,
    this.color,
    this.text,
    this.padding,
    this.showBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget indicator = SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? AppColors.white,
        ),
      ),
    );

    if (showBackground) {
      indicator = Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(size / 2),
        ),
        child: Padding(
          padding: EdgeInsets.all(size * 0.2),
          child: indicator,
        ),
      );
    }

    if (text != null) {
      return Column(
        children: [
          indicator,
          const SizedBox(height: 16),
          Text(
            text!,
            style: AppTypography.bodyText2.copyWith(
              color: color?.withValues(alpha: 0.8) ??
                  AppColors.white.withValues(alpha: 0.8),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    return indicator;
  }
}
