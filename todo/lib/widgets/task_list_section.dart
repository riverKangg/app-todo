import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import 'task_item.dart';

class TaskListSection extends StatelessWidget {
  const TaskListSection({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks = taskProvider.taskForSelectedDate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(child: Text('🎯', style: TextStyle(fontSize: 23))),
        const SizedBox(height: 12),
        ...tasks.asMap().entries.map(
          (entry) => TaskItem(
            title: entry.value.title,
            isDone: entry.value.isDone,
            onChanged: (_) => taskProvider.toggleTaskCompletion(entry.value),
            date: entry.value.date,
            onDelete: () => taskProvider.deleteTask(entry.value),
          ),
        ),
      ],
    );
  }
}
