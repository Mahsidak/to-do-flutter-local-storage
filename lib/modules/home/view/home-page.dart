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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do App'),
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