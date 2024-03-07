import 'package:flutter/material.dart';
import 'package:mvvm/features/task_management/components/task_list.dart';
import 'package:mvvm/common/services/dio_client.dart';
import 'package:mvvm/features/task_management/task_management_repository.dart';
import 'package:mvvm/features/task_management/task_list/task_list_view_model.dart';

class TaskListView extends StatelessWidget {
  final TaskListViewModel viewModel = TaskListViewModel(TaskRepository(DioWrapper()));

  TaskListView({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await viewModel.fetchTasks();
    });
    return Scaffold(
        appBar: AppBar(
          title: const Text('Task List'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(context, '/createTask').then((_) => viewModel.fetchTasks());
              },
            ),
          ],
        ),
        body: ListenableBuilder(
          listenable: viewModel,
          builder: (BuildContext context, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (viewModel.hasError) {
              return Center(child: Text(viewModel.errorMessage));
            }
            return TaskList(tasks: viewModel.tasks);
          },
        ));
  }
}
