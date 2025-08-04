class Todo {
  final int? id;
  final String title;
  final bool completed;
  final int userId;

  Todo({
    this.id,
    required this.title,
    required this.completed,
    this.userId = 1,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
      userId: json['userId'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'completed': completed,
      'userId': userId,
    };
  }

  Todo copyWith({int? id, String? title, bool? completed, int? userId}) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
      userId: userId ?? this.userId,
    );
  }
}
