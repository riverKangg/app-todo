// lib/widgets/goal_input_section.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class GoalInputSection extends StatefulWidget {
  const GoalInputSection({super.key});

  @override
  State<GoalInputSection> createState() => _GoalInputSectionState();
}

class _GoalInputSectionState extends State<GoalInputSection> {
  final TextEditingController _goalController = TextEditingController();

  @override
  void dispose() {
    _goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    return Column(
      children: [
        const Text(
          '🎯 새 목표(Goal) 추가',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _goalController,
                decoration: const InputDecoration(
                  hintText: 'Enter a new goal...',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                final goal = _goalController.text.trim();
                if (goal.isNotEmpty) {
                  taskProvider.addGoal(goal);
                  _goalController.clear();
                }
              },
              child: const Text('추가'),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
