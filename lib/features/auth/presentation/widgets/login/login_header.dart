import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../common/common_widgets.dart';

class LoginHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const LoginHeader({
    super.key,
    this.title = '¡Bienvenido!',
    this.subtitle = 'Inicia sesión para continuar',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Logo moderno
        const AppLogo(
          size: 80,
          showShadow: true,
        ),
        const SizedBox(height: 24),

        // Título principal
        Text(
          title,
          style: AppTypography.headline2.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 28,
          ),
        ),
        const SizedBox(height: 8),

        // Subtítulo
        Text(
          subtitle,
          style: AppTypography.bodyText1.copyWith(
            color: AppColors.textSecondary,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
