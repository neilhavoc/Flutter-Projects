// import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodels/todo_view_model.dart';

class TodoScreen extends StatelessWidget {
  TodoScreen({super.key});

  final TodoViewModel vm = Get.put(TodoViewModel());
  final TextEditingController titleTextController = TextEditingController();
   final TextEditingController detailsTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xaa222f3e),
        title: const Text("To-Do List"),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,

        ),
        
        ),
      body: Column(
        children: [
          // Input Field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [

                Expanded( //Title field
                  child: TextField(
                    controller: titleTextController,
                    
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Enter title",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),


                Expanded( // Details field
                  child: TextField(
                    controller: detailsTextController,
                    
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Enter details",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    vm.addTodo(titleTextController.text, detailsTextController.text);
                    titleTextController.clear();
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
                        color: Colors.white,
                        // border: Border.all(
                        //   color: Colors.blue,
                        //   width: 1,
                        // ),
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
                      subtitle: Text(
                        todo.details,
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
