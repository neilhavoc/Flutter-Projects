// import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view_models/todo_view_model.dart';

class TodoScreen extends StatelessWidget {
  TodoScreen({super.key});

  final TodoViewModel vm = Get.put(TodoViewModel());
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("To-Do List")),
      body: Column(
        children: [
          // Input Field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textController,
                    decoration: const InputDecoration(
                      hintText: "Enter task",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    vm.addTodo(textController.text);
                    textController.clear();
                  },
                  child: const Text("Add"),
                ),
              ],
            ),
          ),

          // Task List
          Expanded(
            child: Obx(() => ListView.builder(
                  itemCount: vm.todos.length,
                  itemBuilder: (context, index) {
                    final todo = vm.todos[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blue,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),

                      child: ListTile(
                      leading: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: todo.isDone,
                            onChanged: (_) => vm.toggleTodoStatus(index),
                          ),
                        ],

                      ),
                    
                      title: Text(
                        todo.title,
                        style: TextStyle(
                          decoration: todo.isDone
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => vm.deleteTodo(index),
                      ),
                    )
                    );
                  },
                )),
          ),
        ],
      ),
    );
  }
}
