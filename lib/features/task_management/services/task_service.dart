import 'package:mvvm/features/task_management/models/task.dart';
import 'package:mvvm/features/task_management/services/http_client.dart';
import 'package:mvvm/features/task_management/services/task_service_contract.dart';

class TaskService implements ITaskService {
  final HttpClient _httpClient;

  TaskService(this._httpClient); // Inject the HttpClient instance

  final String baseUrl = 'http://localhost:3000/tasks';

  @override
  Future<List<Task>> fetchTasks() async {
    try {
      final response = await _httpClient.get(baseUrl);
      final List<dynamic> responseData = response.data;
      return responseData.map((json) => Task.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch tasks');
    }
  }

  @override
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

  @override
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

  @override
  Future<void> deleteTask(String taskId) async {
    try {
      await _httpClient.delete('$baseUrl/$taskId');
    } catch (e) {
      throw Exception('Failed to delete task');
    }
  }
}
