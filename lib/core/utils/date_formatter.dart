import 'package:intl/intl.dart';

class DateFormatter {
  // Formatear fecha a string con formato específico
  static String formatDate(DateTime date, {String pattern = 'dd/MM/yyyy'}) {
    final formatter = DateFormat(pattern);
    return formatter.format(date);
  }

  // Formatear fecha y hora
  static String formatDateTime(DateTime dateTime,
      {String pattern = 'dd/MM/yyyy HH:mm'}) {
    final formatter = DateFormat(pattern);
    return formatter.format(dateTime);
  }

  // Formatear fecha relativa (hace X tiempo)
  static String formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return formatDate(date);
    } else if (difference.inDays > 0) {
      return 'Hace ${difference.inDays} día${difference.inDays > 1 ? 's' : ''}';
    } else if (difference.inHours > 0) {
      return 'Hace ${difference.inHours} hora${difference.inHours > 1 ? 's' : ''}';
    } else if (difference.inMinutes > 0) {
      return 'Hace ${difference.inMinutes} minuto${difference.inMinutes > 1 ? 's' : ''}';
    } else {
      return 'Ahora';
    }
  }
}
