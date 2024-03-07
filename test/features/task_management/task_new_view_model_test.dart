import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mvvm/common/models/task.dart';
import 'package:mvvm/features/task_management/task_management_repository.dart';
import 'package:mvvm/features/task_management/task_new/task_new_view_model.dart';

class MockTaskRepository extends Mock implements ITaskRepository {}

void main() {
  late ITaskRepository mockTaskRepository;
  late TaskNewViewModel viewModel;
  setUpAll(() {
    mockTaskRepository = MockTaskRepository();
    viewModel = TaskNewViewModel(mockTaskRepository);
    registerFallbackValue(Task(
      title: 'Task 1',
      description: 'Task 1',
      isCompleted: false,
      dueDate: DateTime.now(),
    ));
  });
  group('TaskNewViewModel', () {
    test('createTask: success', () async {
      //arrange
      final dueDate = DateTime.now();

      var newTask = Task(
        title: 'Task 1',
        description: 'Task 1',
        isCompleted: false,
        dueDate: dueDate,
      );

      when(() => mockTaskRepository.createTask(any())).thenAnswer((_) async => any());

      viewModel.dueDate = dueDate;
      viewModel.description = 'Task 1';
      viewModel.title = 'Task 1';

      //act
      await viewModel.createTask();

      //assert
      expect(viewModel.dueDate, dueDate);
      expect(viewModel.description, 'Task 1');
      expect(viewModel.title, 'Task 1');
      verify(() => mockTaskRepository.createTask(newTask)).called(1);
    });

    test('createTask: failure', () async {
      final mockTaskRepository = MockTaskRepository();
      final viewModel = TaskNewViewModel(mockTaskRepository);

      var newTask = Task(title: 'Task 1', description: 'Task 1', isCompleted: false, dueDate: DateTime.now());

      // Simulate a failed fetchTasks call
      when(() => mockTaskRepository.createTask(newTask)).thenThrow(Exception());

      await viewModel.createTask();
      expect(viewModel.hasError, true);
      expect(viewModel.errorMessage, 'Failed to create task');
    });
  });
}
