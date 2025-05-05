// lib/screens/daily_focus_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/user_info.dart';
import '../widgets/weekly_calendar.dart';
import '../widgets/task_list_section.dart';
import '../widgets/add_task_dialog.dart';
import '../widgets/add_goal_dialog.dart';

class DailyFocusPage extends StatelessWidget {
  // final DateTime selectedDate;
  // const DailyFocusPage({super.key, required this.selectedDate});

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
            const SizedBox(height: 40),
            // Goal 별 Task 관리
            ...taskProvider.goals.map((goal) {
              final tasks = taskProvider.getTaskByGoal(goal);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      goal,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  //goal에 속한 task 리스트
                  ...tasks.map(
                    (task) => ListTile(
                      title: Text(task.title),
                      trailing: Checkbox(
                        value: task.isDone,
                        onChanged:
                            (value) => taskProvider.toggleTaskCompletion(task),
                      ),
                    ),
                  ),

                  // task 추가 버튼
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed:
                          () => showDialog(
                            context: context,
                            builder: (context) => AddTaskDialog(goal: goal),
                          ),
                      icon: Icon(Icons.add),
                      label: Text('Add task to "$goal"'),
                    ),
                  ),
                  const Divider(thickness: 1, height: 32),
                ],
              );
            }),

            // Goal 추가 버튼
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed:
                    () => showDialog(
                      context: context,
                      builder: (context) => AddGoalDialog(),
                    ),
                child: Text('+Add Goal'),
              ),
            ),
            const SizedBox(height: 20),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       'Tasks',
            //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            //     ),
            //     DropdownButton<String>(
            //       value: taskProvider.selectedGoal,
            //       items:
            //           taskProvider.goals
            //               .map(
            //                 (g) => DropdownMenuItem(child: Text(g), value: g),
            //               )
            //               .toList(),
            //       onChanged: (val) {
            //         if (val != null) taskProvider.selectGoal(val);
            //       },
            //     ),
            //     ElevatedButton(
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: Colors.deepPurple[300],
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(12),
            //         ),
            //       ),
            //       onPressed:
            //           () => showDialog(
            //             context: context,
            //             builder: (context) => AddGoalDialog(),
            //           ),
            //       child: Text('+ Add Goal'),
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 24),
            // TaskListSection(),
            // const SizedBox(height: 8),
            // TextButton.icon(
            //   onPressed:
            //       () => showDialog(
            //         context: context,
            //         builder: (context) => AddTaskDialog(),
            //       ),
            //   icon: Icon(Icons.add),
            //   label: Text('Add task'),
            // ),
          ],
        ),
      ),
    );
  }
}
