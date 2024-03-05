import 'package:flutter/material.dart';
import 'package:mvvm/features/task_management/services/dio_wrapper.dart';
import 'package:mvvm/features/task_management/services/task_service.dart';
import 'package:mvvm/features/task_management/views/task_new/task_new_view_model.dart';

class CreateTaskView extends StatelessWidget {
  final CreateTaskViewModel _viewModel = CreateTaskViewModel(TaskService(DioWrapper()));

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
