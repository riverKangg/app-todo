// ChangeNotifier를 활용하여 상태 관리
// lib/providers/task_provider.dart
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  final Box<Task> taskBox = Hive.box<Task>('tasks');
  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  List<Task> get taskForSelectedDate =>
      taskBox.values
          .where((task) => isSameDay(task.date, _selectedDate))
          .toList();

  void addTask(String title) {
    if (title.trim().isEmpty) return;
    final newTask = Task(title: title, isDone: false, date: _selectedDate);
    taskBox.add(newTask);
    notifyListeners();
  }

  void toggleTaskCompletion(int index) {
    final task = taskBox.getAt(index);
    if (task != null) {
      task.isDone = !task.isDone;
      task.save();
      notifyListeners();
    }
  }

  void updateSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
