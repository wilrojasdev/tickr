import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/utils/date_formatter.dart';
import 'package:tickr/features/tasks/domain/entities/task.dart';
import 'package:tickr/features/tasks/domain/entities/task_priority.dart';

class TaskDetailContent extends StatelessWidget {
  final Task task;

  const TaskDetailContent({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Descripción
          if (task.description.isNotEmpty) ...[
            _buildSection(
              title: 'Descripción',
              child: Text(
                task.description,
                style: AppTypography.bodyText1.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Información de fechas
          _buildSection(
            title: 'Información',
            child: Column(
              children: [
                _buildInfoRow(
                  icon: Icons.schedule_rounded,
                  label: 'Creada',
                  value: DateFormatter.formatDateTime(task.createdAt!),
                ),
                if (task.dueDate != null) ...[
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    icon: Icons.event_rounded,
                    label: 'Fecha límite',
                    value: DateFormatter.formatDateTime(task.dueDate!),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Estadísticas
          _buildSection(
            title: 'Estadísticas',
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.priority_high_rounded,
                    label: 'Prioridad',
                    value: _getPriorityText(task.priority),
                    color: _getPriorityColor(task.priority),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    icon: task.completed
                        ? Icons.check_circle_rounded
                        : Icons.schedule_rounded,
                    label: 'Estado',
                    value: task.completed ? 'Completada' : 'Pendiente',
                    color: task.completed ? AppColors.success : AppColors.info,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.headline3.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.border,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 4,
                offset: const Offset(0, 2),
                spreadRadius: 0,
              ),
            ],
          ),
          child: child,
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: AppTypography.bodyText1.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 24,
            color: color,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTypography.bodyText2.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getPriorityText(taskPriority) {
    switch (taskPriority) {
      case TaskPriority.low:
        return 'Baja';
      case TaskPriority.medium:
        return 'Media';
      case TaskPriority.high:
        return 'Alta';
      default:
        return 'Media';
    }
  }

  Color _getPriorityColor(taskPriority) {
    switch (taskPriority) {
      case TaskPriority.low:
        return AppColors.success;
      case TaskPriority.medium:
        return AppColors.warning;
      case TaskPriority.high:
        return AppColors.error;
      default:
        return AppColors.warning;
    }
  }
}
