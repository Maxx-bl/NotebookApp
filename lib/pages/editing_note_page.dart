import 'package:flutter/cupertino.dart';
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
        .addNote(Note(id: id, text: text, isDone: false));
  }

  void updateNote() {
    String text = _controller.document.toPlainText();
    Provider.of<NoteData>(context, listen: false).updateNote(widget.note, text, widget.note.isDone);
  }

  void deleteNote() {
    Provider.of<NoteData>(context, listen: false).deleteNote(widget.note);
  }

  void leavePage() {
    // new note
    if (widget.isNewNote && !_controller.document.isEmpty()) {
      addNewNote();
    }

    // delete note if empty
    else if (_controller.document.isEmpty()) {
      deleteNote();
    }

    // update note
    else {
      updateNote();
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: leavePage,
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.blue,
            child: QuillSimpleToolbar(
              controller: _controller,
              configurations: const QuillSimpleToolbarConfigurations(
                multiRowsDisplay: false,
                showDividers: false,
                showFontFamily: false,
                showBoldButton: false,
                showItalicButton: false,
                showLineHeightButton: false,
                showStrikeThrough: false,
                showInlineCode: false,
                showColorButton: false,
                showBackgroundColorButton: false,
                showClearFormat: false,
                showAlignmentButtons: false,
                showHeaderStyle: false,
                showListNumbers: false,
                showListBullets: false,
                showListCheck: false,
                showCodeBlock: false,
                showQuote: false,
                showIndent: false,
                showLink: false,
                showDirection: false,
                showSearchButton: false,
                showSubscript: false,
                showSuperscript: false,
                showClipboardCut: false,
                showClipboardCopy: false,
                showClipboardPaste: false,
                showUnderLineButton: false,
                showCenterAlignment: false,
                showJustifyAlignment: false,
                showLeftAlignment: false,
                showRightAlignment: false,
                showSmallButton: false,
                showFontSize: false,
                color: CupertinoColors.systemGroupedBackground
              ),
            ),
          ),
          Expanded(
            child: Container(
                padding: const EdgeInsets.all(30),
                child: QuillEditor.basic(
                    controller: _controller,
                    configurations: const QuillEditorConfigurations(
                        placeholder: 'New note...',
                        customStyles: DefaultStyles(
                          paragraph: DefaultTextBlockStyle(
                            TextStyle(fontSize: 22, color: Colors.black),
                            HorizontalSpacing(0, 0),
                            VerticalSpacing(0, 0),
                            VerticalSpacing(0, 0),
                            BoxDecoration()
                          )
                        ),
                    ),
                  ),
              ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
                onPressed: leavePage,
                elevation: 5,
                backgroundColor: Colors.grey[200],
                child: const Icon(
                  Icons.check,
                  color: Colors.black,
                ),
              ),
    );
  }
}
