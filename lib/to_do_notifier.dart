import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'task_model.dart';

part 'to_do_notifier.g.dart';

@riverpod
class ToDoNotifier extends _$ToDoNotifier {
  @override
  List<TaskModel> build() => [];

  void add(TaskModel task) {
    state = [...state, task];
  }

  void delete(String taskId) {
    state = state.where((e) => e.id != taskId).toList();
  }

  void update(String taskId, TaskModel updatedTask) {
    final taskIndex = state.indexWhere((task) => task.id == taskId);
    if (taskIndex != -1) {
      state = [
        ...state.sublist(0, taskIndex),
        updatedTask,
        ...state.sublist(taskIndex + 1),
      ];
    }
    print("updated");
    print(updatedTask.isCompelted);
  }
}
