import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testing/to_do_notifier.dart';

import 'task_model.dart';

class ToDoList extends ConsumerStatefulWidget {
  const ToDoList({super.key});

  @override
  ConsumerState<ToDoList> createState() => _ToDoList();
}

class _ToDoList extends ConsumerState<ToDoList> {
  List<TaskModel> tasksList = [];
  // SharedPreferences? sharedPreferences;

  bool showCompletedTasks = false;

  final TextEditingController taskTextEditingController =
      TextEditingController();

  @override
  void initState() {
    // initPrefs();
    super.initState();
  }

  // void initPrefs() async {
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   readTasks();
  // }

  void saveOnLocalStorage() {
    final taskData = tasksList.map((task) => task.toJson()).toList();
    // sharedPreferences?.setStringList('tasks', taskData);
  }

  @override
  Widget build(BuildContext context) {
    final task = ref.watch(toDoNotifierProvider);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 80),
          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              "TO DO List",
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12)),
                  color: Colors.white),
              child: task.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(0),
                      itemCount: task.length,
                      itemBuilder: (context, index) {
                        // final TaskModel task = tasksList[index];
                        if (showCompletedTasks && !task[index].isCompelted) {
                          return Container();
                        }
                        return Card(
                          color: Colors.white.withOpacity(0.7),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            leading: Checkbox(
                              value: task[index].isCompelted,
                              onChanged: (isChecked) {
                                final updatedTask = TaskModel(
                                  id: task[index].id,
                                  title: task[index].title,
                                  isCompelted: !task[index].isCompelted,
                                );
                                ref
                                    .read(toDoNotifierProvider.notifier)
                                    .update(task[index].id, updatedTask);
                              },
                            ),
                            title: Text(
                              task[index].title,
                              style: TextStyle(
                                fontSize: 18,
                                decoration: task[index].isCompelted
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                ref
                                    .read(toDoNotifierProvider.notifier)
                                    .delete(task[index].id);
                              },
                            ),
                            onTap: () {
                              showUpdateDialog(task[index]);
                            },
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        'No tasks registered, tap the button with the + symbol',
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ),

              // )
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          print("ressss");
        },
        child: const Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }

  void showUpdateDialog(TaskModel task) {
    final TextEditingController updateTextController =
        TextEditingController(text: task.title);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Update Task'),
            content: TextField(
              controller: updateTextController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                labelText: 'Update Task...',
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    if (updateTextController.text.isNotEmpty) {
                      final updatedTask = TaskModel(
                        id: task.id,
                        title: updateTextController.text,
                        isCompelted: task.isCompelted,
                      );
                      Navigator.of(context).pop();
                      ref
                          .read(toDoNotifierProvider.notifier)
                          .update(task.id, updatedTask);
                    }
                  },
                  child: const Text('Update'))
            ],
          );
        });
  }

  void showDialogButton() {
    print("pressed");
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('New Task'),
            content: TextField(
              controller: taskTextEditingController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                labelText: 'Create Task...',
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    if (taskTextEditingController.text.isNotEmpty) {
                      final TaskModel newTask = TaskModel(
                          id: DateTime.now().toString(),
                          title: taskTextEditingController.text,
                          isCompelted: false);
                      ref.read(toDoNotifierProvider.notifier).add(newTask);
                      taskTextEditingController.clear();
                      //close the dialog
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Save'))
            ],
          );
        });
  }

  // void updateTask({required String taskId, required TaskModel updatedTask}) {
  //   final taskIndex = tasksList.indexWhere((task) => task.id == taskId);
  //   if (taskIndex != -1) {
  //     setState(() {
  //       tasksList[taskIndex] = updatedTask;
  //       saveOnLocalStorage();
  //     });
  //   }
  // }

  // void deleteTask({required String taskId}) {
  //   setState(() {
  //     tasksList.removeWhere((task) => task.id == taskId);
  //     saveOnLocalStorage();
  //   });
  // }
  //
  // void readTasks() {
  //   setState(() {
  //     final taskData = sharedPreferences?.getStringList('tasks') ?? [];
  //
  //     tasksList =
  //         taskData.map((taskJason) => TaskModel.fromJson(taskJason)).toList();
  //   });
  // }

  List<TaskModel> get displayedTasks {
    if (showCompletedTasks) {
      return tasksList.where((task) => task.isCompelted).toList();
    } else {
      return tasksList;
    }
  }
}
