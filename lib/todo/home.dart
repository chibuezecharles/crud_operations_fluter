import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';
import 'todo_list.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Controller());

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: const Text('REST API Demo (TODOs App)'),
          actions: [
            if (controller.saving.value)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    'Saving...',
                    style: Get.textTheme.labelLarge?.copyWith(color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: context.width / 1.5,
              child: controller.todos.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: TodosList(), // This ListView is already scrollable
                    ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Get.defaultDialog(
            titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            contentPadding: const EdgeInsets.all(16),
            title: 'Add Todo',
            content: TextField(
              controller: controller.titleController,
              decoration: const InputDecoration(
                labelText: 'Todo',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  controller.createTodo();
                  Get.back();
                },
                child: const Text('Add'),
              ),
            ],
          ),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
