import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/task.dart';
import 'providers/task_provider.dart';
import 'screens/daily_focus_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await getApplicationDocumentsDirectory();

  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(TaskAdapter());
  // // 먼저 박스를 열고
  // var tasksBox = await Hive.openBox<Task>('tasks');

  // // 비우고, 닫고, 디스크에서 삭제
  // await tasksBox.clear();
  // await tasksBox.close();
  // await Hive.deleteBoxFromDisk('tasks');

  await Hive.openBox<Task>('tasks');
  await Hive.openBox<String>('goals');

  runApp(DailyFocusApp());
}

class DailyFocusApp extends StatelessWidget {
  const DailyFocusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskProvider(),
      child: MaterialApp(
        title: 'Daily Focus',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          fontFamily: 'NanumSquare',
        ),
        home: DailyFocusPage(),
      ),
    );
  }
}
