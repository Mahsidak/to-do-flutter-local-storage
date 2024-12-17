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