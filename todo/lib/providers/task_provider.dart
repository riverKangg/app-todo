// ChangeNotifier를 활용하여 상태 관리
// lib/providers/task_provider.dart
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  final Box<Task> taskBox = Hive.box<Task>('tasks');
  final Box<String> goalBox = Hive.box<String>('goals');

  DateTime _selectedDate = DateTime.now();
  final Set<String> _goals = {};
  String _selectedGoal = 'Work';

  // Getters
  DateTime get selectedDate => _selectedDate;
  Set<String> get goals => _goals;
  String get selectedGoal => _selectedGoal;

  TaskProvider() {
    loadGoals();
  }

  // 현재 선택된 날짜 + 목표(goal)에 해당하는 Task 리스트
  List<Task> get taskForSelectedDate =>
      taskBox.values
          .where(
            (task) =>
                task.goal == _selectedGoal &&
                isSameDay(task.date, _selectedDate),
          )
          .toList();

  // 특정 목표의 Task 리스트(선택된 날짜 기준)
  List<Task> getTaskByGoal(String goal) {
    return taskBox.values
        .where(
          (task) => task.goal == goal && isSameDay(task.date, _selectedDate),
        )
        .toList();
  }

  // 날짜별 목표별 통계: 총 task 수/완료된 수
  Map<String, (int total, int done)> getGoalStatsByDate(DateTime date) {
    final Map<String, (int, int)> stats = {};
    for (var task in taskBox.values) {
      if (isSameDay(task.date, date)) {
        final key = task.goal;
        stats[key] = (
          (stats[key]?.$1 ?? 0) + 1,
          (stats[key]?.$2 ?? 0) + (task.isDone ? 1 : 0),
        );
      }
    }
    return stats;
  }

  // 선택된 날짜 기준 완료/전체 task 갯수
  Map<String, int> getTaskStatsForDate(DateTime date) {
    final tasks =
        taskBox.values.where((task) => isSameDay(task.date, date)).toList();
    final doneCount = tasks.where((task) => task.isDone).length;
    return {'done': doneCount, 'total': tasks.length};
  }

  void loadGoals() {
    final storedGoals = goalBox.values.toSet();
    _goals.clear();
    _goals.addAll(storedGoals);
    if (_goals.isNotEmpty) {
      _selectedGoal = _goals.first;
    }
    notifyListeners();
  }

  void addGoal(String goalName) {
    if (_goals.contains(goalName)) return;

    _goals.add(goalName);
    goalBox.add(goalName);
    notifyListeners();
  }

  void selectGoal(String goalName) {
    _selectedGoal = goalName;
    notifyListeners();
  }

  // task 추가 (goal + memo 포함)
  void addTask(String title, String goal, {String memo = ""}) {
    if (title.trim().isEmpty) return;
    final newTask = Task(
      title: title,
      isDone: false,
      date: _selectedDate,
      goal: goal,
      memo: memo,
    );
    taskBox.add(newTask);
    notifyListeners();
  }

  void deleteTask(Task task) {
    task.delete();
    notifyListeners();
  }

  /// Task 완료 여부 토글
  void toggleTaskCompletion(Task task) {
    task.isDone = !task.isDone;
    task.save();
    notifyListeners();
    // }
  }

  /// 메모 업데이트
  void updateTaskMemo(Task task, String newMemo) {
    task.memo = newMemo;
    task.save();
    notifyListeners();
  }

  /// 선택 날짜 변경
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
