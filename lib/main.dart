import 'package:flutter/material.dart';
import 'package:mvvm/features/task_management/task_edit/task_edit_view.dart';
import 'package:mvvm/features/task_management/task_list/task_list_view.dart';
import 'package:mvvm/features/task_management/task_new/task_new_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Simple MVVM',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: TaskListView.routeName,
      routes: {
        TaskListView.routeName: (context) => TaskListView(),
        TaskNewView.routeName: (context) => TaskNewView(),
        TaskEditView.routeName: (context) => TaskEditView(),
      },
    );
  }
}
