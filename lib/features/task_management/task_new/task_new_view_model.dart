import 'package:flutter/material.dart';
import 'package:mvvm/features/task_management/models/task.dart';
import 'package:mvvm/features/task_management/repositories/task_repository.dart';

class TaskNewViewModel with ChangeNotifier {
  final ITaskRepository _taskService;
  String _title = '';
  String _description = '';
  DateTime _dueDate = DateTime.now().add(const Duration(days: 1));
  bool _hasError = false;
  String _errorMessage = '';

  TaskNewViewModel(this._taskService);

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

  DateTime get dueDate => _dueDate;
  set dueDate(DateTime value) {
    _dueDate = value;
    notifyListeners();
  }

  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;

  Future<void> createTask() async {
    try {
      await _taskService.createTask(Task(
        title: _title,
        description: _description,
        isCompleted: false,
        dueDate: _dueDate,
      ));
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Failed to create task';
      notifyListeners();
    }
  }
}
