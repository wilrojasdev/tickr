import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../common/common_widgets.dart';

class SplashLoading extends StatefulWidget {
  final AnimationController animationController;
  final String loadingText;

  const SplashLoading({
    super.key,
    required this.animationController,
    this.loadingText = 'Cargando...',
  });

  @override
  State<SplashLoading> createState() => _SplashLoadingState();
}

class _SplashLoadingState extends State<SplashLoading> {
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: widget.animationController,
      curve: Curves.easeIn,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: LoadingIndicator(
            size: 40,
            strokeWidth: 3,
            color: AppColors.white,
            text: widget.loadingText,
            showBackground: true,
          ),
        );
      },
    );
  }
}
