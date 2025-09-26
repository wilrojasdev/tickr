import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class AuthCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final bool showBorder;
  final bool showShadow;
  final Color? backgroundColor;

  const AuthCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 20,
    this.showBorder = true,
    this.showShadow = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.white,
            borderRadius: BorderRadius.circular(borderRadius),
            border: showBorder
                ? Border.all(
                    color: AppColors.border,
                    width: 1,
                  )
                : null,
            boxShadow: showShadow
                ? [
                    BoxShadow(
                      color: AppColors.shadowLight,
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                      spreadRadius: 0,
                    ),
                  ]
                : null,
          ),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(32.0),
            child: child,
          ),
        ),
      ),
    );
  }
}
