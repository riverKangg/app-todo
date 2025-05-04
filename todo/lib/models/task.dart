import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  bool isDone;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  String? goal;

  Task({
    required this.title,
    this.isDone = false,
    required this.date,
    required this.goal,
  });
}

//flutter packages pub run build_runner build
