import 'package:flutter/cupertino.dart';

import '../../../local/local_data_source.dart';
import '../model/task-item.dart';

class TaskViewModel {
  ValueNotifier<List<TaskItem>> tasksNotifier = ValueNotifier<List<TaskItem>>([]);

  Future<void> fetchTasks() async {
    try {
      final fetchedTasks = await LocalDataSource().fetchAllTasks();
      tasksNotifier.value = fetchedTasks;
    } catch (e) {
      print('Error fetching tasks: $e');
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      final success = await LocalDataSource().deleteTask(taskId);
      if (success) {
        await fetchTasks();  // Refresh the tasks list after deleting a task
        print('Task with ID $taskId deleted');
      } else {
        print('Failed to delete task with ID $taskId');
      }
    } catch (e) {
      print('Error deleting task with ID $taskId: $e');
    }
  }

  Future<void> deleteAllTasks() async {
    try {
      await LocalDataSource().deleteAllTasks();
      await fetchTasks();
      print('All tasks have been deleted');
    } catch (e) {
      print('Error deleting all tasks: $e');
    }
  }
}