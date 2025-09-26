import 'package:flutter/material.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/error/error_mapper.dart';
import '../../../../core/constants/loading_operation.dart';
import '../../domain/entities/task.dart';
import '../../domain/usecases/create_task.dart';
import '../../domain/usecases/get_tasks.dart';
import '../../domain/usecases/update_task.dart';
import '../../domain/usecases/delete_task.dart';

class TaskProvider extends ChangeNotifier {
  final CreateTask createTaskUseCase;
  final GetTasks getTasksUseCase;
  final UpdateTask updateTaskUseCase;
  final DeleteTask deleteTaskUseCase;

  TaskProvider({
    required this.createTaskUseCase,
    required this.getTasksUseCase,
    required this.updateTaskUseCase,
    required this.deleteTaskUseCase,
  });

  List<Task> _tasks = [];
  LoadingOperation _currentOperation = LoadingOperation.none;
  int? _currentTaskId; // ID de la tarea que se está procesando
  String? _error;
  bool _isSortedByDueDate = false;

  List<Task> get tasks => _isSortedByDueDate ? _getSortedTasks() : _tasks;
  LoadingOperation get currentOperation => _currentOperation;
  int? get currentTaskId => _currentTaskId;
  bool get isLoading => _currentOperation != LoadingOperation.none;
  bool get isLoadingTasks => _currentOperation == LoadingOperation.loadingTasks;
  bool get isCreatingTask => _currentOperation == LoadingOperation.creatingTask;
  bool get isUpdatingTask => _currentOperation == LoadingOperation.updatingTask;
  bool get isDeletingTask => _currentOperation == LoadingOperation.deletingTask;
  bool get isTogglingTask => _currentOperation == LoadingOperation.togglingTask;
  String? get error => _error;

  // Métodos para verificar si una tarea específica está siendo procesada
  bool isTaskBeingUpdated(int taskId) =>
      _currentOperation == LoadingOperation.updatingTask &&
      _currentTaskId == taskId;
  bool isTaskBeingDeleted(int taskId) =>
      _currentOperation == LoadingOperation.deletingTask &&
      _currentTaskId == taskId;
  bool isTaskBeingToggled(int taskId) =>
      _currentOperation == LoadingOperation.togglingTask &&
      _currentTaskId == taskId;

  List<Task> get completedTasks =>
      (_isSortedByDueDate ? _getSortedTasks() : _tasks)
          .where((task) => task.completed)
          .toList();
  List<Task> get pendingTasks =>
      (_isSortedByDueDate ? _getSortedTasks() : _tasks)
          .where((task) => !task.completed)
          .toList();

  void _setLoading(LoadingOperation operation, {int? taskId}) {
    _currentOperation = operation;
    _currentTaskId = taskId;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void _setTasks(List<Task> tasks) {
    _tasks = tasks;
    notifyListeners();
  }

  Future<void> loadTasks() async {
    _setLoading(LoadingOperation.loadingTasks);
    _setError(null);

    try {
      final tasks = await getTasksUseCase();
      _setTasks(tasks);
    } catch (e) {
      _setError(e.toString());
      NotificationService.showError(
          'Error al cargar las tareas: ${ErrorMapper.toUserMessage(e)}');
    } finally {
      _setLoading(LoadingOperation.none);
    }
  }

  Future<void> createTask(String title, String description,
      {DateTime? dueDate, String? priority}) async {
    _setLoading(LoadingOperation.creatingTask);
    _setError(null);

    try {
      final newTask = await createTaskUseCase(CreateTaskParams(
        title: title,
        description: description,
        dueDate: dueDate,
        priority: priority,
      ));

      _tasks.add(newTask);
      notifyListeners();
      NotificationService.showSuccess('Tarea "$title" creada exitosamente');
    } catch (e) {
      _setError(e.toString());
      NotificationService.showError(
          'Error al crear la tarea: ${ErrorMapper.toUserMessage(e)}');
    } finally {
      _setLoading(LoadingOperation.none);
    }
  }

  Future<void> updateTask(Task task,
      {String? title,
      String? description,
      bool? completed,
      DateTime? dueDate,
      String? priority}) async {
    _setLoading(LoadingOperation.updatingTask, taskId: task.id);
    _setError(null);

    try {
      final updatedTask = await updateTaskUseCase(UpdateTaskParams(
        task: task,
        title: title,
        description: description,
        completed: completed,
        dueDate: dueDate,
        priority: priority,
      ));

      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = updatedTask;
        notifyListeners();
        NotificationService.showSuccess(
            'Tarea "${updatedTask.title}" actualizada exitosamente');
      } else {
        NotificationService.showWarning(
            'No se pudo encontrar la tarea para actualizar');
      }
    } catch (e) {
      _setError(e.toString());
      NotificationService.showError(
          'Error al actualizar la tarea: ${ErrorMapper.toUserMessage(e)}');
    } finally {
      _setLoading(LoadingOperation.none);
    }
  }

  Future<void> deleteTask(int taskId) async {
    _setLoading(LoadingOperation.deletingTask, taskId: taskId);
    _setError(null);

    try {
      // Obtener el título de la tarea antes de eliminarla para mostrar en la notificación
      final taskToDelete = _tasks.firstWhere((task) => task.id == taskId);
      final taskTitle = taskToDelete.title;

      await deleteTaskUseCase(taskId);
      _tasks.removeWhere((task) => task.id == taskId);
      notifyListeners();
      NotificationService.showSuccess(
          'Tarea "$taskTitle" eliminada exitosamente');
    } catch (e) {
      _setError(e.toString());
      NotificationService.showError(
          'Error al eliminar la tarea: ${ErrorMapper.toUserMessage(e)}');
    } finally {
      _setLoading(LoadingOperation.none);
    }
  }

  Future<void> toggleTaskCompletion(Task task) async {
    _setLoading(LoadingOperation.togglingTask, taskId: task.id);
    _setError(null);

    try {
      final updatedTask = await updateTaskUseCase(UpdateTaskParams(
        task: task,
        completed: !task.completed,
      ));

      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = updatedTask;
        notifyListeners();
        NotificationService.showSuccess(
            'Tarea "${updatedTask.title}" ${updatedTask.completed ? 'completada' : 'marcada como pendiente'}');
      } else {
        NotificationService.showWarning(
            'No se pudo encontrar la tarea para actualizar');
      }
    } catch (e) {
      _setError(e.toString());
      NotificationService.showError(
          'Error al cambiar el estado de la tarea: ${ErrorMapper.toUserMessage(e)}');
    } finally {
      _setLoading(LoadingOperation.none);
    }
  }

  void clearError() {
    _setError(null);
  }

  void toggleSortByDueDate() {
    _isSortedByDueDate = !_isSortedByDueDate;
    notifyListeners();
  }

  List<Task> _getSortedTasks() {
    final sortedTasks = List<Task>.from(_tasks);
    sortedTasks.sort((a, b) {
      // Tareas sin fecha de vencimiento van al final
      if (a.dueDate == null && b.dueDate == null) return 0;
      if (a.dueDate == null) return 1;
      if (b.dueDate == null) return -1;

      // Ordenar por fecha de vencimiento de mayor a menor (más reciente primero)
      return b.dueDate!.compareTo(a.dueDate!);
    });
    return sortedTasks;
  }
}
