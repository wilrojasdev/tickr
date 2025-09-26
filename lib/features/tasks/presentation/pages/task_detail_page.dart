import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickr/core/theme/app_typography.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/responsive/responsive.dart';
import '../../domain/entities/task.dart';
import '../providers/task_provider.dart';
import '../widgets/detail/detail_widgets.dart';
import 'task_form_page.dart';
import '../widgets/common/appbar_custom.dart';

class TaskDetailPage extends StatefulWidget {
  final Task task;

  const TaskDetailPage({super.key, required this.task});

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  Task? _currentTask;

  @override
  void initState() {
    super.initState();
    _currentTask = widget.task;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: TaskAppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Detalle de Tarea',
          style: AppTypography.headline3.copyWith(
            fontSize:
                Responsive.scaleFont(context, AppTypography.fontSizeTitle),
          ),
        ),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          // Buscar la tarea actualizada en la lista del provider
          final updatedTask = taskProvider.tasks.firstWhere(
            (t) => t.id == widget.task.id,
            orElse: () => _currentTask ?? widget.task,
          );

          if (updatedTask.id == widget.task.id && updatedTask != _currentTask) {
            _currentTask = updatedTask;
          }

          final task = _currentTask ?? widget.task;
          final isLoading = taskProvider.isTaskBeingUpdated(task.id) ||
              taskProvider.isTaskBeingToggled(task.id);

          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TaskDetailHeader(
                      task: task,
                      onEdit: () => _navigateToTaskForm(task),
                      onToggleComplete: () => _toggleTaskComplete(task),
                      onDelete: () => _deleteTask(task),
                      isLoading: taskProvider.isTaskBeingUpdated(task.id),
                    ),
                    TaskDetailContent(task: task),
                  ],
                ),
              ),

              // Overlay de carga
              if (isLoading)
                Container(
                  color: Colors.black.withValues(alpha: 0.4),
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  void _navigateToTaskForm(task) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskFormPage(task: task),
      ),
    );

    if (result == true) {
      if (mounted) {
        context.read<TaskProvider>().loadTasks();
        Navigator.pop(context);
      }
    }
  }

  void _toggleTaskComplete(task) {
    context.read<TaskProvider>().toggleTaskCompletion(task);
  }

  void _deleteTask(task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Tarea'),
        content: Text('¿Estás seguro de que quieres eliminar "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<TaskProvider>().deleteTask(task.id);
              Navigator.pop(context); // Volver a la lista
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
