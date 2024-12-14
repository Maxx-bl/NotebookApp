import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notebook/models/note_data.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';

//ignore: must_be_immutable
class EditingNotePage extends StatefulWidget {
  Note note;
  bool isNewNote;

  EditingNotePage({super.key, required this.note, required this.isNewNote});

  @override
  State<EditingNotePage> createState() => _EditingNotePageState();
}

class _EditingNotePageState extends State<EditingNotePage> {
  QuillController _controller = QuillController.basic();

  @override
  void initState() {
    super.initState();
    loadExistingNote();
  }

  void loadExistingNote() {
    final doc = Document()..insert(0, widget.note.text);
    setState(() {
      _controller = QuillController(
          document: doc, selection: const TextSelection.collapsed(offset: 0));
    });
  }

  void addNewNote() {
    int id = Provider.of<NoteData>(context, listen: false).getAllNotes().length;
    String text = _controller.document.toPlainText();
    Provider.of<NoteData>(context, listen: false)
        .addNote(Note(id: id, text: text));
  }

  void updateNote() {
    String text = _controller.document.toPlainText();
    Provider.of<NoteData>(context, listen: false).updateNote(widget.note, text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          // new note
          if (widget.isNewNote && !_controller.document.isEmpty()) { addNewNote(); }

          // update note
          else { updateNote(); }
    
          Navigator.pop(context);
        },
         icon: const Icon(Icons.arrow_back, color: Colors.black,)),
      ),
      body: Column(
        children: [
          QuillToolbar.basic(
            controller: _controller,
            showAlignmentButtons: false,
            showCenterAlignment: false,
            showBackgroundColorButton: false,
            showBoldButton: false,
            showClearFormat: false,
            showCodeBlock: false,
            showColorButton: false,
            showDirection: false,
            showDividers: false,
            showFontFamily: false,
            showFontSize: false,
            showHeaderStyle: false,
            showIndent: false,
            showInlineCode: false,
            showItalicButton: false,
            showJustifyAlignment: false,
            showLeftAlignment: false,
            showLink: false,
            showListBullets: false,
            showListCheck: false,
            showListNumbers: false,
            showQuote: false,
            showRightAlignment: false,
            showSearchButton: false,
            showSmallButton: false,
            showStrikeThrough: false,
            showUnderLineButton: false,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(30),
              child: QuillEditor.basic(
                controller: _controller,
                readOnly: false,
              ),
            ),
          )
        ],
      ),
    );
  }
}
