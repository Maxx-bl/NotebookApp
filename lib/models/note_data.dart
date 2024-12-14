import 'package:flutter/material.dart';
import 'package:notebook/models/note.dart';

class NoteData extends ChangeNotifier {
  List<Note> allNotes = [
    Note(id: 0, text: 'First note'),
    Note(id: 1, text: 'Second note'),
    Note(id: 2, text: 'Third note'),
  ];

  List<Note> getAllNotes() {
    return allNotes;
  }

  void addNote(Note note) {
    allNotes.add(note);
    notifyListeners();
  }

  void updateNote(Note note, String text) {
    for (int i = 0; i < allNotes.length; i++) {
      if (allNotes[i].id == note.id) {
        allNotes[i].text = text;
      }
    }
    notifyListeners();
  }

  void deleteNote(Note note) {
    allNotes.remove(note); 
    notifyListeners();
  }
}