import 'package:flutter/material.dart';
import 'package:mvvm/common/models/task.dart';
import 'package:mvvm/features/task_management/task_management_repository.dart';

class TaskEditViewModel with ChangeNotifier {
  final ITaskRepository _taskRepository;
  String _title = '';
  String _description = '';
  DateTime _dueDate = DateTime.now().add(const Duration(days: 1));
  bool _hasError = false;
  String _errorMessage = '';

  TaskEditViewModel(this._taskRepository);

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

  Future<void> fetchTask(String id) async {
    try {
      var task = await _taskRepository.fetchTask(id);
      _title = task.title;
      _description = task.description;
      _dueDate = task.dueDate;
      notifyListeners();
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Failed to create task';
      notifyListeners();
    }
  }

  Future<void> updateTask(String id) async {
    try {
      await _taskRepository.updateTask(Task(
        id: id,
        title: _title,
        description: _description,
        isCompleted: false,
        dueDate: _dueDate,
      ));
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Failed to update task';
      notifyListeners();
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await _taskRepository.deleteTask(id);
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Failed to delete task';
      notifyListeners();
    }
  }
}
