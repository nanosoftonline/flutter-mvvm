import 'package:flutter/material.dart';
import 'package:mvvm/features/task_management/models/task.dart';
import 'package:mvvm/features/task_management/services/task_service.dart';

class CreateTaskViewModel with ChangeNotifier {
  final TaskService _taskService;
  String _title = '';
  String _description = '';

  CreateTaskViewModel(this._taskService);

  String get title => _title;
  set title(String value) {
    _title = value;
    notifyListeners();
  }

  String get description => _description;
  set description(String value) {
    _description = value;
    notifyListeners();
  }

  Future<void> createTask() async {
    try {
      await _taskService.createTask(Task(
        title: _title,
        description: _description,
        isCompleted: false,
        dueDate: DateTime.now(),
      ));
    } catch (e) {
      // Handle error
    }
  }
}
