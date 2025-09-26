import 'package:flutter/material.dart';
import 'package:tickr/features/tasks/domain/entities/task.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';

class TaskStatusIndicator extends StatelessWidget {
  final Task task;
  final bool isCompact;

  const TaskStatusIndicator({
    super.key,
    required this.task,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final statusData = _getStatusData(task);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 8 : 12,
        vertical: isCompact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: statusData.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(isCompact ? 8 : 12),
        border: Border.all(
          color: statusData.color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            statusData.icon,
            size: isCompact ? 12 : 14,
            color: statusData.color,
          ),
          if (!isCompact) ...[
            const SizedBox(width: 4),
            Text(
              statusData.label,
              style: AppTypography.caption.copyWith(
                color: statusData.color,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  StatusData _getStatusData(Task task) {
    if (task.completed) {
      return StatusData(
        color: AppColors.success,
        icon: Icons.check_circle_rounded,
        label: 'Completada',
      );
    } else if (task.dueDate != null &&
        task.dueDate!.isBefore(DateTime.now()) &&
        !task.completed) {
      return StatusData(
        color: AppColors.error,
        icon: Icons.schedule_rounded,
        label: 'Vencida',
      );
    } else {
      return StatusData(
        color: AppColors.info,
        icon: Icons.schedule_rounded,
        label: 'Pendiente',
      );
    }
  }
}

class StatusData {
  final Color color;
  final IconData icon;
  final String label;

  StatusData({
    required this.color,
    required this.icon,
    required this.label,
  });
}
