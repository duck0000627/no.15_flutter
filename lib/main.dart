import 'package:flutter/material.dart';
import 'package:no15/screens/splash_screen.dart';
import 'package:no15/view_models/record_view_model.dart';
import 'package:provider/provider.dart';

import 'database_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 🔹 啟動 App 前先打開資料庫
  await DatabaseHelper.instance.database;
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => RecordViewModel())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '農作物紀錄APP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SplashScreen(),
    );
  }
}
