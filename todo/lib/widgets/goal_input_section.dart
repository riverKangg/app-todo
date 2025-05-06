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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16, bottom: 4),
          child: Text(
            '🎯 새 목표 추가',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        ListTile(
          contentPadding: const EdgeInsets.only(left: 16, right: 8),
          title: TextField(
            controller: _goalController,
            decoration: InputDecoration(
              hintText: '목표를 입력하세요...',
              hintStyle: TextStyle(color: Colors.grey[500]),
              border: InputBorder.none,
              isDense: true,
            ),
            style: const TextStyle(fontSize: 16),
            onSubmitted: (text) {
              final goal = text.trim();
              if (goal.isNotEmpty) {
                taskProvider.addGoal(goal);
                _goalController.clear();
              }
            },
          ),
          trailing: OutlinedButton(
            onPressed: () {
              final goal = _goalController.text.trim();
              if (goal.isNotEmpty) {
                taskProvider.addGoal(goal);
                _goalController.clear();
              }
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey[400]!),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            child: const Text(
              '추가',
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ),
        const Divider(thickness: 1),
      ],
    );
  }
}
