import 'dart:math';

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

    test('createTask - success', () async {
      // Arrange
      var newTaskJson = {
        'title': 'Task 1',
        'description': 'Description 1',
        'dueDate': '2022-12-31T00:00:00.000Z',
        'isCompleted': false,
      };

      final expectedResult = newTaskJson..addAll({'id': '1'});

      when(() => mockHttpClient.post("https://your-api-url/tasks", newTaskJson)).thenAnswer((_) async => HttpResponse(
            data: expectedResult,
            statusCode: 200,
            message: 'OK',
          ));

      // Act
      final result = await taskService.createTask(Task.fromJson(newTaskJson));

      // Assert
      expect(result, Task.fromJson(expectedResult));
    });

    test('createTask - failure', () async {
      // Arrange

      var newTaskJson = {
        'title': 'Task 1',
        'description': 'Description 1',
        'dueDate': '2022-12-31T00:00:00.000Z',
        'isCompleted': false,
      };

      when(() => mockHttpClient.post("url", newTaskJson)).thenThrow(() async => Exception('Some Http Exception'));

      // Act

      var error;

      try {
        await taskService.createTask(Task.fromJson(newTaskJson));
      } catch (e) {
        error = e;
      }

      // Assert specific exception
      expect(error.toString(), "Exception: Failed to create task");
    });

    test('updateTask - success', () async {
      // Arrange
      var updatedTaskJson = {
        'id': '1',
        'title': 'Task 1',
        'description': 'Description 1',
        'dueDate': '2022-12-31T00:00:00.000Z',
        'isCompleted': false,
      };

      when(() => mockHttpClient.put("https://your-api-url/tasks/1", updatedTaskJson))
          .thenAnswer((_) async => HttpResponse(
                data: updatedTaskJson,
                statusCode: 200,
                message: 'OK',
              ));

      // Act and Assert
      await taskService.updateTask(Task.fromJson(updatedTaskJson));
    });

    test('updateTask - failure', () async {
      // Arrange

      var updatedTaskJson = {
        'title': 'Task 1',
        'description': 'Description 1',
        'dueDate': '2022-12-31T00:00:00.000Z',
        'isCompleted': false,
      };

      when(() => mockHttpClient.put("url", {})).thenThrow(() async => Exception('Some Http Exception'));

      // Act

      var error;

      try {
        await taskService.updateTask(Task.fromJson(updatedTaskJson));
      } catch (e) {
        error = e;
      }

      // Assert specific exception
      expect(error.toString(), "Exception: Failed to update task");
    });

    test('deleteTask - success', () async {
      // Arrange
      when(() => mockHttpClient.delete("https://your-api-url/tasks/1")).thenAnswer((_) async => HttpResponse(
            data: null,
            statusCode: 200,
            message: 'OK',
          ));

      // Act and Assert
      await taskService.deleteTask("1");
    });

    test('deleteTask - failure', () async {
      // Arrange

      when(() => mockHttpClient.delete("url")).thenThrow(() async => Exception('Some Http Exception'));

      // Act
      var error;

      try {
        await taskService.deleteTask("1");
      } catch (e) {
        error = e;
      }

      // Assert specific exception
      expect(error.toString(), "Exception: Failed to delete task");
    });
  });
}
