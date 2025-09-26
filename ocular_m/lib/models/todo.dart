class Todo {
  String title;
  String details;
  bool isDone;

  Todo({
    required this.title,
    required this.details,
    this.isDone = false,
  });
}