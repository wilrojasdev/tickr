import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class TaskAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final Widget? leading;
  final Widget? action;

  const TaskAppBar({super.key, required this.title, this.leading, this.action});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      elevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
      ),
      leading: leading,
      title: title,
      actions: [
        if (action != null) action!,
        if (action != null) const SizedBox(width: 8),
      ],
    );
  }
}
