class Todo {
  int? id;
  String title;
  bool isDone;

  Todo({
    this.id,
    required this.title,
    this.isDone = false,
  });

  // Convert object to Map (for SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isDone': isDone ? 1 : 0,
    };
  }

  // Convert Map to object
  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map['title'],
      isDone: map['isDone'] == 1,
    );
  }
}
