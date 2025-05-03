import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/todo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Box<Todo> _todoBox = Hive.box<Todo>('todos');
  final TextEditingController _controller = TextEditingController();

  void _addTodo() {
    if (_controller.text.isNotEmpty) {
      final newTodo = Todo.create(_controller.text);
      setState(() {
        _todoBox.add(newTodo);
      });
      _controller.clear(); // 추가 후 입력창 초기화
    }
  }

  void _toggleTodoStatus(Todo todo, int index) {
    setState(() {
      todo.isDone = !todo.isDone;
      _todoBox.putAt(index, todo);
    });
  }

  void _deleteTodo(int index) {
    setState(() {
      _todoBox.deleteAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('나의 할 일들'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 할 일 추가 입력창
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: '할 일 입력',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.add),
              ),
            ),
          ),
          // 추가 버튼
          ElevatedButton(
            onPressed: _addTodo,
            child: const Text('할 일 추가'),
          ),
          
          // 할 일 목록
          Expanded(
            child: _todoBox.isEmpty
                ? const Center(child: Text('할 일이 없습니다 📝'))
                : ListView.builder(
                    itemCount: _todoBox.length,
                    itemBuilder: (context, index) {
                      final todo = _todoBox.getAt(index);
                      return Dismissible(
                        key: ValueKey(todo?.id),
                        onDismissed: (direction) {
                          _deleteTodo(index);
                        },
                        background: Container(color: Colors.red),
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: todo?.isDone ?? false ? Colors.grey[300] : Colors.white,
                          child: ListTile(
                            leading: Checkbox(
                              value: todo?.isDone,
                              onChanged: (val) {
                                _toggleTodoStatus(todo!, index);
                              },
                            ),
                            title: Text(
                              todo?.title ?? '',
                              style: TextStyle(
                                decoration: todo?.isDone ?? false
                                    ? TextDecoration.lineThrough
                                    : null,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: todo?.dueDate != null
                                ? Text(
                                    '마감일: ${todo?.dueDate!.toLocal().toString().split(' ')[0]}',
                                    style: const TextStyle(color: Colors.grey),
                                  )
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
