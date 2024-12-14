import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notebook/models/note.dart';
import 'package:notebook/models/note_data.dart';
import 'package:notebook/pages/editing_note_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void createNewNote() {
    int id = Provider.of<NoteData>(context, listen: false).getAllNotes().length;

    Note newNote = Note(
      id: id,
      text: 'new note',
    );

    goToNotePage(newNote, true);
  }

  void goToNotePage(Note note, bool isNewNote) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditingNotePage(
                  note: note,
                  isNewNote: isNewNote,
                )));
  }

  void deleteNote(Note note) {
    Provider.of<NoteData>(context, listen: false).deleteNote(note);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteData>(
        builder: (context, value, child) => Scaffold(
              backgroundColor: CupertinoColors.systemGroupedBackground,
              floatingActionButton: FloatingActionButton(
                onPressed: createNewNote,
                elevation: 5,
                backgroundColor: Colors.grey[200],
                child: const Icon(
                  Icons.add,
                  color: Colors.black,
                ),
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 75, top: 100),
                    child: Text(
                      'Notes',
                      style: TextStyle(
                          fontFamily: 'BebasNeue',
                          fontSize: 50,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  CupertinoListSection.insetGrouped(
                    children: List.generate(
                        value.getAllNotes().length,
                        (index) => CupertinoListTile(
                              title: Text(value.getAllNotes()[index].text),
                            )),
                  )
                ],
              ),
            ));
  }
}
