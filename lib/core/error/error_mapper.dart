class ErrorMapper {
  static String toUserMessage(Object error) {
    final text = error.toString();

    // Auth-specific
    if (text.contains('Usuario no encontrado')) {
      return 'El usuario no existe en el sistema';
    }
    if (text.contains('Credenciales inválidas')) {
      return 'Usuario o contraseña incorrectos';
    }
    if (text.contains('Username y password son requeridos')) {
      return 'Por favor completa todos los campos';
    }

    // Common/network
    if (text.contains('Token de autenticación')) {
      return 'Sesión expirada. Por favor, inicia sesión nuevamente.';
    }

    if (text.contains('Timeout')) {
      return 'La operación tardó demasiado. Inténtalo nuevamente.';
    }

    return 'Error inesperado. Inténtalo nuevamente.';
  }
}
