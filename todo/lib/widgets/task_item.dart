import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskItem extends StatelessWidget {
  final String title;
  final bool isDone;
  final DateTime date;
  final Function(bool?)? onChanged;

  const TaskItem({
    required this.title,
    required this.isDone,
    required this.date,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDone ? Colors.deepPurple[100] : Colors.white,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    decoration:
                        isDone
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                    color: isDone ? Colors.grey : Colors.black,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  DateFormat('yyyy-MM-dd').format(date),
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
