class TaskItem {
  final String id;
  final String title;
  final String description;
  final int? dueDate;
  final int priority;

  TaskItem({
    required this.id,
    required this.title,
    required this.description,
    this.dueDate,
    required this.priority,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'priority': priority,
    };
  }

  factory TaskItem.fromMap(Map<String, dynamic> map) {
    return TaskItem(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: map['dueDate'],
      priority: map['priority'],
    );
  }
}