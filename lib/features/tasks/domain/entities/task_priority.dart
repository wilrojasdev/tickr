enum TaskPriority {
  low('low', 'Baja'),
  medium('medium', 'Media'),
  high('high', 'Alta');

  const TaskPriority(this.value, this.label);

  final String value;
  final String label;

  static TaskPriority? fromString(String? value) {
    if (value == null) return null;

    for (final priority in TaskPriority.values) {
      if (priority.value == value) {
        return priority;
      }
    }
    return null;
  }

  static TaskPriority fromStringOrLow(String? value) {
    return fromString(value) ?? TaskPriority.low;
  }
}
