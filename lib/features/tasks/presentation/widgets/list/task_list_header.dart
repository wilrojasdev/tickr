import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/responsive/responsive.dart';

class TaskListHeader extends StatelessWidget {
  final String title;
  final int taskCount;
  final VoidCallback? onAddTask;
  final VoidCallback? onFilter;
  final bool showAddButton;

  const TaskListHeader({
    super.key,
    required this.title,
    required this.taskCount,
    this.onAddTask,
    this.onFilter,
    this.showAddButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final padding = Responsive.getResponsivePadding(context);
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.headline2.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: Responsive.scaleFont(
                            context, AppTypography.fontSizeTitle),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$taskCount ${taskCount == 1 ? 'tarea' : 'tareas'}',
                      style: AppTypography.bodyText1.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: Responsive.scaleFont(
                            context, AppTypography.fontSizeBody),
                      ),
                    ),
                  ],
                ),
              ),

              // Botones de acción
              Row(
                children: [
                  if (onFilter != null) ...[
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.grey100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: onFilter,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: EdgeInsets.all(
                                Responsive.scaleWidth(context, 12)),
                            child: Icon(
                              Icons.sort_rounded,
                              color: AppColors.textSecondary,
                              size: Responsive.scaleWidth(context, 20),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (showAddButton && onAddTask != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: onAddTask,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: Responsive.scaleWidth(context, 16),
                              vertical: Responsive.scaleHeight(context, 12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.add_rounded,
                                  color: AppColors.white,
                                  size: Responsive.scaleWidth(context, 18),
                                ),
                                SizedBox(
                                    width: Responsive.scaleWidth(context, 6)),
                                Text(
                                  'Nueva',
                                  style: AppTypography.button.copyWith(
                                    color: AppColors.white,
                                    fontSize: Responsive.scaleFont(context, 14),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
