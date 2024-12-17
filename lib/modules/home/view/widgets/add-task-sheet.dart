import 'package:flutter/material.dart';
import '../../../../local/local_data_source.dart';
import '../../model/task-item.dart';
import '../../viewModel/view-model.dart';

class AddTaskSheet extends StatefulWidget {
  final TaskViewModel taskViewModel;

  AddTaskSheet({required this.taskViewModel});

  @override
  _AddTaskSheetState createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _statusController = TextEditingController(text: '0');
  final TextEditingController _dueDateController = TextEditingController();
  int _selectedPriority = 3;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Task',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _statusController,
              decoration: InputDecoration(
                labelText: 'Status (0: Pending, 1: Completed)',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 12),
            TextField(
              controller: _dueDateController,
              decoration: InputDecoration(
                labelText: 'Due Date (timestamp)',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 12),
            DropdownButtonFormField<int>(
              value: _selectedPriority,
              decoration: InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
              items: [
                DropdownMenuItem(value: 1, child: Text('P1 (Critical)')),
                DropdownMenuItem(value: 2, child: Text('P2 (High)')),
                DropdownMenuItem(value: 3, child: Text('P3 (Medium)')),
                DropdownMenuItem(value: 4, child: Text('P4 (Low)')),
                DropdownMenuItem(value: 5, child: Text('P5 (Lowest)')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedPriority = value;
                  });
                }
              },
            ),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final title = _titleController.text.trim();
                  if (title.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Title cannot be empty')),
                    );
                    return;
                  }

                  final task = TaskItem(
                    id: DateTime.now().toIso8601String(),
                    title: title,
                    description: _descriptionController.text.trim(),
                    priority: _selectedPriority,
                    status: int.parse(_statusController.text.trim()),
                    dueDate: _dueDateController.text.isNotEmpty
                        ? int.tryParse(_dueDateController.text.trim())
                        : null,
                  );

                  await LocalDataSource().createTask(task);
                  await widget.taskViewModel.fetchTasks();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Add Task'),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}