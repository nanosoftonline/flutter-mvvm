import 'package:flutter/material.dart';
import 'package:mvvm/common/models/task.dart';
import 'package:mvvm/features/task_management/task_edit/task_edit_view.dart';

class TaskList extends StatelessWidget {
  static const routeName = '/';
  final Function callBack;
  const TaskList({
    super.key,
    required this.callBack,
    required this.tasks,
  });

  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return ListTile(
          onTap: () {
            Navigator.pushNamed(context, TaskEditView.routeName, arguments: {"id": tasks[index].id})
                .then((_) => callBack());
          },
          title: Text(task.title),
          subtitle: Text(task.description),
        );
      },
    );
  }
}
