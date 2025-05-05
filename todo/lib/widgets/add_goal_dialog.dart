import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class AddGoalDialog extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  AddGoalDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('새 Goal 추가'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: InputDecoration(hintText: '예: Health, Study, Personal'),
        onSubmitted: (_) => _submit(context),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('취소'),
        ),
        ElevatedButton(onPressed: () => _submit(context), child: Text('추가')),
      ],
    );
  }

  void _submit(BuildContext context) {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      final provider = Provider.of<TaskProvider>(context, listen: false);
      provider.addGoal(text);
      provider.selectGoal(text);
      Navigator.pop(context);
    }
  }
}
