import 'package:get/get.dart';
import '../models/todo.dart';
import '../services/database_service.dart';

class TodoController extends GetxController {
  var todos = <Todo>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadTodos();
  }

  Future<void> loadTodos() async {
    final data = await TodoDatabase.instance.getTodos();
    todos.assignAll(data);
  }

  Future<void> addTodo(String title) async {
    final todo = await TodoDatabase.instance.insertTodo(Todo(title: title));
    todos.add(todo);
  }

  Future<void> toggleTodoStatus(Todo todo) async {
    final updated = Todo(
      id: todo.id,
      title: todo.title,
      isDone: !todo.isDone,
    );
    await TodoDatabase.instance.updateTodo(updated);
    loadTodos();
  }

  Future<void> deleteTodo(int id) async {
    await TodoDatabase.instance.deleteTodo(id);
    todos.removeWhere((t) => t.id == id);
  }
}
