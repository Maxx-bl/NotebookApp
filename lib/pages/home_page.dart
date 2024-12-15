import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
  bool isNotePage = true;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<NoteData>(context, listen: false).initializedNotes();
    Provider.of<NoteData>(context, listen: false).initializedBullets();
  }

  void createNewNote() {
    int id = Provider.of<NoteData>(context, listen: false).getAllNotes().length;

    Note newNote = Note(
      id: id,
      text: '',
      isDone: false,
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

  void checkNote(Note note, bool isDone) {
    Provider.of<NoteData>(context, listen: false)
        .updateNote(note, note.text, isDone);
  }

  void createNewBullet() async {
    int id =
        Provider.of<NoteData>(context, listen: false).getAllBullets().length;

    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: TextField(
                controller: _controller,
                decoration: const InputDecoration(hintText: 'New task...'),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel')),
                TextButton(
                    onPressed: () => {Navigator.pop(context, false)},
                    child: const Text(
                      'Create',
                      style: TextStyle(color: Colors.green),
                    ))
              ],
            ));

    Note newBullet = Note(
      id: id,
      text: _controller.text,
      isDone: false,
    );

    _controller.clear();

    Provider.of<NoteData>(context, listen: false).addBullet(newBullet);
  }

  void deleteBullet(Note bullet) {
    Provider.of<NoteData>(context, listen: false).deleteBullet(bullet);
  }

  void checkBullet(Note bullet, bool isDone) {
    Provider.of<NoteData>(context, listen: false).updateBullet(bullet, isDone);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteData>(
        builder: (context, value, child) => Scaffold(
              backgroundColor: CupertinoColors.systemGroupedBackground,
              floatingActionButton: FloatingActionButton(
                onPressed: isNotePage ? createNewNote : createNewBullet,
                elevation: 5,
                backgroundColor: Colors.grey[200],
                child: const Icon(
                  Icons.add,
                  color: Colors.black,
                ),
              ),
              appBar: AppBar(
                backgroundColor: CupertinoColors.systemGroupedBackground,
                actions: [
                  IconButton(
                      onPressed: () => setState(() {
                            isNotePage = true;
                          }),
                      icon: const Icon(Icons.note)),
                  IconButton(
                      onPressed: () => setState(() {
                            isNotePage = false;
                          }),
                      icon: const Icon(Icons.task)),
                ],
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isNotePage
                      ? const Padding(
                          padding: EdgeInsets.only(left: 40, top: 70),
                          child: Text(
                            'Notes',
                            style: TextStyle(
                                fontFamily: 'BebasNeue',
                                fontSize: 50,
                                fontWeight: FontWeight.bold),
                          ),)
                      : const Padding(
                          padding: EdgeInsets.only(left: 40, top: 70),
                          child: Text(
                            'Tasks',
                            style: TextStyle(
                                fontFamily: 'BebasNeue',
                                fontSize: 50,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                  isNotePage
                      ?
                      //Note page
                      value.getAllNotes().isEmpty
                          ? Lottie.asset('assets/animations/empty.json',
                              repeat: false)
                          : CupertinoListSection.insetGrouped(
                              children: List.generate(
                                  value.getAllNotes().length,
                                  (index) => CupertinoListTile(
                                      title:
                                          Text(value.getAllNotes()[index].text),
                                      onTap: () => goToNotePage(
                                          value.getAllNotes()[index], false),
                                      trailing: Row(
                                        children: [
                                          Checkbox(
                                            value: value
                                                .getAllNotes()[index]
                                                .isDone,
                                            onChanged: (val) => {
                                              checkNote(
                                                  value.getAllNotes()[index],
                                                  val ?? false)
                                            },
                                          ),
                                          IconButton(
                                              icon: const Icon(Icons.delete),
                                              onPressed: () async {
                                                await showDialog(
                                                    context: context,
                                                    builder:
                                                        (context) =>
                                                            AlertDialog(
                                                              title: const Text(
                                                                  'Delete this note?'),
                                                              actions: [
                                                                TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.pop(
                                                                            context,
                                                                            false),
                                                                    child: const Text(
                                                                        'Cancel')),
                                                                TextButton(
                                                                    onPressed:
                                                                        () => {
                                                                              deleteNote(value.getAllNotes()[index]),
                                                                              Navigator.pop(context, false)
                                                                            },
                                                                    child:
                                                                        const Text(
                                                                      'Delete',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.red),
                                                                    ))
                                                              ],
                                                            ));
                                              }),
                                        ],
                                      ))),
                            )

                      //Bullet page
                      : value.getAllBullets().isEmpty
                          ? Lottie.asset('assets/animations/empty.json',
                              repeat: false)
                          : CupertinoListSection.insetGrouped(
                              children: List.generate(
                                  value.getAllBullets().length,
                                  (index) => value.getAllBullets()[index].isDone? CupertinoListTile(
                                    backgroundColor: Colors.green[100],
                                      title: Row(
                                        children: [
                                          const Icon(Icons.check_circle_rounded),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20),
                                            child: Text(value.getAllBullets()[index].text),
                                          ),
                                        ],
                                      ),
                                      onTap: () => checkBullet(value.getAllBullets()[index], false),
                                      trailing: IconButton(
                                              icon: const Icon(Icons.delete),
                                              onPressed: () async {
                                                await showDialog(
                                                    context: context,
                                                    builder:
                                                        (context) =>
                                                            AlertDialog(
                                                              title: const Text(
                                                                  'Delete this task?'),
                                                              actions: [
                                                                TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.pop(
                                                                            context,
                                                                            false),
                                                                    child: const Text(
                                                                        'Cancel')),
                                                                TextButton(
                                                                    onPressed:
                                                                        () => {
                                                                              deleteBullet(value.getAllBullets()[index]),
                                                                              Navigator.pop(context, false)
                                                                            },
                                                                    child:
                                                                        const Text(
                                                                      'Delete',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.red),
                                                                    ))
                                                              ],
                                                            ));
                                              }),
                                      )
                                      :

                                      CupertinoListTile(
                                      backgroundColor: Colors.red[100],
                                      title: Row(
                                        children: [
                                          const Icon(Icons.circle_outlined),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20),
                                            child: Text(value.getAllBullets()[index].text),
                                          ),
                                        ],
                                      ),
                                      onTap: () => checkBullet(value.getAllBullets()[index], true),
                                      trailing: IconButton(
                                              icon: const Icon(Icons.delete),
                                              onPressed: () async {
                                                await showDialog(
                                                    context: context,
                                                    builder:
                                                        (context) =>
                                                            AlertDialog(
                                                              title: const Text(
                                                                  'Delete this task?'),
                                                              actions: [
                                                                TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.pop(
                                                                            context,
                                                                            false),
                                                                    child: const Text(
                                                                        'Cancel')),
                                                                TextButton(
                                                                    onPressed:
                                                                        () => {
                                                                              deleteBullet(value.getAllBullets()[index]),
                                                                              Navigator.pop(context, false)
                                                                            },
                                                                    child:
                                                                        const Text(
                                                                      'Delete',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.red),
                                                                    ))
                                                              ],
                                                            ));
                                              }),
                                      )
                                    ),
                            )
                ],
              ),
            ));
  }
}
