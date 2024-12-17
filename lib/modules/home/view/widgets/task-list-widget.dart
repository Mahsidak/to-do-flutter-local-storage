import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do/modules/home/view/widgets/task-card-widget.dart';

import '../../model/task-item.dart';
import '../../viewModel/view-model.dart';

Widget taskListWidget(TaskViewModel taskViewModel) {
  return ValueListenableBuilder<List<TaskItem>>(
    valueListenable: taskViewModel.tasksNotifier,
    builder: (context, tasks, _) {
      if (tasks.isEmpty) {
        return Center(
          child: Text(
            'No tasks found. Add your first task!',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      }

      return ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return taskCardWidget(tasks[index]);
        },
      );
    },
  );
}