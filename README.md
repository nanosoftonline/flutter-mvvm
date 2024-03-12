# Flutter MVVM using Feature Driven Development

At times, you might develop an application that primarily interacts with a service, in containing minimal business logic within the app. In such scenarios, a complex multi-layered structure isn't necessary, but a solution that remains testable is still crucial.

In this blog post, we'll explore implementing a FDD(Feaure Driven Development) MVVM Flutter app, focusing specifically on interacting with a JSON API.

### Feature Driven Development

Feature-driven development (FDD) arranges a software system based on its features instead of technical parts. It's about breaking down the system into manageable pieces centered around what it does for users(features). This approach helps in keeping things organized, making development easier, and ensuring the system aligns well with what users need. It's all about building things step by step and making sure the system grows smoothly as new features are added.

### One Feature, One Directory

In feature-driven architecture, each feature typically corresponds to a separate module or folder within the codebase. This organizational structure helps keep related code, components, and resources together, making it easier to manage and understand the system. Each feature folder may contain everything related to that feature, such as components, models, view models, views, and other necessary files. This modular approach enhances code maintainability, scalability, and team collaboration.

### What is MVVM?
MVVM stands for Model-View-ViewModel, and it's a way to organize code when building front-end UI-oriented applications.

1. **Model**: This is the part of your app that deals with the actual data, rules, and logic *(The model could take the form of one component or multiple components if using the repository pattern).*

2. **View**: This is what the users see and interact with. It's all about the visuals and layouts, like buttons, text, and images. The View is a display window that shows stuff from the Model but through the ViewModel.

3. **ViewModel**: This acts as a middleman between the Model and the View. It takes data from the Model and shapes it so the View can easily display it. If a user does something, like clicking a button, the ViewModel updates the Model accordingly and then might change what’s shown on the screen.

The cool part about MVVM is that it keeps these sections separate. The View doesn't need to know where the data comes from, and the Model doesn't need to care about how its data is shown. This separation makes your code cleaner, easier to manage, and more fun to work with. Plus, it helps a lot with testing.

### File / Folder Structure
Folder structure is very important to the maintenance of the application. We need to know where to find code and we need to be able to find it quickly. Depending on the way you think about your application, you might choose to keep similar part types together, example you might choose to keep all views together, all models together, all view models together. This is entirely up to you and your team to aid in good communication around maintenance of the code base. 

Because we tend to have high level discussions around features of the application, even in developer meetings, I found it useful to keep all files related to a feature, close to each other.

```
.
└── lib/
    ├── main.dart
    ├── common/
    │   ├── models/
    │   │   ├── task.dart
    │   │   └── user.dart
    │   ├── services/
    │   │   ├── dio_client.dart
    │   │   └── http_client_contract.dart
    │   └── utils
    └── features/
        └── task_management/
            ├── components/
            │   └── task_list_component.dart
            ├── task_edit/
            │   ├── task_detail_view_model.dart
            │   └── task_detail_view.dart
            ├── task_list/
            │   ├── task_list_view_model.dart
            │   └── task_list_view.dart
            ├── task_new/
            │   ├── task_new_view_model.dart
            │   └── task_new_view.dart
            └── task_repository.dart
```

### Task Model

```dart
//common/models/task.dart
import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String? id;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool isCompleted;

  const Task({
    this.id,
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

  Map<String, dynamic> toJson() {
    if (id == null) {
      return {
        'title': title,
        'description': description,
        'dueDate': dueDate.toIso8601String(),
        'isCompleted': isCompleted,
      };
    }

    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        dueDate,
        isCompleted,
      ];
}



```

In this model:

The Task class represents a task in the task management application.
It has properties such as id, title, description, dueDate, and isCompleted.
The constructor initializes these properties when creating a Task object.
The fromJson factory method converts JSON data (often received from an API) into a Task object.
The toJson method converts a Task object into JSON data (often used when sending data to an API).

To handle the logic of creating, deleting, updating, and listing tasks, you can encapsulate these operations within a repository class responsible for interacting with the data source (e.g., a database, API). Here's a simplified example of how you might implement such a service class:

### Task Service


```dart
import 'package:dio/dio.dart';
import 'package:task_management_app/models/task.dart';

class TaskRepository {
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

To make the repository testable, we need a way of mocking external dependencies. The only external dependency is the http package, dio. How do we make mock dio? Well, we don't. The best way is to create a wrapper for Dio and mock that. That allows for dependency injection into the repository. 
To do this, we need to define an interface that enforces what the wrapper is required to implement:


```dart
//common/services/http_client_contract.dart
class HttpResponse {
  final dynamic data;
  final int statusCode;
  final String message;

  HttpResponse({
    required this.data,
    required this.statusCode,
    required this.message,
  });
}

abstract class IHttpClient {
  Future<HttpResponse> get(String path, {Map<String, dynamic>? queryParameters});
  Future<HttpResponse> post(String path, dynamic data);
  Future<HttpResponse> put(String path, dynamic data);
  Future<HttpResponse> delete(String path);
}

```
This interface will now be our contract for any http client we will create. 
In this case it will be dio. We need to following the same process of creating other http clients if we intend using a different external http package. 
Lets now build the wrapper for dio called DioClient:


```dart
//common/services/dio_client.dart

import 'package:dio/dio.dart';
import 'package:mvvm/common/services/http_client_contract.dart';

class DioClient implements IHttpClient {
  final Dio _dio = Dio();

  @override
  Future<HttpResponse> get(String path, {Map<String, dynamic>? queryParameters}) async {
    var res = await _dio.get(path, queryParameters: queryParameters);
    return HttpResponse(data: res.data, statusCode: res.statusCode!, message: res.statusMessage!);
  }

  @override
  Future<HttpResponse> post(String path, dynamic data) async {
    var res = await _dio.post(path, data: data);
    return HttpResponse(data: res.data, statusCode: res.statusCode!, message: res.statusMessage!);
  }

  @override
  Future<HttpResponse> put(String path, dynamic data) async {
    var res = await _dio.put(path, data: data);
    return HttpResponse(data: res.data, statusCode: res.statusCode!, message: res.statusMessage!);
  }

  @override
  Future<HttpResponse> delete(String path) async {
    var res = await _dio.delete(path);
    return HttpResponse(data: res.data, statusCode: res.statusCode!, message: res.statusMessage!);
  }
}

```

Now, update the TaskRepository class to accept an instance of IHttpClient in its constructor. Note that the TaskRepository now knows nothing and should need to know nothing about the external implementation package, dio

```dart
//features/task_management/task_repository.dart
import 'package:mvvm/config.dart';
import 'package:mvvm/common/models/task.dart';
import 'package:mvvm/common/services/http_client_contract.dart';

const baseUrl = Config.apiBase;


class TaskRepository {
  final HttpClientContract _httpClient;

  TaskRepository(this._httpClient); // Inject the HttpClient instance

  Future<List<Task>> fetchTasks() async {
    try {
      final response = await _httpClient.get("$baseUrl/tasks");
      final List<dynamic> responseData = response.data;
      return responseData.map((json) => Task.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch tasks');
    }
  }

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

  Future<void> deleteTask(String taskId) async {
    try {
      await _httpClient.delete('$baseUrl/tasks/$taskId');
    } catch (e) {
      throw Exception('Failed to delete task');
    }
  }

  Future<Task> fetchTask(String id) {
    try {
      final response = _httpClient.get('$baseUrl/tasks/$id');
      return response.then((value) => Task.fromJson(value.data));
    } catch (e) {
      throw Exception('Failed to fetch task');
    }
  }
}



```

With this setup, you can create and inject mock implementations of HttpClient for testing purposes. This allows you to isolate the TaskRepository class and test its behavior independently of the actual network calls implementation.


```dart
//test/features/task_management/task_repository_test.dart

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mvvm/config.dart';
import 'package:mvvm/common/models/task.dart';
import 'package:mvvm/common/services/http_client_contract.dart';
import 'package:mvvm/features/task_management/task_management_repository.dart';

const baseUrl = Config.apiBase;

class MockHttpClient extends Mock implements IHttpClient {}

void main() {
  group('TaskRepository', () {
    late TaskRepository taskRepo;
    late MockHttpClient mockHttpClient;

    setUp(() {
      mockHttpClient = MockHttpClient();
      taskRepo = TaskRepository(mockHttpClient);
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
      when(() => mockHttpClient.get("$baseUrl/tasks")).thenAnswer((_) async => HttpResponse(
            data: tasksJson,
            statusCode: 200,
            message: 'OK',
          ));

      // Act
      final result = await taskRepo.fetchTasks();

      // Assert
      expect(listEquals(result, expectedTasks), true);
    });

    // Other tests...
  });
}


```




