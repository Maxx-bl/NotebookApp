import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notebook/models/note.dart';

class HiveDatabase {
  final db = Hive.box('note_database');
  final dbBullets = Hive.box('bullet_database');
  final dbSettings = Hive.box('settings');

  //Notes

  List<Note> loadNotes() {
    List<Note> savedNotesFormatted = [];

    if (db.get('ALL_NOTES') != null) {
      List<dynamic> savedNotes = db.get('ALL_NOTES');
      for (int i = 0; i < savedNotes.length; i++) {
        Note note = Note(id: savedNotes[i][0], text: savedNotes[i][1], isDone: savedNotes[i][2]);
        savedNotesFormatted.add(note);
      }
    } else {
      savedNotesFormatted.add(Note(id: 0, text: 'Your first note!', isDone: false));
    }
    return savedNotesFormatted; 
  }

  void saveNotes(List<Note> allnotes) {
    List<List<dynamic>> allNotesFormatted = [];
    for (var note in allnotes) {
      int id = note.id;
      String text = note.text;
      bool isDone = note.isDone;
      allNotesFormatted.add([id, text, isDone]);
    }

    db.put('ALL_NOTES', allNotesFormatted);
  }

  //Bullets

  List<Note> loadBullets() {
    List<Note> savedBulletsFormatted = [];

    if (dbBullets.get('ALL_BULLETS') != null) {
      List<dynamic> savedBullets = dbBullets.get('ALL_BULLETS');
      for (int i = 0; i < savedBullets.length; i++) {
        Note note = Note(id: savedBullets[i][0], text: savedBullets[i][1], isDone: savedBullets[i][2]);
        savedBulletsFormatted.add(note);
      }
    } else {
      savedBulletsFormatted.add(Note(id: 0, text: 'Your first task!', isDone: false));
    }
    return savedBulletsFormatted; 
  }

  void saveBullets(List<Note> allBullets) {
    List<List<dynamic>> allBulletsFormatted = [];
    for (var bullet in allBullets) {
      int id = bullet.id;
      String text = bullet.text;
      bool isDone = bullet.isDone;
      allBulletsFormatted.add([id, text, isDone]);
    }

    dbBullets.put('ALL_BULLETS', allBulletsFormatted);
  }

  bool loadSettings() {
    return dbSettings.get('LAST_PAGE')??true;
  }

  void saveSettings(bool isDefaultPageNote) {
    dbSettings.put('LAST_PAGE', isDefaultPageNote);
  }
}