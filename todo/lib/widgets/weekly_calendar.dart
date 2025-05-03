import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
