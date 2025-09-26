import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/utils/date_formatter.dart';

class TaskDateDisplay extends StatelessWidget {
  final DateTime? date;
  final bool isDueDate;
  final bool isCompact;

  const TaskDateDisplay({
    super.key,
    this.date,
    this.isDueDate = false,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (date == null) return const SizedBox.shrink();

    final now = DateTime.now();
    final isOverdue = isDueDate && date!.isBefore(now);
    final isToday = _isSameDay(date!, now);
    final isTomorrow = _isSameDay(date!, now.add(const Duration(days: 1)));

    Color textColor = AppColors.textSecondary;
    IconData icon = Icons.calendar_today_rounded;
    String displayText = DateFormatter.formatDate(date!);

    if (isDueDate) {
      if (isOverdue) {
        textColor = AppColors.error;
        icon = Icons.warning_rounded;
      } else if (isToday) {
        textColor = AppColors.warning;
        icon = Icons.today_rounded;
      } else if (isTomorrow) {
        textColor = AppColors.info;
        icon = Icons.schedule_rounded;
      } else {
        textColor = AppColors.textSecondary;
        icon = Icons.event_rounded;
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 8 : 12,
        vertical: isCompact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: textColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(isCompact ? 8 : 12),
        border: Border.all(
          color: textColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: isCompact ? 12 : 14,
            color: textColor,
          ),
          if (isCompact) ...[
            const SizedBox(width: 4),
            Text(
              displayText,
              style: AppTypography.caption.copyWith(
                color: textColor,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
