import 'package:flutter/material.dart';
import 'package:mvvm/common/models/task.dart';
import 'package:go_router/go_router.dart';

class TaskList extends StatelessWidget {
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
            context.go("/task/${tasks[index].id}");
          },
          title: Text(task.title),
          subtitle: Text(task.description),
        );
      },
    );
  }
}
