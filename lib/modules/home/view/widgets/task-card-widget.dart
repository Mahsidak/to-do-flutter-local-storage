import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model/task-item.dart';

Widget taskCardWidget(TaskItem task) {
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

  return Card(
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
        task.description,
        style: TextStyle(color: Colors.black54),
      ),
    ),
  );
}