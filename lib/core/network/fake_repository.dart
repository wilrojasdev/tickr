import 'dart:io';

class FakeRepository {
  static const Duration _delay = Duration(milliseconds: 1500);

  // Usuarios fake para testing
  static const List<Map<String, dynamic>> _fakeUsers = [
    {
      'id': 1,
      'username': 'albert10',
      'password': 'albert123456',
      'token': 'fake_token_123',
    },
    {
      'id': 2,
      'username': 'felipe10',
      'password': 'feli123456',
      'token': 'fake_token_456',
    },
  ];

  // Tareas fake por usuario (mantenemos userId interno para la relación)
  static final Map<int, List<Map<String, dynamic>>> _fakeTasks = {
    1: [
      {
        'id': 1,
        'title': 'Revisar reportes mensuales',
        'description':
            'Analizar los reportes de productividad del mes anterior',
        'completed': false,
        'createdAt': '2025-10-15T10:00:00.000Z',
        'dueDate': '2025-10-10T10:00:00.000Z',
        'priority': 'high',
        '_userId': 1, // Campo interno para mantener la relación
      },
      {
        'id': 2,
        'title': 'Actualizar políticas de seguridad',
        'description':
            'Revisar y actualizar las políticas de seguridad de la empresa',
        'completed': true,
        'createdAt': '2025-10-10T14:30:00.000Z',
        'dueDate': '2025-10-25T14:30:00.000Z',
        'priority': 'high',
        '_userId': 1,
      },
      {
        'id': 3,
        'title': 'Reunión con equipo de desarrollo',
        'description':
            'Planificar las próximas funcionalidades de la aplicación',
        'completed': false,
        'createdAt': '2025-10-20T09:00:00.000Z',
        'dueDate': '2025-10-30T09:00:00.000Z',
        'priority': 'medium',
        '_userId': 1,
      }
    ],
    2: [
      {
        'id': 4,
        'title': 'Completar documentación del proyecto',
        'description':
            'Finalizar la documentación técnica del módulo de autenticación',
        'completed': false,
        'createdAt': '2025-10-18T11:00:00.000Z',
        'dueDate': '2025-11-18T11:00:00.000Z',
        'priority': 'medium',
        '_userId': 2,
      },
      {
        'id': 5,
        'title': 'Revisar código de compañeros',
        'description': 'Hacer code review de los pull requests pendientes',
        'completed': true,
        'createdAt': '2025-10-16T16:00:00.000Z',
        'dueDate': '2025-11-25T16:00:00.000Z',
        'priority': 'low',
        '_userId': 2,
      }
    ],
  };

  // Helper para obtener usuario por token
  static Map<String, dynamic>? _getUserByToken(String? token) {
    if (token == null) return null;
    try {
      return _fakeUsers.firstWhere((user) => user['token'] == token);
    } catch (e) {
      return null;
    }
  }

  // Simula una llamada HTTP GET
  static Future<Map<String, dynamic>> get(String endpoint,
      {Map<String, String>? headers}) async {
    try {
      await Future.delayed(_delay);

      // Obtener usuario del token de autenticación
      final authHeader = headers?['Authorization'] ?? headers?['authorization'];
      final token = authHeader?.replaceFirst('Bearer ', '');

      final user = _getUserByToken(token);

      if (user == null) {
        throw const HttpException('Token de autenticación inválido');
      }

      // Obtener tareas del usuario y remover el campo _userId
      final userTasks = _fakeTasks[user['id']] ?? [];
      final cleanTasks = userTasks.map((task) {
        final cleanTask = Map<String, dynamic>.from(task);
        cleanTask.remove('_userId'); // Remover campo interno
        return cleanTask;
      }).toList();

      return {'success': true, 'data': cleanTasks};
    } catch (e) {
      rethrow;
    }
  }

  // Simula una llamada HTTP POST
  static Future<Map<String, dynamic>> post(
      String endpoint, Map<String, dynamic> data,
      {Map<String, String>? headers}) async {
    try {
      await Future.delayed(_delay);

      switch (endpoint) {
        case '/auth/login':
          final username = data['username'] as String?;
          final password = data['password'] as String?;

          if (username == null || password == null) {
            throw const HttpException('Username y password son requeridos');
          }

          // Primero verificar si el usuario existe
          final userExists = _fakeUsers.any((u) => u['username'] == username);
          if (!userExists) {
            throw const HttpException('Usuario no encontrado');
          }

          // Buscar usuario por username y validar contraseña
          final user = _fakeUsers.firstWhere(
            (u) => u['username'] == username && u['password'] == password,
            orElse: () => throw const HttpException('Credenciales inválidas'),
          );

          return {
            'success': true,
            'data': {
              'token': user['token'],
              'user': {
                'id': user['id'],
                'username': user['username'],
              }
            }
          };

        case '/tasks':
          // Obtener usuario del token de autenticación
          final authHeader =
              headers?['Authorization'] ?? headers?['authorization'];
          final token = authHeader?.replaceFirst('Bearer ', '');
          final user = _getUserByToken(token);

          if (user == null) {
            throw const HttpException('Token de autenticación inválido');
          }

          // Crear la nueva tarea
          final newTask = {
            'id': DateTime.now().millisecondsSinceEpoch,
            'title': data['title'],
            'description': data['description'],
            'completed': false,
            'createdAt': DateTime.now().toIso8601String(),
            'dueDate': data['dueDate'],
            'priority': data['priority'] ?? 'medium',
            '_userId': user['id'], // Campo interno para mantener la relación
          };

          // Agregar la tarea a la lista del usuario
          final userId = user['id'] as int;
          if (_fakeTasks[userId] == null) {
            _fakeTasks[userId] = [];
          }
          _fakeTasks[userId]!.add(newTask);

          // Retornar la tarea sin el campo _userId
          final cleanTask = Map<String, dynamic>.from(newTask);
          cleanTask.remove('_userId');

          return {
            'success': true,
            'data': cleanTask,
          };

        default:
          throw HttpException('Endpoint no encontrado: $endpoint');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Simula una llamada HTTP PUT
  static Future<Map<String, dynamic>> put(
      String endpoint, Map<String, dynamic> data,
      {Map<String, String>? headers}) async {
    try {
      await Future.delayed(_delay);

      // Manejar endpoints específicos como /tasks/{id}
      if (endpoint.startsWith('/tasks/')) {
        final taskIdStr = endpoint.split('/').last;
        final taskId = int.tryParse(taskIdStr);

        if (taskId == null) {
          throw HttpException('ID de tarea inválido');
        }

        // Obtener usuario del token de autenticación
        final authHeader =
            headers?['Authorization'] ?? headers?['authorization'];
        final token = authHeader?.replaceFirst('Bearer ', '');
        final user = _getUserByToken(token);

        if (user == null) {
          throw const HttpException('Token de autenticación inválido');
        }

        final userId = user['id'] as int;

        // Buscar y actualizar la tarea en la lista del usuario
        final userTasks = _fakeTasks[userId];
        if (userTasks == null) {
          throw HttpException('Usuario no encontrado');
        }

        // Encontrar el índice de la tarea a actualizar
        final taskIndex = userTasks.indexWhere((task) => task['id'] == taskId);
        if (taskIndex == -1) {
          throw HttpException('Tarea no encontrada');
        }

        // Actualizar la tarea con los nuevos datos
        final updatedTask = {
          'id': taskId,
          'title': data['title'] as String,
          'description': data['description'] as String,
          'completed': data['completed'] as bool,
          'createdAt': data['createdAt'] as String,
          'dueDate': data['dueDate'] as String,
          'priority': data['priority'] as String,
          '_userId': userId, // Mantener el campo interno
        };

        // Actualizar la tarea en la lista
        userTasks[taskIndex] = updatedTask;

        // Retornar la tarea actualizada (sin el campo _userId)
        final cleanTask = Map<String, dynamic>.from(updatedTask);
        cleanTask.remove('_userId');

        return {'success': true, 'data': cleanTask};
      }

      // Para otros endpoints PUT
      throw HttpException('Endpoint PUT no encontrado: $endpoint');
    } catch (e) {
      rethrow;
    }
  }

  // Simula una llamada HTTP DELETE
  static Future<Map<String, dynamic>> delete(String endpoint,
      {Map<String, String>? headers}) async {
    try {
      await Future.delayed(_delay);

      // Manejar endpoints específicos como /tasks/{id}
      if (endpoint.startsWith('/tasks/')) {
        final taskIdStr = endpoint.split('/').last;
        final taskId = int.tryParse(taskIdStr);

        if (taskId == null) {
          throw HttpException('ID de tarea inválido');
        }

        // Obtener usuario del token de autenticación
        final authHeader =
            headers?['Authorization'] ?? headers?['authorization'];
        final token = authHeader?.replaceFirst('Bearer ', '');
        final user = _getUserByToken(token);

        if (user == null) {
          throw const HttpException('Token de autenticación inválido');
        }

        final userId = user['id'] as int;

        // Buscar y eliminar la tarea en la lista del usuario
        final userTasks = _fakeTasks[userId];
        if (userTasks == null) {
          throw HttpException('Usuario no encontrado');
        }

        // Encontrar el índice de la tarea a eliminar
        final taskIndex = userTasks.indexWhere((task) => task['id'] == taskId);
        if (taskIndex == -1) {
          throw HttpException('Tarea no encontrada');
        }

        // Eliminar la tarea de la lista
        userTasks.removeAt(taskIndex);

        return {'success': true, 'message': 'Eliminado exitosamente'};
      }

      throw HttpException('Endpoint DELETE no encontrado: $endpoint');
    } catch (e) {
      rethrow;
    }
  }
}
