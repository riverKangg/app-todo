import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/task.dart';
import 'package:intl/intl.dart';

import 'widgets/weekly_calendar.dart';
import 'widgets/user_info.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<Task>('tasks');
  runApp(DailyFocusApp());
}

class DailyFocusApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Focus',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'NanumSquare',
      ),
      home: DailyFocusPage(),
    );
  }
}

class DailyFocusPage extends StatefulWidget {
  @override
  _DailyFocusPageState createState() => _DailyFocusPageState();
}

class _DailyFocusPageState extends State<DailyFocusPage> {
  final TextEditingController _taskController = TextEditingController();
  final Box<Task> taskBox = Hive.box<Task>('tasks');

  void _addNewTask(String title, DateTime selectedDate) {
    if (title.trim().isEmpty) return;

    final newTask = Task(title: title, isDone: false, date: selectedDate);

    taskBox.add(newTask);
    _taskController.clear();

    setState(() {});
  }

  void _toggleTaskCompletion(int index) {
    final task = taskBox.getAt(index);
    if (task != null) {
      task.isDone = !task.isDone;
      task.save();
      setState(() {});
    }
  }

  DateTime _selectedDate = DateTime.now();

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('New Task'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _taskController,
                  autofocus: true,
                  decoration: InputDecoration(hintText: 'Enter task title'),
                  onSubmitted: (value) {
                    _addNewTask(value);
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      DateFormat('yyyy-MM-dd').format(_selectedDate),
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() {
                            _selectedDate = picked;
                            _loadTaskForDate(_selectedDate);
                          });
                        }
                      },
                      child: Text("날짜 선택"),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _taskController.clear();
                  _selectedDate = DateTime.now();
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  _addNewTask(_taskController.text, _selectedDate);
                  Navigator.pop(context);
                },
                child: Text('Add'),
              ),
            ],
          ),
    );
  }

  // Task의 날짜로 필터링
  void _loadTaskForDate(DateTime date) {
    final taskBox = Hive.box<Task>('tasks');

    //선택된 날짜와 일치하는 task만 필터링
    final filteredTasks =
        taskBox.values
            .where(
              (task) =>
                  task.date.year == date.year &&
                  task.date.month == date.month &&
                  task.date.day == date.day,
            )
            .toList();

    setState(() {
      workTasks = filteredTasks; // 필터링된 작업 리스트로 갱신
    });
  }

  List<Task> _getTodayTasks() {
    final today = DateTime.now();
    return taskBox.values
        .where((task) => DateUtils.isSameDay(task.date, today))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final todayTasks = _getTodayTasks();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leadingWidth: 10,
        leading: IconButton(icon: Icon(Icons.menu), onPressed: () {}),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            const SizedBox(height: 10),
            UserInfo(),
            const SizedBox(height: 15),
            WeeklyCalendar(),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tasks',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _showAddTaskDialog,
                  child: Text('+ Add Goal'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Work',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            ...todayTasks.asMap().entries.map(
              (entry) => TaskItem(
                title: entry.value.title,
                isDone: entry.value.isDone,
                onChanged: (_) => _toggleTaskCompletion(entry.key),
                date: entry.value.date,
              ),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: _showAddTaskDialog,
              icon: Icon(Icons.add),
              label: Text('Add task'),
            ),
          ],
        ),
      ),
    );
  }
}

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
