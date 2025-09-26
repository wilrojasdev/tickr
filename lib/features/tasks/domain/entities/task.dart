import 'task_priority.dart';

class Task {
  final int id;
  final String title;
  final String description;
  final bool completed;
  final DateTime? createdAt;
  final DateTime? dueDate;
  final TaskPriority? priority;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
    this.createdAt,
    this.dueDate,
    this.priority,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Task &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.completed == completed &&
        other.createdAt == createdAt &&
        other.dueDate == dueDate &&
        other.priority == priority;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        completed.hashCode ^
        createdAt.hashCode ^
        dueDate.hashCode ^
        priority.hashCode;
  }

  @override
  String toString() {
    return 'Task(id: $id, title: $title, description: $description, completed: $completed, createdAt: $createdAt, dueDate: $dueDate, priority: $priority)';
  }
}
