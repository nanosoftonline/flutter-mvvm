import 'package:flutter/material.dart';
import 'package:mvvm/features/task_management/task_edit/task_edit_view.dart';
import 'package:mvvm/features/task_management/task_list/task_list_view.dart';
import 'package:mvvm/features/task_management/task_new/task_new_view.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        title: 'Flutter Simple MVVM',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: GoRouter(
          initialLocation: "/task",
          routes: [
            GoRoute(
              path: "/task",
              builder: (context, state) => TaskListView(),
              routes: [
                GoRoute(path: "new", builder: (context, state) => TaskNewView()),
                GoRoute(path: ":id", builder: (context, state) => TaskEditView()),
              ],
            ),
          ],
        ));
  }
}
