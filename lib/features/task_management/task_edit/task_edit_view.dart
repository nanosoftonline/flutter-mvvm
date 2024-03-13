import 'package:flutter/material.dart';
import 'package:mvvm/common/services/dio_client.dart';
import 'package:mvvm/features/task_management/task_edit/task_edit_view_model.dart';
import 'package:mvvm/features/task_management/task_management_repository.dart';

class TaskEditView extends StatelessWidget {
  final TaskEditViewModel viewModel = TaskEditViewModel(TaskRepository(DioClient()));
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  TaskEditView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as dynamic;

    final String id = args['id'];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.fetchTask(id);
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (BuildContext context, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: titleController..text = viewModel.title,
                  decoration: const InputDecoration(labelText: 'Title'),
                  onChanged: (value) {
                    viewModel.title = value;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: descriptionController..text = viewModel.description,
                  decoration: const InputDecoration(labelText: 'Description'),
                  onChanged: (value) {
                    viewModel.description = value;
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    viewModel.updateTask(id);
                    Navigator.pop(context); // Navigate back to the previous screen
                  },
                  child: const Text('Save Task'),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    viewModel.deleteTask(id);
                    Navigator.pop(context);
                  },
                  child: const Text('Delete Task'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
