import 'package:flutter/material.dart';
import 'package:notebook/data/hive_database.dart';
import 'package:notebook/models/note.dart';

class NoteData extends ChangeNotifier {

  final db = HiveDatabase();

  List<Note> allNotes = [];

  void initializedNotes() {
    allNotes = db.loadNotes();
  }

  List<Note> getAllNotes() {
    return allNotes;
  }

  void addNote(Note note) {
    allNotes.add(note);
    notifyListeners();
    db.saveNotes(allNotes);
  }

  void updateNote(Note note, String text, bool isDone) {
    for (int i = 0; i < allNotes.length; i++) {
      if (allNotes[i].id == note.id) {
        allNotes[i].text = text;
        allNotes[i].isDone = isDone;
      }
    }
    notifyListeners();
    db.saveNotes(allNotes);
  }

  void deleteNote(Note note) {
    allNotes.remove(note); 
    notifyListeners();
    db.saveNotes(allNotes);
  }

  //Bullets

  List<Note> allBullets = [];

  void initializedBullets() {
    allBullets = db.loadBullets();
  }

  List<Note> getAllBullets() {
    return allBullets;
  }

  void addBullet(Note bullet) {
    allBullets.add(bullet);
    notifyListeners();
    db.saveBullets(allBullets);
  }

  void updateBullet(Note bullet, bool isDone) {
    for (int i = 0; i < allBullets.length; i++) {
      if (allBullets[i].id == bullet.id) {
        allBullets[i].isDone = isDone;
      }
    }
    notifyListeners();
    db.saveBullets(allBullets);
  }

  void deleteBullet(Note bullet) {
    allBullets.remove(bullet); 
    notifyListeners();
    db.saveBullets(allBullets);
  }

  bool loadSettings() {
    return db.loadSettings();
  }

  void saveSettings(bool isDefaultPageNote) {
    db.saveSettings(isDefaultPageNote);
  }
}