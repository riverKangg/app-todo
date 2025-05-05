// lib/widgets/goal_section.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import 'task_input_field.dart';

class GoalSection extends StatelessWidget {
  final String goal;

  const GoalSection({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks = taskProvider.getTaskByGoal(goal);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.deepPurple[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            goal,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        ...tasks.map(
          (task) => ListTile(
            leading: Checkbox(
              value: task.isDone,
              onChanged: (value) => taskProvider.toggleTaskCompletion(task),
            ),
            title: Text(
              task.title,
              style: TextStyle(
                decoration:
                    task.isDone
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
              ),
            ),
            trailing: IconButton(
              onPressed: () => taskProvider.deleteTask(task),
              icon: const Icon(Icons.delete),
            ),
          ),
        ),
        TaskInputField(goal: goal),
        const Divider(thickness: 1, height: 32),
      ],
    );
  }
}
