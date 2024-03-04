import 'package:mvvm/features/task_management/models/task.dart';
import 'package:mvvm/features/task_management/services/http_client.dart';

class TaskService {
  final HttpClient _httpClient;

  TaskService(this._httpClient); // Inject the HttpClient instance

  final String baseUrl = 'https://your-api-url/tasks';

  Future<List<Task>> fetchTasks() async {
    try {
      final response = await _httpClient.get(baseUrl);
      final List<dynamic> responseData = response.data;
      return responseData.map((json) => Task.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch tasks');
    }
  }

  Future<Task> createTask(Task task) async {
    try {
      final response = await _httpClient.post(
        baseUrl,
        task.toJson(),
      );
      final responseData = Task.fromJson(response.data);
      return responseData;
    } catch (e) {
      throw Exception('Failed to create task');
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      await _httpClient.put(
        '$baseUrl/${task.id}',
        task.toJson(),
      );
    } catch (e) {
      throw Exception('Failed to update task');
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _httpClient.delete('$baseUrl/$taskId');
    } catch (e) {
      throw Exception('Failed to delete task');
    }
  }
}
