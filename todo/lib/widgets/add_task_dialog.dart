import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/providers/task_provider.dart';

class AddTaskDialog extends StatelessWidget {
  final String goal;
  final TextEditingController _taskController = TextEditingController();

  AddTaskDialog({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return AlertDialog(
      title: Text('New Task for "$goal"'),
      content: TextField(
        controller: _taskController,
        autofocus: true,
        decoration: InputDecoration(hintText: 'Enter task title'),
        onSubmitted: (value) {
          taskProvider.addTask(value, goal);
          Navigator.pop(context);
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            _taskController.clear();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            taskProvider.addTask(_taskController.text, goal);
            Navigator.pop(context);
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
