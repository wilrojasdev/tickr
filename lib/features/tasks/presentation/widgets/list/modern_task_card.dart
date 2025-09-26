import 'package:flutter/material.dart';
import 'package:tickr/core/utils/date_formatter.dart';
import 'package:tickr/features/tasks/domain/entities/task.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/responsive/responsive.dart';

import '../common/common_widgets.dart';

class ModernTaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;
  final VoidCallback? onToggleComplete;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isLoading;
  final bool isDeleting;

  const ModernTaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onToggleComplete,
    this.onEdit,
    this.onDelete,
    this.isLoading = false,
    this.isDeleting = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isDeleting ? 0.5 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: Container(
        margin: EdgeInsets.only(bottom: Responsive.scaleHeight(context, 16)),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius:
              BorderRadius.circular(Responsive.scaleWidth(context, 16)),
          border: Border.all(
            color: AppColors.border,
            width: 1,
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
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isLoading ? null : onTap,
            borderRadius:
                BorderRadius.circular(Responsive.scaleWidth(context, 16)),
            child: Padding(
              padding: EdgeInsets.all(Responsive.scaleWidth(context, 20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          task.title,
                          style: AppTypography.headline4.copyWith(
                            color: task.completed
                                ? AppColors.textSecondary
                                : AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: Responsive.scaleFont(
                                context, AppTypography.fontSizeMedium),
                            decoration: task.completed
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ),
                      SizedBox(width: Responsive.scaleWidth(context, 12)),
                      TaskActionButton(
                        icon: task.completed
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked_rounded,
                        color: task.completed
                            ? AppColors.success
                            : AppColors.textSecondary,
                        backgroundColor: task.completed
                            ? AppColors.successLight
                            : AppColors.grey100,
                        tooltip: task.completed
                            ? 'Marcar como pendiente'
                            : 'Marcar como completada',
                        onPressed: onToggleComplete,
                        isLoading: isLoading,
                      ),
                    ],
                  ),

                  SizedBox(height: Responsive.scaleHeight(context, 8)),

// Estado + prioridad
                  Row(
                    children: [
                      TaskStatusIndicator(task: task, isCompact: true),
                      SizedBox(width: Responsive.scaleWidth(context, 8)),
                      PriorityBadge(priority: task.priority!, isCompact: true),
                    ],
                  ),

                  if (task.description.isNotEmpty) ...[
                    SizedBox(height: Responsive.scaleHeight(context, 8)),
                    Text(
                      task.description,
                      style: AppTypography.bodyText2.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.4,
                        fontSize: Responsive.scaleFont(
                            context, AppTypography.fontSizeSmall),
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],

                  SizedBox(height: Responsive.scaleHeight(context, 12)),

// Footer con fecha + acciones
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (task.dueDate != null)
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              size: 14,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              DateFormatter.formatDate(task.dueDate!),
                              style: AppTypography.caption.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      Row(
                        children: [
                          TaskActionButton(
                            icon: Icons.edit_rounded,
                            tooltip: 'Editar tarea',
                            onPressed: onEdit,
                            isLoading: isLoading,
                          ),
                          const SizedBox(width: 8),
                          TaskActionButton(
                            icon: Icons.delete_rounded,
                            tooltip: 'Eliminar tarea',
                            color: AppColors.error,
                            backgroundColor: AppColors.errorLight,
                            onPressed: onDelete,
                            isLoading: isLoading,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
