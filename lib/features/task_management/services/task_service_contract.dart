import 'package:mvvm/features/task_management/models/task.dart';

abstract class ITaskService {
  Future<List<Task>> fetchTasks();
  Future<Task> createTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String taskId);
}
