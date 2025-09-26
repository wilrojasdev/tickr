import 'package:flutter/material.dart';
import 'package:tickr/features/tasks/domain/entities/task_priority.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';

import '../../../../../features/auth/presentation/widgets/common/common_widgets.dart';
import '../common/common_widgets.dart';

class TaskFormFields extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final DateTime? selectedDueDate;
  final TaskPriority? selectedPriority;
  final Function(DateTime?) onDueDateChanged;
  final Function(TaskPriority?) onPriorityChanged;
  final bool isLoading;

  const TaskFormFields({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.descriptionController,
    required this.selectedDueDate,
    required this.selectedPriority,
    required this.onDueDateChanged,
    required this.onPriorityChanged,
    this.isLoading = false,
  });

  @override
  State<TaskFormFields> createState() => _TaskFormFieldsState();
}

class _TaskFormFieldsState extends State<TaskFormFields> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 600),
      child: AuthCard(
        child: Form(
          key: widget.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Campo de título
              CustomTextField(
                controller: widget.titleController,
                label: 'Título de la tarea',
                hint: 'Ingresa el título de la tarea',
                icon: Icons.title_rounded,
                keyboardType: TextInputType.text,
                enabled: !widget.isLoading,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El título es obligatorio';
                  }
                  if (value.length < 3) {
                    return 'El título debe tener al menos 3 caracteres';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Campo de descripción
              CustomTextField(
                controller: widget.descriptionController,
                label: 'Descripción',
                hint: 'Describe los detalles de la tarea (opcional)',
                icon: Icons.description_rounded,
                keyboardType: TextInputType.multiline,
                enabled: !widget.isLoading,
                validator: (value) {
                  // La descripción es opcional
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Selector de fecha límite
              _buildDateSelector(),

              const SizedBox(height: 20),

              // Selector de prioridad
              _buildPrioritySelector(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fecha límite',
          style: AppTypography.bodyText2.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: widget.isLoading ? null : _selectDate,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.grey50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.border,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.event_rounded,
                  color: AppColors.textSecondary,
                  size: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.selectedDueDate != null
                        ? _formatDate(widget.selectedDueDate!)
                        : 'Seleccionar fecha límite (opcional)',
                    style: AppTypography.bodyText1.copyWith(
                      color: widget.selectedDueDate != null
                          ? AppColors.textPrimary
                          : AppColors.textHint,
                    ),
                  ),
                ),
                if (widget.selectedDueDate != null)
                  IconButton(
                    icon: const Icon(Icons.clear_rounded),
                    onPressed: widget.isLoading
                        ? null
                        : () => widget.onDueDateChanged(null),
                    iconSize: 20,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrioritySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Prioridad',
          style: AppTypography.bodyText2.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.grey50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.border,
              width: 1,
            ),
          ),
          child: Column(
            children: TaskPriority.values.map((priority) {
              final isSelected = widget.selectedPriority == priority;
              final priorityData = _getPriorityData(priority);

              return InkWell(
                onTap: widget.isLoading
                    ? null
                    : () => widget.onPriorityChanged(priority),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? priorityData.color.withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: isSelected
                        ? Border.all(
                            color: priorityData.color.withValues(alpha: 0.3),
                            width: 1,
                          )
                        : null,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        priorityData.icon,
                        size: 20,
                        color: priorityData.color,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          priorityData.label,
                          style: AppTypography.bodyText1.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ),
                      if (isSelected)
                        Icon(
                          Icons.check_rounded,
                          size: 20,
                          color: priorityData.color,
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: widget.selectedDueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      widget.onDueDateChanged(date);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  PriorityData _getPriorityData(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return PriorityData(
          color: AppColors.success,
          icon: Icons.keyboard_arrow_down_rounded,
          label: 'Baja',
        );
      case TaskPriority.medium:
        return PriorityData(
          color: AppColors.warning,
          icon: Icons.remove_rounded,
          label: 'Media',
        );
      case TaskPriority.high:
        return PriorityData(
          color: AppColors.error,
          icon: Icons.keyboard_arrow_up_rounded,
          label: 'Alta',
        );
    }
  }
}
