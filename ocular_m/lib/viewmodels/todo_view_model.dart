import 'package:get/get.dart';
import '../models/todo.dart';



class TodoViewModel extends GetxController {

  var todos = <Todo>[].obs;
  
  void addTodo(String title, String details){

    if (title.trim().isNotEmpty){
      todos.add(Todo(title: title, details: details));

    }

  }

  void toggleTodoStatus(int index){

    todos[index].isDone = !todos[index].isDone;
    todos.refresh(); // notify UI

  }

  void deleteTodo(int index) {
    todos.removeAt(index);
  }


}