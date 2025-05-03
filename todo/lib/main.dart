import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/task.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

class Task {
  String title;
  bool isDone;

  Task({required this.title, this.isDone = false});
}

class DailyFocusPage extends StatefulWidget {
  @override
  _DailyFocusPageState createState() => _DailyFocusPageState();
}

class _DailyFocusPageState extends State<DailyFocusPage> {
  List<Task> workTasks = [
    Task(title: 'Complete project proposal'),
    Task(title: 'Meeting with team', isDone: true),
  ];

  final TextEditingController _taskController = TextEditingController();

  void _addNewTask(String title) {
    if (title.trim().isEmpty) return;
    setState(() {
      workTasks.insert(0, Task(title: title));
      _taskController.clear();
    });
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('New Task'),
            content: TextField(
              controller: _taskController,
              autofocus: true,
              decoration: InputDecoration(hintText: 'Enter task title'),
              onSubmitted: (value) {
                _addNewTask(value);
                Navigator.pop(context);
              },
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _taskController.clear();
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  _addNewTask(_taskController.text);
                  Navigator.pop(context);
                },
                child: Text('Add'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            Row(
              children: [
                const SizedBox(width: 10),
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage("assets/kingbob.webp"),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "지선",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "앱으로 자유찾기",
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
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
            ...workTasks.map(
              (task) => TaskItem(
                title: task.title,
                isDone: task.isDone,
                onChanged: (val) {
                  setState(() {
                    task.isDone = val!;
                  });
                },
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
  final Function(bool?)? onChanged;

  const TaskItem({required this.title, required this.isDone, this.onChanged});

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
            child: Text(
              title,
              style: TextStyle(
                decoration:
                    isDone ? TextDecoration.lineThrough : TextDecoration.none,
                color: isDone ? Colors.grey : Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WeeklyCalendar extends StatefulWidget {
  WeeklyCalendar({super.key});

  @override
  State<WeeklyCalendar> createState() => _WeeklyCalendarState();
}

class _WeeklyCalendarState extends State<WeeklyCalendar> {
  late DateTime _startOfWeek;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    _startOfWeek = today.subtract(Duration(days: today.weekday % 7));
  }

  List<DateTime> getWeekDates(DateTime startDate) {
    return List.generate(7, (index) => startDate.add(Duration(days: index)));
  }

  void _goToPreviousWeek() {
    setState(() {
      _startOfWeek = _startOfWeek.subtract(Duration(days: 7));
    });
  }

  void _goToNextWeek() {
    setState(() {
      _startOfWeek = _startOfWeek.add(Duration(days: 7));
    });
  }

  // 주차 계산 함수
  String getSmartMonthLabel(DateTime startOfWeek) {
    final today = DateTime.now();
    final weekDates = List.generate(
      7,
      (i) => startOfWeek.add(Duration(days: i)),
    );

    final isTodayInWeek = weekDates.any(
      (date) =>
          date.year == today.year &&
          date.month == today.month &&
          date.day == today.day,
    );

    if (isTodayInWeek) {
      return '${today.year}년 ${today.month}월';
    }

    // 과반수 월 계산
    final Map<int, int> monthCounts = {};
    for (var date in weekDates) {
      monthCounts.update(date.month, (count) => count + 1, ifAbsent: () => 1);
    }
    final dominantMonth =
        monthCounts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
    final year = weekDates.firstWhere((d) => d.month == dominantMonth).year;

    return '$year년 ${dominantMonth}월';
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final weekDates = getWeekDates(_startOfWeek);

    return Column(
      mainAxisSize: MainAxisSize.min,

      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              getSmartMonthLabel(_startOfWeek),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            ElevatedButton.icon(
              onPressed: _goToPreviousWeek,
              icon: const Icon(Icons.arrow_back_ios),
              label: Text(""),
            ),

            ElevatedButton.icon(
              onPressed: _goToNextWeek,
              icon: const Icon(Icons.arrow_forward_ios),
              label: Text(""),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:
              weekDates.map((date) {
                final isToday = DateUtils.isSameDay(date, today);

                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isToday ? Colors.grey[200] : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        DateFormat.E().format(date), // 요일
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isToday ? Colors.deepPurple : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        date.day.toString(), // 날짜
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isToday ? Colors.deepPurple : Colors.black,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
        ),
        const SizedBox(height: 16),

        // 이전 주, 다음 주 버튼
      ],
    );
  }
}
