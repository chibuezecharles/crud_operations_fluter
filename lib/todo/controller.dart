import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'todo_model.dart';

class Controller extends GetxController {
  final GetConnect connect = GetConnect();
  final TextEditingController titleController = TextEditingController();
  final RxMap<int, Todo> todos = <int, Todo>{}.obs;
  final RxBool saving = false.obs;

  final String baseUrl = 'https://jsonplaceholder.typicode.com/todos';

  @override
  void onInit() {
    fetchTodos();
    super.onInit();
  }

  @override
  void onClose() {
    titleController.dispose();
    super.onClose();
  }

  void fetchTodos() async {
    final response = await connect.get(baseUrl);
    if (response.statusCode == 200) {
      final List list = response.body;
      for (var item in list.take(50)) { 
        final todo = Todo.fromJson(item);
        todos[todo.id!] = todo;
      }
    }
  }

  void createTodo() async {
    if (titleController.text.trim().isEmpty) return;

    saving.value = true;
    final response = await connect.post(baseUrl, {
      'title': titleController.text.trim(),
      'completed': false,
      'userId': 1,
    });

    if (response.statusCode == 201) {
      final todo = Todo.fromJson(response.body);
      todos[todo.id!] = todo;
    }
    titleController.clear();
    saving.value = false;
  }

  void updateTodoStatus(int id) async {
    final current = todos[id];
    if (current == null) return;

    saving.value = true;
    final updated = current.copyWith(completed: !current.completed);
    final response = await connect.put('$baseUrl/$id', updated.toJson());

    if (response.statusCode == 200) {
      todos[id] = updated;
    }
    saving.value = false;
  }

  void deleteTodo(int id) async {
    saving.value = true;
    final response = await connect.delete('$baseUrl/$id');

    if (response.statusCode == 200) {
      todos.remove(id);
    }
    saving.value = false;
  }
}
