import 'package:flutter/material.dart';
import 'package:mvvm/features/task_management/components/task_list.dart';
import 'package:mvvm/common/services/dio_client.dart';
import 'package:mvvm/features/task_management/task_management_repository.dart';
import 'package:mvvm/features/task_management/task_list/task_list_view_model.dart';
import 'package:go_router/go_router.dart';

class UserListView extends StatelessWidget {
  UserListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.go('/user/new');
            },
          ),
        ],
      ),
      body: const Column(children: [Text("User List")]),
    );
  }
}
