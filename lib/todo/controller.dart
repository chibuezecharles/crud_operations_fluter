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
      for (var item in list.take(20)) {
        final todo = Todo.fromJson(item);
        todos[todo.id!] = todo;
      }
    }
  }

  void createTodo() async {
    final title = titleController.text.trim();
    if (title.isEmpty) return;

    saving.value = true;

    // Generate a local ID since the API doesn't persist created items
    final localId = DateTime.now().millisecondsSinceEpoch;

    final response = await connect.post(baseUrl, {
      'title': title,
      'completed': false,
      'userId': 1,
    });

    if (response.statusCode == 201) {
      // We ignore the fake server ID and use our local one instead
      final todo = Todo(
        id: localId,
        title: title,
        completed: false,
        userId: 1,
      );
      todos[localId] = todo;
    } else {
      Get.snackbar('Error', 'Failed to add Todo');
    }

    titleController.clear();
    saving.value = false;
  }

 void updateTodoStatus(int id) async {
  final current = todos[id];
  if (current == null) return;

  saving.value = true;
  final updated = current.copyWith(completed: !current.completed);

  // If the ID is from a local todo (i.e., large timestamp), skip the PUT request
  final isLocalId = id > 200; // IDs from API are usually 1–200

  if (isLocalId) {
    todos[id] = updated;
  } else {
    final response = await connect.put('$baseUrl/$id', updated.toJson());

    if (response.statusCode == 200) {
      todos[id] = updated;
    } else {
      Get.snackbar('Error', 'Failed to update Todo');
    }
  }

  saving.value = false;
}


  void deleteTodo(int id) async {
    saving.value = true;
    final response = await connect.delete('$baseUrl/$id');

    if (response.statusCode == 200 || response.statusCode == 404) {
      todos.remove(id);
    } else {
      Get.snackbar('Error', 'Failed to delete Todo');
    }

    saving.value = false;
  }
}
