// lib/widgets/task_input_field.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class TaskInputField extends StatefulWidget {
  final String goal;
  const TaskInputField({super.key, required this.goal});

  @override
  State<TaskInputField> createState() => _TaskInputFieldState();
}

class _TaskInputFieldState extends State<TaskInputField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    return ListTile(
      contentPadding: const EdgeInsets.only(left: 16, right: 8),
      leading: Checkbox(value: false, onChanged: null),
      title: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: '할 일을 입력하세요...',
          hintStyle: TextStyle(color: Colors.grey[500]),
          border: InputBorder.none,
          isDense: true,
        ),
        style: const TextStyle(fontSize: 16),
        onSubmitted: (text) {
          final trimmed = text.trim();
          if (trimmed.isNotEmpty) {
            taskProvider.addTask(trimmed, widget.goal);
            _controller.clear();
          }
        },
      ),
      trailing: OutlinedButton(
        onPressed: () {
          final text = _controller.text.trim();
          if (text.isNotEmpty) {
            taskProvider.addTask(text, widget.goal);
            _controller.clear();
          }
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey[400]!),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
        child: const Text(
          '추가',
          style: TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ),
    );
  }
}
