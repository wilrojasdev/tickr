import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/task.dart';
import '../../domain/entities/task_priority.dart';
import '../providers/task_provider.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;
  final VoidCallback? onToggleComplete;
  final VoidCallback? onDelete;
  final TaskProvider? taskProvider;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onToggleComplete,
    this.onDelete,
    this.taskProvider,
  });

  @override
  Widget build(BuildContext context) {
    final isUpdatingThisTask =
        taskProvider?.isTaskBeingUpdated(task.id) == true;
    final isDeletingThisTask =
        taskProvider?.isTaskBeingDeleted(task.id) == true;
    final isTogglingThisTask =
        taskProvider?.isTaskBeingToggled(task.id) == true;
    final isAnyOperationInProgress = taskProvider?.isLoading == true;

    return Card(
      color: AppColors.cardBackground,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: isAnyOperationInProgress ? null : onTap,
        borderRadius: BorderRadius.circular(8),
        child: Opacity(
          opacity: isDeletingThisTask ? 0.5 : 1.0,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header con título y acciones
                Row(
                  children: [
                    // Checkbox para completar
                    if (!isTogglingThisTask) ...[
                      GestureDetector(
                        onTap:
                            isAnyOperationInProgress ? null : onToggleComplete,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: task.completed
                                  ? AppColors.success
                                  : AppColors.grey800,
                              width: 2,
                            ),
                            color: task.completed
                                ? AppColors.success
                                : Colors.transparent,
                          ),
                          child: task.completed
                              ? const Icon(
                                  Icons.check,
                                  color: AppColors.white,
                                  size: 16,
                                )
                              : null,
                        ),
                      ),
                    ] else ...[
                      // Indicador de carga cuando se está cambiando el estado
                      const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(width: 12),

                    // Título
                    Expanded(
                      child: Text(
                        task.title,
                        style: AppTypography.headline6.copyWith(
                          color: task.completed
                              ? AppColors.textSecondary
                              : AppColors.textPrimary,
                          decoration: task.completed
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ),

                    // Indicador de carga para operaciones específicas
                    if (isUpdatingThisTask || isDeletingThisTask) ...[
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],

                    // Menú de acciones
                    PopupMenuButton<String>(
                      color: AppColors.white,
                      iconColor: AppColors.textPrimary,
                      enabled: !isAnyOperationInProgress,
                      onSelected: (value) {
                        switch (value) {
                          case 'toggle':
                            onToggleComplete?.call();
                            break;
                          case 'delete':
                            onDelete?.call();
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'toggle',
                          enabled: !isAnyOperationInProgress,
                          child: Row(
                            children: [
                              Icon(
                                task.completed ? Icons.undo : Icons.check,
                                color: isAnyOperationInProgress
                                    ? AppColors.textSecondary
                                    : AppColors.textPrimary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                task.completed
                                    ? 'Marcar como pendiente'
                                    : 'Marcar como completada',
                                style: TextStyle(
                                  color: isAnyOperationInProgress
                                      ? AppColors.textSecondary
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          enabled: !isAnyOperationInProgress,
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete,
                                color: isAnyOperationInProgress
                                    ? AppColors.textSecondary
                                    : AppColors.error,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Eliminar',
                                style: TextStyle(
                                  color: isAnyOperationInProgress
                                      ? AppColors.textSecondary
                                      : AppColors.error,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Descripción
                Text(
                  task.description,
                  style: AppTypography.bodyText2.copyWith(
                    color: task.completed
                        ? AppColors.textSecondary
                        : AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),

                // Footer con información adicional
                Row(
                  children: [
                    // Prioridad
                    if (task.priority != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getPriorityColor(task.priority!)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _getPriorityColor(task.priority!),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          _getPriorityText(task.priority!),
                          style: AppTypography.caption.copyWith(
                            color: _getPriorityColor(task.priority!),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],

                    // Fecha de vencimiento
                    if (task.dueDate != null) ...[
                      Icon(
                        Icons.schedule,
                        size: 16,
                        color: _isOverdue(task.dueDate!)
                            ? AppColors.error
                            : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormatter.formatDate(task.dueDate!),
                        style: AppTypography.caption.copyWith(
                          color: _isOverdue(task.dueDate!)
                              ? AppColors.error
                              : AppColors.textSecondary,
                          fontWeight: _isOverdue(task.dueDate!)
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],

                    const Spacer(),

                    // Fecha de creación
                    Text(
                      DateFormatter.formatRelativeDate(
                          task.createdAt ?? DateTime.now()),
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return AppColors.error;
      case TaskPriority.medium:
        return AppColors.warning;
      case TaskPriority.low:
        return AppColors.success;
    }
  }

  String _getPriorityText(TaskPriority priority) {
    return priority.label;
  }

  bool _isOverdue(DateTime dueDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate.year, dueDate.month, dueDate.day);
    return due.isBefore(today) && !due.isAtSameMomentAs(today);
  }
}
