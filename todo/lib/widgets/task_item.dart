import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskItem extends StatelessWidget {
  final String title;
  final bool isDone;
  final DateTime date;
  final Function(bool?)? onChanged;
  final VoidCallback onDelete;

  const TaskItem({
    super.key,
    required this.title,
    required this.isDone,
    required this.date,
    this.onChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDone ? Colors.grey : Colors.black;
    final decoration = isDone ? TextDecoration.lineThrough : TextDecoration.none;
    final bgColor = isDone ? Colors.deepPurple[100] : Colors.white;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Checkbox(
            value: isDone,
            onChanged: onChanged,
            activeColor: Colors.deepPurple,
          ),
          Expanded(
            child: _TaskContent(
              title: title,
              date: date,
              textColor: textColor,
              decoration: decoration,
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}

class _TaskContent extends StatelessWidget {
  final String title;
  final DateTime date;
  final Color textColor;
  final TextDecoration decoration;

  const _TaskContent({
    required this.title,
    required this.date,
    required this.textColor,
    required this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: textColor,
            decoration: decoration,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          DateFormat('yyyy-MM-dd').format(date),
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}