# Flutter MVVM using Feature Driven Development

At times, you might develop an application that primarily interacts with a service, in containing minimal business logic within the app. In such scenarios, a complex multi-layered structure isn't necessary, but a solution that remains testable is still crucial.

In this blog post, we'll explore implementing a FDD(Feaure Driven Development) MVVM in Flutter, focusing specifically on interacting with a JSON API.

### Feature Driven Development

Feature-driven development (FDD) arranges a software system based on its features instead of technical parts. It's about breaking down the system into manageable pieces centered around what it does for users. This approach helps in keeping things organized, making development easier, and ensuring the system aligns well with what users need. It's all about building things step by step and making sure the system grows smoothly as new features are added.

### One Feature, One Directory

In feature-driven architecture, each feature typically corresponds to a separate module or folder within the codebase. This organizational structure helps keep related code, components, and resources together, making it easier to manage and understand the system. Each feature folder may contain everything related to that feature, such as components, models, view models, views, and other necessary files. This modular approach enhances code maintainability, scalability, and team collaboration.

### What is MVVM?
MVVM stands for Model-View-ViewModel, and it's a way to organize code when building applications, especially ones with complex interfaces like websites, mobile apps, or desktop programs.

1. **Model**: This is the part of your app that deals with the actual data, rules, and logic. 

2. **View**: This is what the users see and interact with. It's all about the visuals and layouts, like buttons, text, and images. The View is a display window that shows stuff from the Model but through the ViewModel.

3. **ViewModel**: This acts as a middleman between the Model and the View. It takes data from the Model and shapes it so the View can easily display it. If a user does something, like clicking a button, the ViewModel updates the Model accordingly and then might change what’s shown on the screen.

The cool part about MVVM is that it keeps these sections separate. The View doesn't need to know where the data comes from, and the Model doesn't need to care about how its data is shown. This separation makes your code cleaner, easier to manage, and more fun to work with. Plus, it helps a lot with testing and fixing bugs since everything isn’t tangled up.

### File/Folder Structure

```
.
└── lib/
    └── features/
        └── task_management/
            ├── components/
            │   ├── task_list.dart
            │   ├── task_form.dart
            │   └── task_detail.dart
            ├── views/
            │   ├── task_list/
            │   │   ├── view.dart
            │   │   └── view_model.dart
            │   ├── task_detail/
            │   │   ├── view.dart
            │   │   └── view_model.dart
            │   └── task_new/
            │       ├── view.dart
            │       └── view_model.dart
            ├── models/
            │   └── task.dart
            └── services/
                ├── http_client.dart
                ├── dio_wrapper.dart
                └── task_service.dart
```

### Task Model

```dart
class Task {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.isCompleted,
  });

  // Factory method to create a Task object from JSON data
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dueDate: DateTime.parse(json['dueDate']),
      isCompleted: json['isCompleted'],
    );
  }

  // Method to convert Task object to JSON data
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }
}

```

### Task Service


```dart
import 'package:dio/dio.dart';
import 'package:task_management_app/models/task.dart';

class TaskService {
  final Dio _dio = Dio();
  final String baseUrl = 'https://your-api-url/tasks';

  Future<List<Task>> fetchTasks() async {
    try {
      final response = await _dio.get(baseUrl);
      final List<dynamic> responseData = response.data;
      return responseData.map((json) => Task.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch tasks');
    }
  }

  Future<Task> createTask(Task task) async {
    try {
      final response = await _dio.post(
        baseUrl,
        data: task.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      return Task.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create task');
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      await _dio.put(
        '$baseUrl/${task.id}',
        data: task.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
    } catch (e) {
      throw Exception('Failed to update task');
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _dio.delete('$baseUrl/$taskId');
    } catch (e) {
      throw Exception('Failed to delete task');
    }
  }
}

```

To make the Service testable we need to create a wrapper for Dio that allows for dependency injection into the service. 
We can define an interface for the wrapper and provide an implementation that wraps Dio. This approach enables us to easily mock the wrapper for testing purposes:

First, define the wrapper interface:

```dart
//
abstract class HttpClient {
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters});
  Future<Response> post(String path, {dynamic data});
  Future<Response> put(String path, {dynamic data});
  Future<Response> delete(String path);
}
```

Next, implement the wrapper using Dio:

```dart
import 'package:dio/dio.dart';

class DioWrapper implements HttpClient {
  final Dio _dio = Dio();

  @override
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    return _dio.get(path, queryParameters: queryParameters);
  }

  @override
  Future<Response> post(String path, {dynamic data}) {
    return _dio.post(path, data: data);
  }

  @override
  Future<Response> put(String path, {dynamic data}) {
    return _dio.put(path, data: data);
  }

  @override
  Future<Response> delete(String path) {
    return _dio.delete(path);
  }
}

```

Now, update the TaskService class to accept an instance of HttpClient in its constructor:

```dart
import 'package:dio/dio.dart';
import 'http_client.dart'; // Import the HttpClient interface

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

  // Other methods remain unchanged...
}

```

With this setup, you can create and inject mock implementations of HttpClient for testing purposes. This allows you to isolate the TaskService class and test its behavior independently of the actual network calls implementation.


```dart
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


```

