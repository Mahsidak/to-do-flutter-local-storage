import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model/task-item.dart';
import '../../viewModel/view-model.dart';

Widget taskCardWidget(BuildContext context, TaskItem task) {
  final TaskViewModel taskViewModel = TaskViewModel();
  Color backgroundColor;
  switch (task.priority) {
    case 1:
      backgroundColor = Colors.red[200]!;
      break;
    case 2:
      backgroundColor = Colors.green[200]!;
      break;
    case 3:
      backgroundColor = Colors.blue[200]!;
      break;
    default:
      backgroundColor = Colors.grey[100]!;
  }

  return Dismissible(
    key: Key(task.id),
    direction: DismissDirection.endToStart,
    onDismissed: (direction) async {
      await taskViewModel.deleteTask(task.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task deleted')),
      );
    },
    background: Container(
      color: Colors.red,
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Icon(Icons.delete, color: Colors.white),
      ),
    ),
    child: Card(
      margin: EdgeInsets.all(8.0),
      color: backgroundColor,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(12.0),
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          task.description ?? 'No description provided',
          style: TextStyle(color: Colors.black54),
        ),
      ),
    ),
  );
}