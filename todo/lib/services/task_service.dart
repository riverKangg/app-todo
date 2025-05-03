import 'package:hive/hive.dart';
import '../models/task.dart';

class TaskService {
  final Box<Task> _taskBox = Hive.box<Task>('tasks');

  List<Task> getTasksForDate(DateTime date) {
    return _taskBox.values
        .where((task) => isSameDate(task.date, date))
        .toList();
  }

  Future<void> addTask(Task task) async {
    await _taskBox.add(task);
  }

  Future<void> toggleTask(Task task) async {
    task.isDone = !task.isDone;
    await task.save();
  }

  bool isSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
