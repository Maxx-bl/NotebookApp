import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notebook/models/note_data.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';

void main() async {
  //init db
  await Hive.initFlutter();

  //open db
  await Hive.openBox('note_database');
  await Hive.openBox('bullet_database');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NoteData(),
      builder: (context, child) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}