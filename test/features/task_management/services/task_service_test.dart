import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mvvm/features/task_management/models/task.dart';
import 'package:mvvm/features/task_management/services/http_client.dart';
import 'package:mvvm/features/task_management/services/task_service.dart';

class MockHttpClient extends Mock implements HttpClient {}

void main() {
  group('TaskService', () {
    late TaskService taskService;
    late MockHttpClient mockHttpClient;

    setUp(() {
      mockHttpClient = MockHttpClient();
      taskService = TaskService(mockHttpClient);
    });

    test('fetchTasks - success', () async {
      // Arrange
      final tasksJson = [
        {
          'id': '1',
          'title': 'Task 1',
          'description': 'Description 1',
          'dueDate': '2022-12-31T00:00:00.000Z',
          'isCompleted': false,
        },
        {
          'id': '2',
          'title': 'Task 2',
          'description': 'Description 2',
          'dueDate': '2022-12-31T00:00:00.000Z',
          'isCompleted': true,
        },
      ];
      final expectedTasks = tasksJson.map((json) => Task.fromJson(json)).toList();
      when(() => mockHttpClient.get("https://your-api-url/tasks")).thenAnswer((_) async => HttpResponse(
            data: tasksJson,
            statusCode: 200,
            message: 'OK',
          ));

      // Act
      final result = await taskService.fetchTasks();

      // Assert
      expect(listEquals(result, expectedTasks), true);
    });

    test('fetchTasks - failure', () async {
      // Arrange
      when(() => mockHttpClient.get("url")).thenThrow(Exception('Failed to fetch tasks'));

      // Act & Assert
      expect(() async => await taskService.fetchTasks(), throwsException);
    });
  });
}
