import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/todo.dart';

class AddEditTodoScreen extends StatefulWidget {
  const AddEditTodoScreen({super.key});

  @override
  State<AddEditTodoScreen> createState() => _AddEditTodoScreenState();
}

class _AddEditTodoScreenState extends State<AddEditTodoScreen> {
  final TextEditingController _titleController = TextEditingController();
  DateTime? _selectedDate;

  void _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveTodo() {
  final title = _titleController.text.trim();
  if (title.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("제목을 입력하세요")),
    );
    return;
  }

  final newTodo = Todo.create(title, dueDate: _selectedDate);
  Navigator.pop(context, newTodo);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('할 일 추가'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: '제목',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedDate == null
                        ? '마감일 없음'
                        : '마감일: ${DateFormat.yMMMd().format(_selectedDate!)}',
                  ),
                ),
                TextButton(
                  onPressed: _pickDate,
                  child: const Text('날짜 선택'),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: _saveTodo,
              icon: const Icon(Icons.save),
              label: const Text('저장하기'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


