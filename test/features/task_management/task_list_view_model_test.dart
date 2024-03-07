import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mvvm/common/models/task.dart';
import 'package:mvvm/features/task_management/task_management_repository.dart';
import 'package:mvvm/features/task_management/task_list/task_list_view_model.dart';

class MockTaskRepository extends Mock implements ITaskRepository {}

void main() {
  group('TaskListViewModel', () {
    test('fetchTasks: success', () async {
      final mockTaskRepository = MockTaskRepository();
      final viewModel = TaskListViewModel(mockTaskRepository);

      // Simulate a successful fetchTasks call
      when(() => mockTaskRepository.fetchTasks()).thenAnswer((_) async => [
            Task(
              description: 'Task 1',
              isCompleted: false,
              id: "1",
              title: "Task 1",
              dueDate: DateTime.now(),
            )
          ]);

      expect(viewModel.isLoading, false);
      await viewModel.fetchTasks();
      expect(viewModel.isLoading, false);
      expect(viewModel.tasks.length, 1);

      verify(() => mockTaskRepository.fetchTasks()).called(1);
    });

    test('fetchTasks: failure', () async {
      final mockTaskRepository = MockTaskRepository();
      final viewModel = TaskListViewModel(mockTaskRepository);

      // Simulate a failed fetchTasks call
      when(() => mockTaskRepository.fetchTasks()).thenThrow(Exception());

      expect(viewModel.isLoading, false);
      await viewModel.fetchTasks();
      expect(viewModel.isLoading, false);
      expect(viewModel.hasError, true);
      expect(viewModel.errorMessage, 'Failed to fetch tasks');
      expect(viewModel.tasks.length, 0);

      verify(() => mockTaskRepository.fetchTasks()).called(1);
    });
  });
}
