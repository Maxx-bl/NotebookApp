import 'package:isar/isar.dart';
import 'package:notebook/models/note.dart';
import 'package:path_provider/path_provider.dart';

class NoteDatabase {
  static late Isar isar;

  // Initialize
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([NoteSchema], directory: dir.path);
  }

  final List<Note> currentNotes = [];

  // Create
  Future<void> addNote(String userText) async {
    //Create note
    final newNote = Note()..text = userText;
    //Save note 
    await isar.writeTxn(() => isar.notes.put(newNote));
    //Read from db
    fetchNote();
  }

  // Read
  Future<void> fetchNote() async {
    List<Note> fetchedNotes = await isar.notes.where().findAll();
    currentNotes.addAll(fetchedNotes);
  }

  // Update
  Future<void> updateNote(int id, String newText) async {
    final existingNote = await isar.notes.get(id);
    if (existingNote != null) {
      existingNote.text = newText;
      await isar.writeTxn(() => isar.notes.put(existingNote));
      await fetchNote();
    }
  }

  // Delete
  Future<void> deleteNote(int id) async {
    await isar.writeTxn(() => isar.notes.delete(id));
    await fetchNote();
  }

}