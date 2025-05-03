import 'package:flutter/material.dart';

void main() => runApp(DailyFocusApp());

class DailyFocusApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Focus',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Arial',
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
  bool meetingCompleted = true;
  bool projectCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            const SizedBox(height: 40),
            Text(
              'Daily Focus',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Organize your tasks by goals',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            CalendarSection(),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tasks for May 3',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {},
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
            TaskItem(
              title: 'Complete project proposal',
              isDone: projectCompleted,
              onChanged: (val) {
                setState(() {
                  projectCompleted = val!;
                });
              },
            ),
            TaskItem(
              title: 'Meeting with team',
              isDone: meetingCompleted,
              onChanged: (val) {
                setState(() {
                  meetingCompleted = val!;
                });
              },
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () {},
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

  const TaskItem({
    required this.title,
    required this.isDone,
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

class CalendarSection extends StatelessWidget {
  final List<String> week = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final List<int> days = [28, 29, 30, 1, 2, 3, 4];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(7, (index) {
          bool isToday = days[index] == 3; // current day
          return Column(
            children: [
              Text(
                week[index],
                style: TextStyle(
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isToday ? Colors.deepPurple[300] : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${days[index]}',
                  style: TextStyle(
                    color: isToday ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
