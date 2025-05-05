// lib/screens/daily_focus_page.dart
import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/user_info.dart';
import '../widgets/weekly_calendar.dart';
import '../widgets/goal_input_section.dart';
import '../widgets/goal_section.dart';

class DailyFocusPage extends StatelessWidget {
  const DailyFocusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

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
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 10),
            UserInfo(),
            const SizedBox(height: 15),
            WeeklyCalendar(
              selectedDate: taskProvider.selectedDate,
              onDateSelected: (date) => taskProvider.updateSelectedDate(date),
            ),
            // const SizedBox(height: 20),

            // Text(
            //   '${DateFormat('M월 d일').format(taskProvider.selectedDate)} Task 통계',
            //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            // ),
            // ...goalStats.entries.map((entry) {
            //   final goal = entry.key;
            //   final (total, done) = entry.value;
            //   return Text(' $goal:$done / $total 완료');
            // }),
            const SizedBox(height: 40),

            ...taskProvider.goals.map((goal) => GoalSection(goal: goal)),
            const SizedBox(height: 20),
            GoalInputSection(),

          ],
        ),
      ),
    );
  }
}
