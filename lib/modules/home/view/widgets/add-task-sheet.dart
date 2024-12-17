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
  DateTime? _dueDate;
  int _selectedPriority = 3;

  // Function to show the date picker
  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

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
            GestureDetector(
              onTap: () => _selectDueDate(context),  // Open the date picker
              child: AbsorbPointer(
                child: TextField(
                  controller: TextEditingController(
                    text: _dueDate != null ? _dueDate!.toLocal().toString().split(' ')[0] : '',
                  ),
                  decoration: InputDecoration(
                    labelText: 'Due Date',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                ),
              ),
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
                DropdownMenuItem(value: 1, child: Text('High')),
                DropdownMenuItem(value: 2, child: Text('Medium')),
                DropdownMenuItem(value: 3, child: Text('Low')),
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
                    dueDate: _dueDate?.millisecondsSinceEpoch,
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