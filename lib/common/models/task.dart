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
