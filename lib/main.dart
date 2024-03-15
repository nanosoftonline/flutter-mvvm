import 'package:flutter/material.dart';
import 'package:mvvm/features/task_management/task_edit/task_edit_view.dart';
import 'package:mvvm/features/task_management/task_list/task_list_view.dart';
import 'package:mvvm/features/task_management/task_new/task_new_view.dart';
import 'package:go_router/go_router.dart';
import 'package:mvvm/features/user/user_list/user_list_view.dart';
import 'package:mvvm/features/user/user_new/user_new_view.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
void main() {
  runApp(const MyApp());
}

class Home extends StatelessWidget {
  const Home({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Simple MVVM'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                context.go("/task");
              },
              child: const Text('Task Management'),
            ),
          ],
        ),
      ),
    );
  }
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
          initialLocation: "/",
          routes: [
            GoRoute(
              path: "/",
              builder: (context, state) => const Home(),
            ),
            ShellRoute(
              builder: (context, state, child) {
                return Scaffold(
                  body: child,
                  bottomNavigationBar: BottomNavigationBar(
                    items: const <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Users',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.task),
                        label: 'Task',
                      ),
                    ],
                    currentIndex: ["/user", "/task"].indexOf(state.uri.path),
                    onTap: (index) {
                      if (index == 0) {
                        GoRouter.of(context).go("/user");
                      } else {
                        GoRouter.of(context).go("/task");
                      }
                    },
                  ),
                );
              },
              routes: [
                GoRoute(path: "/task", builder: (context, state) => TaskListView(), routes: [
                  GoRoute(path: "new", builder: (context, state) => TaskNewView()),
                  GoRoute(path: ":id", builder: (context, state) => TaskEditView()),
                ]),
                GoRoute(path: "/user", builder: (context, state) => UserListView(), routes: [
                  GoRoute(path: "new", builder: (context, state) => UserNewView()),
                ]),
              ],
            ),
          ],
        ));
  }
}
