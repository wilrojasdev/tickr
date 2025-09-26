import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/task.dart';
import '../../domain/entities/task_priority.dart';

class TaskForm extends StatefulWidget {
  final Task? task; // Si es null, es creación; si tiene valor, es edición
  final Function(Task) onSave;
  final bool isLoading;
  final String? error;

  const TaskForm({
    super.key,
    this.task,
    required this.onSave,
    this.isLoading = false,
    this.error,
  });

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDueDate;
  TaskPriority? _selectedPriority;
  bool _isEditing = false;

  final List<TaskPriority> _priorities = TaskPriority.values;

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
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Campo de título
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Título *',
              hintText: 'Ingresa el título de la tarea',
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'El título es obligatorio';
              }
              if (value.trim().length < 3) {
                return 'El título debe tener al menos 3 caracteres';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Campo de descripción
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Descripción *',
              hintText: 'Describe la tarea en detalle',
            ),
            maxLines: 4,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'La descripción es obligatoria';
              }
              if (value.trim().length < 10) {
                return 'La descripción debe tener al menos 10 caracteres';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Selector de prioridad
          DropdownButtonFormField<TaskPriority>(
            value: _selectedPriority,
            decoration: const InputDecoration(
              labelText: 'Prioridad',
            ),
            items: _priorities.map((priority) {
              return DropdownMenuItem(
                value: priority,
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _getPriorityColor(priority),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(priority.label),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedPriority = value;
              });
            },
          ),
          const SizedBox(height: 16),

          // Selector de fecha de vencimiento
          InkWell(
            onTap: _selectDueDate,
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Fecha de vencimiento',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              child: Text(
                _selectedDueDate != null
                    ? '${_selectedDueDate!.day}/${_selectedDueDate!.month}/${_selectedDueDate!.year}'
                    : 'Seleccionar fecha',
                style: AppTypography.bodyText1.copyWith(
                  color: _selectedDueDate != null
                      ? AppColors.textPrimary
                      : AppColors.textHint,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Botón de guardar
          ElevatedButton(
            onPressed: widget.isLoading ? null : _saveTask,
            child: widget.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.white),
                    ),
                  )
                : Text(_isEditing ? 'Actualizar Tarea' : 'Crear Tarea'),
          ),

          // Mostrar error si existe
          if (widget.error != null) ...[
            const SizedBox(height: 16),
            Text(
              widget.error!,
              style: AppTypography.bodyText2.copyWith(
                color: AppColors.error,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return AppColors.error;
      case TaskPriority.medium:
        return AppColors.warning;
      case TaskPriority.low:
        return AppColors.success;
    }
  }

  Future<void> _selectDueDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null && picked != _selectedDueDate) {
      setState(() {
        _selectedDueDate = picked;
      });
    }
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final task = Task(
        id: _isEditing ? widget.task!.id : 0,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        completed: _isEditing ? widget.task!.completed : false,
        createdAt: _isEditing ? widget.task!.createdAt : DateTime.now(),
        dueDate: _selectedDueDate,
        priority: _selectedPriority,
      );

      widget.onSave(task);
    }
  }
}
