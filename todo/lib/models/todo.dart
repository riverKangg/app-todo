import 'package:hive/hive.dart';

part 'todo.g.dart'; // 이 부분 중요!

@HiveType(typeId: 0)
class Todo extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  DateTime? dueDate;

  @HiveField(3)
  bool isDone;

  Todo({
    required this.id,
    required this.title,
    this.dueDate,
    this.isDone = false,
  });

  factory Todo.create(String title, {DateTime? dueDate}) {
    return Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      dueDate: dueDate,
      isDone: false,
    );
  }
}
