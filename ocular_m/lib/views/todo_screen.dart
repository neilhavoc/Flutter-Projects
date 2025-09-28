import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodels/todo_view_model.dart';

// ignore: use_key_in_widget_constructors
class TodoPage extends StatelessWidget {
  final TodoController controller = Get.put(TodoController());
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xAA222f3e),// dark background
      appBar: AppBar(
        backgroundColor: Color(0xAA222f3e),
        title: Text("Todo List", style: TextStyle(color: Colors.white,
        fontSize: 24.0,
        fontWeight: FontWeight.bold,)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textController,
                    style: TextStyle(color: Colors.black), // text inside = black
                    decoration: InputDecoration(
                      hintText: "Enter todo",
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      filled: true,
                      fillColor: Colors.white, // ✅ White background
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blueAccent),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    if (textController.text.isNotEmpty) {
                      controller.addTodo(textController.text);
                      textController.clear();
                    }
                  },
                  child: Text("Add"),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: controller.todos.length,
                itemBuilder: (context, index) {
                  final todo = controller.todos[index];
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white, // ✅ White background for list tile
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(
                        todo.title,
                        style: TextStyle(
                          color: todo.isDone ? Colors.grey : Colors.black, // text black
                          decoration: todo.isDone
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      leading: Checkbox(
                        value: todo.isDone,
                        activeColor: Colors.blueAccent,
                        checkColor: Colors.white,
                        onChanged: (_) {
                          controller.toggleTodoStatus(todo);
                        },
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => controller.deleteTodo(todo.id!),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}