import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/auth_provider.dart';
import '../widgets/widgets.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _textAnimationController;
  late AnimationController _loadingAnimationController;

  @override
  void initState() {
    super.initState();

    // Controlador para animación del logo
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Controlador para animación del texto
    _textAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Controlador para animación del loading
    _loadingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _startAnimations();
  }

  void _startAnimations() async {
    // Iniciar animación del logo
    await _logoAnimationController.forward();

    // Iniciar animación del texto después del logo
    await Future.delayed(const Duration(milliseconds: 300));
    await _textAnimationController.forward();

    // Iniciar animación del loading
    await Future.delayed(const Duration(milliseconds: 200));
    await _loadingAnimationController.forward();

    // Esperar un poco más antes de verificar autenticación
    await Future.delayed(const Duration(milliseconds: 1000));
    _checkAuthStatus();
  }

  void _checkAuthStatus() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.checkSession();

    if (mounted) {
      if (authProvider.isAuthenticated) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _textAnimationController.dispose();
    _loadingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),

                // Logo animado con efectos modernos
                SplashLogo(
                  animationController: _logoAnimationController,
                ),

                const SizedBox(height: 40),

                // Texto animado
                SplashText(
                  animationController: _textAnimationController,
                ),

                const Spacer(flex: 2),

                // Indicador de carga moderno
                SplashLoading(
                  animationController: _loadingAnimationController,
                ),

                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
