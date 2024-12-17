import 'package:flutter/material.dart';
import 'package:to_do/modules/home/view/widgets/add-task-sheet.dart';
import 'package:to_do/modules/home/view/widgets/task-list-widget.dart';
import '../viewModel/view-model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TaskViewModel taskViewModel = TaskViewModel();

  @override
  void initState() {
    super.initState();
    taskViewModel.fetchTasks();
  }

  // Show a confirmation dialog before deleting all tasks
  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete All Tasks'),
          content: Text('Are you sure you want to delete all tasks? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await taskViewModel.deleteAllTasks();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do App'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: _showDeleteConfirmationDialog, // Show confirmation dialog
            tooltip: 'Delete All Tasks',
          ),
        ],
      ),
      body: taskListWidget(taskViewModel),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) {
              return AddTaskSheet(taskViewModel: taskViewModel);
            },
          );
        },
        tooltip: 'Add To-Do',
        child: Icon(Icons.add),
      ),
    );
  }
}