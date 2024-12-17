import 'package:flutter/material.dart';
import 'package:to_do/modules/home/view/widgets/add-task-sheet.dart';
import 'package:to_do/modules/home/view/widgets/task-card-widget.dart';
import '../model/task-item.dart';
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
            onPressed: _showDeleteConfirmationDialog,
            tooltip: 'Delete All Tasks',
          ),
        ],
      ),
      body: ValueListenableBuilder<List<TaskItem>>(
        valueListenable: taskViewModel.tasksNotifier,
        builder: (context, tasks, _) {
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
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
                child: taskCardWidget(context, task),
              );
            },
          );
        },
      ),
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