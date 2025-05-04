import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/providers/task_provider.dart';

class WeeklyCalendar extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const WeeklyCalendar({
    Key? key,
    required this.selectedDate,
    required this.onDateSelected,
  }) : super(key: key);

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

  String getSmartMonthLabel(DateTime startOfWeek) {
    final today = DateTime.now();
    final weekDates = getWeekDates(startOfWeek);

    final isTodayInWeek = weekDates.any(
      (date) =>
          date.year == today.year &&
          date.month == today.month &&
          date.day == today.day,
    );

    if (isTodayInWeek) {
      return '${today.year}년 ${today.month}월';
    }

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
    final provider = Provider.of<TaskProvider>(context);
    final selectedDate = provider.selectedDate;
    final weekDates = getWeekDates(_startOfWeek);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              getSmartMonthLabel(_startOfWeek),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ElevatedButton.icon(
              onPressed: _goToPreviousWeek,
              icon: const Icon(Icons.arrow_back_ios),
              label: const Text(""),
            ),
            ElevatedButton.icon(
              onPressed: _goToNextWeek,
              icon: const Icon(Icons.arrow_forward_ios),
              label: const Text(""),
            ),
            ElevatedButton.icon(
              onPressed: () {
                final today = DateTime.now();
                setState(() {
                  _startOfWeek = today.subtract(
                    Duration(days: today.weekday % 7),
                  );
                });
                provider.updateSelectedDate(today);
              },
              icon: Icon(Icons.today),
              label: const Text("Today"),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:
              weekDates.map((date) {
                final isSelected = DateUtils.isSameDay(date, selectedDate);

                return ElevatedButton(
                  onPressed: () {
                    provider.updateSelectedDate(date);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isSelected ? Colors.deepPurple : Colors.white,
                    foregroundColor: isSelected ? Colors.white : Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 12,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        DateFormat.E().format(date),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        date.day.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
