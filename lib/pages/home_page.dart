import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notebook/models/note.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final db = Hive.box('notesBox');

  void addNote() {
    db.put(1, Note(text: 'bonjour'));
  }

  void getNote() {
    Note note = db.get(1);
    print(note.text);
    //return db.get(key);
  }

  void deleteNote() {
    db.delete(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 50, top: 100),
            child: const Text(
              'Notes',
              style: TextStyle(fontFamily: 'BebasNeue', fontSize: 50),
            ),
          ),
          MaterialButton(
            onPressed: addNote,
            color: Colors.blue[300],
            child: const Text('Add a note'),
          ),
          MaterialButton(
            onPressed: getNote,
            color: Colors.blue[300],
            child: const Text('Read a note'),
          ),
          MaterialButton(
            onPressed: deleteNote,
            color: Colors.blue[300],
            child: const Text('Delete a note'),
          )
        ],
      ),
    );
  }
}
