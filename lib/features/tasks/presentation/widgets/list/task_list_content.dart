import 'package:flutter/material.dart';
import 'package:tickr/features/tasks/domain/entities/task.dart';

import '../common/common_widgets.dart';
import 'modern_task_card.dart';

class TaskListContent extends StatelessWidget {
  final List<Task> tasks;
  final bool isLoading;
  final Function(Task)? onTaskTap;
  final Function(Task)? onToggleComplete;
  final Function(Task)? onEditTask;
  final Function(Task)? onDeleteTask;
  final Function(int)? isTaskLoading;
  final Function(int)? isTaskDeleting;

  const TaskListContent({
    super.key,
    required this.tasks,
    this.isLoading = false,
    this.onTaskTap,
    this.onToggleComplete,
    this.onEditTask,
    this.onDeleteTask,
    this.isTaskLoading,
    this.isTaskDeleting,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (tasks.isEmpty) {
      return TaskEmptyState(
        title: 'No hay tareas',
        subtitle: 'Comienza creando tu primera tarea',
        actionText: 'Crear tarea',
        onAction: () {
          // Esta función se pasará desde el widget padre
        },
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return ModernTaskCard(
          task: task,
          onTap: onTaskTap != null ? () => onTaskTap!(task) : null,
          onToggleComplete:
              onToggleComplete != null ? () => onToggleComplete!(task) : null,
          onEdit: onEditTask != null ? () => onEditTask!(task) : null,
          onDelete: onDeleteTask != null ? () => onDeleteTask!(task) : null,
          isLoading: isTaskLoading?.call(task.id) ?? false,
          isDeleting: isTaskDeleting?.call(task.id) ?? false,
        );
      },
    );
  }
}
