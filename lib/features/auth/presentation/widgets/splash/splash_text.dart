import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';

class SplashText extends StatefulWidget {
  final AnimationController animationController;
  final String title;
  final String subtitle;

  const SplashText({
    super.key,
    required this.animationController,
    this.title = 'Tickr',
    this.subtitle = 'Gestiona tus tareas de manera eficiente',
  });

  @override
  State<SplashText> createState() => _SplashTextState();
}

class _SplashTextState extends State<SplashText> {
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: widget.animationController,
      curve: Curves.easeIn,
    ));

    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: widget.animationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Column(
              children: [
                // Nombre de la aplicación
                Text(
                  widget.title,
                  style: AppTypography.headline1.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 42,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 12),

                // Descripción con mejor tipografía
                Text(
                  widget.subtitle,
                  style: AppTypography.bodyText1.copyWith(
                    color: AppColors.white.withValues(alpha: 0.9),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
