import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/responsive/responsive.dart';

class SplashLogo extends StatefulWidget {
  final AnimationController animationController;
  final double size;

  const SplashLogo({
    super.key,
    required this.animationController,
    this.size = 140,
  });

  @override
  State<SplashLogo> createState() => _SplashLogoState();
}

class _SplashLogoState extends State<SplashLogo> {
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: widget.animationController,
      curve: Curves.elasticOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: widget.animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value * 0.1,
            child: Container(
              width: Responsive.scaleWidth(context, widget.size),
              height: Responsive.scaleWidth(context, widget.size),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(widget.size * 0.2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowDark,
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: AppColors.white.withValues(alpha: 0.1),
                    blurRadius: 1,
                    offset: const Offset(0, 1),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Logo principal
                  Image.asset(
                    'assets/logo.png',
                    width: Responsive.scaleWidth(context, 70),
                    height: Responsive.scaleWidth(context, 70),
                    fit: BoxFit.contain,
                  ),
                  // Efecto de brillo
                  Positioned(
                    top: Responsive.scaleHeight(context, 10),
                    right: Responsive.scaleWidth(context, 10),
                    child: Container(
                      width: Responsive.scaleWidth(context, 20),
                      height: Responsive.scaleWidth(context, 20),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(
                            Responsive.scaleWidth(context, 10)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
