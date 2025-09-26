import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/responsive/responsive.dart';
import '../../domain/entities/task.dart';
import '../../domain/entities/task_priority.dart';
import '../providers/task_provider.dart';
import '../widgets/form/form_widgets.dart';
import '../../../auth/presentation/widgets/common/common_widgets.dart';
import '../widgets/common/appbar_custom.dart';

class TaskFormPage extends StatefulWidget {
  final Task? task;

  const TaskFormPage({super.key, this.task});

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? _selectedDueDate;
  TaskPriority? _selectedPriority;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.task != null;

    if (_isEditing) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _selectedDueDate = widget.task!.dueDate;
      _selectedPriority = widget.task!.priority;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: TaskAppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const SizedBox.shrink(),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                // Header con información
                TaskFormHeader(
                  isEditing: _isEditing,
                  taskTitle: widget.task?.title,
                ),

                SizedBox(height: Responsive.scaleHeight(context, 24)),

                // Formulario
                TaskFormFields(
                  formKey: _formKey,
                  titleController: _titleController,
                  descriptionController: _descriptionController,
                  selectedDueDate: _selectedDueDate,
                  selectedPriority: _selectedPriority,
                  onDueDateChanged: (date) {
                    setState(() {
                      _selectedDueDate = date;
                    });
                  },
                  onPriorityChanged: (priority) {
                    setState(() {
                      _selectedPriority = priority;
                    });
                  },
                  isLoading: taskProvider.isLoading,
                ),

                SizedBox(height: Responsive.scaleHeight(context, 24)),

                // Botones de acción
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Responsive.scaleWidth(context, 24)),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: taskProvider.isLoading
                              ? null
                              : () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: Responsive.scaleHeight(context, 16)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  Responsive.scaleWidth(context, 12)),
                            ),
                            side: BorderSide(color: AppColors.border),
                          ),
                          child: Text(
                            'Cancelar',
                            style: AppTypography.button.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: Responsive.scaleFont(
                                  context, AppTypography.fontSizeMedium),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: Responsive.scaleWidth(context, 16)),
                      Expanded(
                        flex: 2,
                        child: GradientButton(
                          text: _isEditing ? 'Actualizar' : 'Crear Tarea',
                          onPressed: taskProvider.isLoading ? null : _saveTask,
                          isLoading: taskProvider.isLoading,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: Responsive.scaleHeight(context, 32)),
              ],
            ),
          );
        },
      ),
    );
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      if (_isEditing) {
        // Actualizar tarea existente delegando al provider
        context.read<TaskProvider>().updateTask(
              widget.task!,
              title: _titleController.text.trim(),
              description: _descriptionController.text.trim(),
              dueDate: _selectedDueDate,
              priority: _selectedPriority?.value,
            );
      } else {
        // Crear nueva tarea
        context.read<TaskProvider>().createTask(
              _titleController.text.trim(),
              _descriptionController.text.trim(),
              dueDate: _selectedDueDate,
              priority: _selectedPriority?.value,
            );
      }

      Navigator.pop(context, true);
    }
  }
}
