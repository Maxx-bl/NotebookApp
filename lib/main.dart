import 'package:flutter/material.dart';
import 'package:notebook/pages/notes_page.dart';
import 'package:notebook/models/note_database.dart';

void main() async {
  //Initialize db
  WidgetsFlutterBinding.ensureInitialized();
  await NoteDatabase.initialize();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: NotesPage(),
    );
  }
}
