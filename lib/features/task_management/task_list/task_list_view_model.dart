import 'package:flutter/material.dart';
import 'package:mvvm/features/task_management/models/task.dart';
import 'package:mvvm/features/task_management/repositories/task_repository.dart';

class TaskListViewModel with ChangeNotifier {
  final ITaskRepository taskRepo;
  List<Task> _tasks = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';

  TaskListViewModel(this.taskRepo);

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;

  Future<void> fetchTasks() async {
    try {
      _isLoading = true;
      notifyListeners();
      _tasks = await taskRepo.fetchTasks();
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Failed to fetch tasks';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
