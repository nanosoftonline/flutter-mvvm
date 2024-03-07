import 'package:flutter/material.dart';
import 'package:mvvm/common/services/dio_client.dart';
import 'package:mvvm/features/task_management/task_management_repository.dart';
import 'package:mvvm/features/task_management/task_new/task_new_view_model.dart';

class CreateTaskView extends StatelessWidget {
  final TaskNewViewModel _viewModel = TaskNewViewModel(TaskRepository(DioWrapper()));

  CreateTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Title'),
              onChanged: (value) {
                _viewModel.title = value;
              },
            ),
            const SizedBox(height: 16.0),
            TextField(
              decoration: const InputDecoration(labelText: 'Description'),
              onChanged: (value) {
                _viewModel.description = value;
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _viewModel.createTask();
                Navigator.pop(context); // Navigate back to the previous screen
              },
              child: const Text('Create Task'),
            ),
          ],
        ),
      ),
    );
  }
}
