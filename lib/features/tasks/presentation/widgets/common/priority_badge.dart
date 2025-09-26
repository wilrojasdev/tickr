import 'package:flutter/material.dart';
import 'package:tickr/features/tasks/domain/entities/task_priority.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/responsive/responsive.dart';

class PriorityBadge extends StatelessWidget {
  final TaskPriority priority;
  final bool isCompact;

  const PriorityBadge({
    super.key,
    required this.priority,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final priorityData = _getPriorityData(priority);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.scaleWidth(context, isCompact ? 8 : 12),
        vertical: Responsive.scaleHeight(context, isCompact ? 4 : 6),
      ),
      decoration: BoxDecoration(
        color: priorityData.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(
            Responsive.scaleWidth(context, isCompact ? 8 : 12)),
        border: Border.all(
          color: priorityData.color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            priorityData.icon,
            size: Responsive.scaleWidth(context, isCompact ? 12 : 14),
            color: priorityData.color,
          ),
          if (!isCompact) ...[
            SizedBox(width: Responsive.scaleWidth(context, 4)),
            Text(
              priorityData.label,
              style: AppTypography.caption.copyWith(
                color: priorityData.color,
                fontWeight: FontWeight.w600,
                fontSize: Responsive.scaleFont(context, 12),
              ),
            ),
          ],
        ],
      ),
    );
  }

  PriorityData _getPriorityData(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return PriorityData(
          color: AppColors.success,
          icon: Icons.keyboard_arrow_down_rounded,
          label: 'Baja',
        );
      case TaskPriority.medium:
        return PriorityData(
          color: AppColors.warning,
          icon: Icons.remove_rounded,
          label: 'Media',
        );
      case TaskPriority.high:
        return PriorityData(
          color: AppColors.error,
          icon: Icons.keyboard_arrow_up_rounded,
          label: 'Alta',
        );
    }
  }
}

class PriorityData {
  final Color color;
  final IconData icon;
  final String label;

  PriorityData({
    required this.color,
    required this.icon,
    required this.label,
  });
}
