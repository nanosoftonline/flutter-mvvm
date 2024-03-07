import 'package:mvvm/config.dart';
import 'package:mvvm/features/task_management/models/task.dart';
import 'package:mvvm/features/task_management/repositories/http_client.dart';

const baseUrl = Config.apiBase;

abstract class ITaskRepository {
  Future<List<Task>> fetchTasks();
  Future<Task> createTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String taskId);
}

class TaskRepository implements ITaskRepository {
  final HttpClient _httpClient;

  TaskRepository(this._httpClient); // Inject the HttpClient instance

  @override
  Future<List<Task>> fetchTasks() async {
    try {
      final response = await _httpClient.get("$baseUrl/tasks");
      final List<dynamic> responseData = response.data;
      return responseData.map((json) => Task.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch tasks');
    }
  }

  @override
  Future<Task> createTask(Task task) async {
    try {
      var res = await _httpClient.post(
        "$baseUrl/tasks",
        task.toJson(),
      );

      return Task.fromJson(res.data);
    } catch (e) {
      throw Exception('Failed to create task');
    }
  }

  @override
  Future<void> updateTask(Task task) async {
    try {
      await _httpClient.put(
        '$baseUrl/tasks/${task.id}',
        task.toJson(),
      );
    } catch (e) {
      throw Exception('Failed to update task');
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    try {
      await _httpClient.delete('$baseUrl/tasks/$taskId');
    } catch (e) {
      throw Exception('Failed to delete task');
    }
  }
}
