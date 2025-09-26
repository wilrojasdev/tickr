import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/responsive/responsive.dart';

class TaskActionButton extends StatelessWidget {
  final IconData icon;
  final String? tooltip;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? backgroundColor;
  final bool isLoading;
  final double size;

  const TaskActionButton({
    super.key,
    required this.icon,
    this.tooltip,
    this.onPressed,
    this.color,
    this.backgroundColor,
    this.isLoading = false,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius:
              BorderRadius.circular(Responsive.scaleWidth(context, 8)),
          child: Container(
            width: Responsive.scaleWidth(context, 36),
            height: Responsive.scaleWidth(context, 36),
            decoration: BoxDecoration(
              color: backgroundColor ?? AppColors.grey100,
              borderRadius:
                  BorderRadius.circular(Responsive.scaleWidth(context, 8)),
              border: Border.all(
                color: AppColors.border,
                width: 1,
              ),
            ),
            child: isLoading
                ? Padding(
                    padding: EdgeInsets.all(Responsive.scaleWidth(context, 8)),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        color ?? AppColors.textSecondary,
                      ),
                    ),
                  )
                : Icon(
                    icon,
                    size: Responsive.scaleWidth(context, size),
                    color: color ?? AppColors.textSecondary,
                  ),
          ),
        ),
      ),
    );
  }
}
