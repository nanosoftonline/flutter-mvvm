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
                └── task_service.dart
```

Let's start with the model

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

