import 'package:flutter/material.dart';
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
}
