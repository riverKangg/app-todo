import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/providers/task_provider.dart';

class WeeklyCalendar extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const WeeklyCalendar({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<WeeklyCalendar> createState() => _WeeklyCalendarState();
}

class _WeeklyCalendarState extends State<WeeklyCalendar> {
  late DateTime _startOfWeek;

  @override
  void initState() {
    super.initState();
    _startOfWeek = _getStartOfWeek(widget.selectedDate);
  }

  DateTime _getStartOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday % 7));
  }

  List<DateTime> get _weekDates =>
      List.generate(7, (i) => _startOfWeek.add(Duration(days: i)));

  void _changeWeek(int offsetDays) {
    setState(() {
      _startOfWeek = _startOfWeek.add(Duration(days: offsetDays));
    });
  }

  void _goToToday(TaskProvider provider) {
    final today = DateTime.now();
    setState(() {
      _startOfWeek = _getStartOfWeek(today);
    });
    provider.updateSelectedDate(today);
  }

  String _getSmartMonthLabel() {
    final today = DateTime.now();
    final isTodayInWeek = _weekDates.any(
      (d) =>
          d.year == today.year && d.month == today.month && d.day == today.day,
    );

    if (isTodayInWeek) {
      return '${today.year}년 ${today.month}월';
    }

    final monthCounts = <int, int>{};
    for (final date in _weekDates) {
      monthCounts.update(date.month, (v) => v + 1, ifAbsent: () => 1);
    }

    final dominantMonth =
        monthCounts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
    final year = _weekDates.firstWhere((d) => d.month == dominantMonth).year;

    return '$year년 $dominantMonth월';
  }

  Widget _buildNavigationButtons(TaskProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          _getSmartMonthLabel(),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        ElevatedButton.icon(
          onPressed: () => _changeWeek(-7),
          icon: const Icon(Icons.arrow_back_ios),
          label: const SizedBox.shrink(),
        ),
        ElevatedButton.icon(
          onPressed: () => _changeWeek(7),
          icon: const Icon(Icons.arrow_forward_ios),
          label: const SizedBox.shrink(),
        ),
        ElevatedButton.icon(
          onPressed: () => _goToToday(provider),
          icon: const Icon(Icons.today),
          label: const Text("Today"),
        ),
      ],
    );
  }

  Widget _buildWeekDayButton(TaskProvider provider, DateTime date) {
    final isSelected = DateUtils.isSameDay(date, provider.selectedDate);
    final stats = provider.getTaskStatsForDate(date);
    final done = stats['done'] ?? 0;
    final total = stats['total'] ?? 0;

    return ElevatedButton(
      onPressed: () => provider.updateSelectedDate(date),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.deepPurple : Colors.white,
        foregroundColor: isSelected ? Colors.white : Colors.black,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
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
          const SizedBox(height: 4),
          Text(
            '✅$done/📌$total',
            style: TextStyle(
              fontSize: 10,
              color: isSelected ? Colors.white : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildNavigationButtons(provider),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:
              _weekDates.map((d) => _buildWeekDayButton(provider, d)).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
