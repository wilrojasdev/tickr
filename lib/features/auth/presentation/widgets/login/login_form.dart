import 'package:flutter/material.dart';
import 'package:tickr/core/theme/app_colors.dart';
import '../common/common_widgets.dart';

class LoginForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final VoidCallback onLogin;
  final bool isLoading;
  final String? errorMessage;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.usernameController,
    required this.passwordController,
    required this.onLogin,
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return AuthCard(
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Campo de username
            CustomTextField(
              controller: widget.usernameController,
              label: 'Nombre de usuario',
              hint: 'Ingresa tu nombre de usuario',
              icon: Icons.person_outline_rounded,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu nombre de usuario';
                }
                if (value.length < 3) {
                  return 'El nombre de usuario debe tener al menos 3 caracteres';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            // Campo de contraseña
            CustomTextField(
              controller: widget.passwordController,
              label: 'Contraseña',
              hint: 'Ingresa tu contraseña',
              icon: Icons.lock_outline_rounded,
              obscureText: _obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  color: AppColors.textSecondary,
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu contraseña';
                }
                if (value.length < 6) {
                  return 'La contraseña debe tener al menos 6 caracteres';
                }
                return null;
              },
            ),

            const SizedBox(height: 32),

            // Botón de login
            GradientButton(
              text: 'Iniciar Sesión',
              onPressed: widget.onLogin,
              isLoading: widget.isLoading,
            ),

            const SizedBox(height: 16),

            // Mostrar error si existe
            if (widget.errorMessage != null)
              ErrorDisplay(
                message: widget.errorMessage!,
              ),
          ],
        ),
      ),
    );
  }
}
