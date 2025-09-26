import 'package:flutter/material.dart';
import 'package:tickr/features/tasks/domain/entities/task.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';

import '../common/common_widgets.dart';

class TaskDetailHeader extends StatelessWidget {
  final Task task;
  final VoidCallback? onEdit;
  final VoidCallback? onToggleComplete;
  final VoidCallback? onDelete;
  final bool isLoading;

  const TaskDetailHeader({
    super.key,
    required this.task,
    this.onEdit,
    this.onToggleComplete,
    this.onDelete,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
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
          // Header con título y acciones
          Row(
            children: [
              Expanded(
                child: Text(
                  task.title,
                  style: AppTypography.headline2.copyWith(
                    color: task.completed
                        ? AppColors.textSecondary
                        : AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    decoration:
                        task.completed ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Botones de acción
              Row(
                children: [
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
                  const SizedBox(width: 8),
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

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
