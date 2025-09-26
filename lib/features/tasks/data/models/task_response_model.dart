class TaskResponseModel {
  final bool success;
  final dynamic data;
  final String? message;

  TaskResponseModel({
    required this.success,
    this.data,
    this.message,
  });

  factory TaskResponseModel.fromJson(Map<String, dynamic> json) {
    return TaskResponseModel(
      success: json['success'] as bool,
      data: json['data'],
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data,
      if (message != null) 'message': message,
    };
  }

  // Helper para obtener lista de tareas
  List<TaskDataModel> get tasksList {
    if (data is List) {
      return (data as List)
          .map((task) => TaskDataModel.fromJson(task as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  // Helper para obtener una sola tarea
  TaskDataModel? get singleTask {
    if (data is Map<String, dynamic>) {
      return TaskDataModel.fromJson(data as Map<String, dynamic>);
    }
    return null;
  }
}

class TaskDataModel {
  final int id;
  final String title;
  final String description;
  final bool completed;
  final String createdAt;
  final String? dueDate;
  final String priority;

  TaskDataModel({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
    required this.createdAt,
    this.dueDate,
    required this.priority,
  });

  factory TaskDataModel.fromJson(Map<String, dynamic> json) {
    return TaskDataModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      completed: json['completed'] as bool,
      createdAt: json['createdAt'] as String,
      dueDate: json['dueDate'] as String?,
      priority: json['priority'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'completed': completed,
      'createdAt': createdAt,
      if (dueDate != null) 'dueDate': dueDate,
      'priority': priority,
    };
  }
}
