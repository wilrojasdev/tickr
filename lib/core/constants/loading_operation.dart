enum LoadingOperation {
  none,
  loadingTasks,
  creatingTask,
  updatingTask,
  deletingTask,
  togglingTask,
}

extension LoadingOperationExtension on LoadingOperation {
  String get description {
    switch (this) {
      case LoadingOperation.none:
        return 'Sin operación';
      case LoadingOperation.loadingTasks:
        return 'Cargando tareas';
      case LoadingOperation.creatingTask:
        return 'Creando tarea';
      case LoadingOperation.updatingTask:
        return 'Actualizando tarea';
      case LoadingOperation.deletingTask:
        return 'Eliminando tarea';
      case LoadingOperation.togglingTask:
        return 'Cambiando estado';
    }
  }
}
