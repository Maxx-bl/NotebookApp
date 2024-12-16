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
    isNotePage = Provider.of<NoteData>(context, listen: false).loadSettings();
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
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: TextField(
                controller: _controller,
                decoration: const InputDecoration(hintText: 'New task...'),
                maxLength: 25,
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

    if (_controller.text.isNotEmpty) {
      int id =
          Provider.of<NoteData>(context, listen: false).getAllBullets().length;

      Note newBullet = Note(
        id: id,
        text: _controller.text,
        isDone: false,
      );

      _controller.clear();

      Provider.of<NoteData>(context, listen: false).addBullet(newBullet);
    }
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
        backgroundColor: const Color((0xff131313)),
        floatingActionButton: isNotePage
            ? FloatingActionButton(
                onPressed: isNotePage ? createNewNote : createNewBullet,
                elevation: 5,
                backgroundColor: const Color(0xff9900ff),
                child: const Icon(
                  Icons.add,
                  color: Colors.black,
                  size: 35,
                ),
              )
            : FloatingActionButton(
                onPressed: isNotePage ? createNewNote : createNewBullet,
                elevation: 5,
                backgroundColor: const Color(0xff00ff99),
                child: const Icon(
                  Icons.add,
                  color: Colors.black,
                  size: 35,
                ),
              ),
        bottomNavigationBar: NavigationBar(
          backgroundColor: const Color(0xff131313),
          destinations: [
            isNotePage
                ? IconButton(
                    onPressed: () => setState(() {
                          isNotePage = true;
                          Provider.of<NoteData>(context, listen: false)
                              .saveSettings(isNotePage);
                        }),
                    icon: const Icon(
                      Icons.library_books,
                      size: 40,
                      color: Color((0xff9900ff)),
                    ))
                : IconButton(
                    onPressed: () => setState(() {
                          isNotePage = true;
                          Provider.of<NoteData>(context, listen: false)
                              .saveSettings(isNotePage);
                        }),
                    icon: const Icon(
                      Icons.library_books,
                      size: 40,
                      color: Colors.white,
                    )),
            isNotePage
                ? IconButton(
                    onPressed: () => setState(() {
                          isNotePage = false;
                          Provider.of<NoteData>(context, listen: false)
                              .saveSettings(isNotePage);
                        }),
                    icon: const Icon(
                      Icons.checklist_outlined,
                      size: 40,
                      color: Colors.white,
                    ))
                : IconButton(
                    onPressed: () => setState(() {
                          isNotePage = false;
                          Provider.of<NoteData>(context, listen: false)
                              .saveSettings(isNotePage);
                        }),
                    icon: const Icon(
                      Icons.checklist_outlined,
                      size: 40,
                      color: Color(0xff00ff99),
                    )),
          ],
        ),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Container(
            margin: const EdgeInsets.only(left: 8, top: 50),
            child: AppBar(
              title: isNotePage
                  ? const Text(
                      'Notes',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Heavitas',
                          fontSize: 45,
                          fontWeight: FontWeight.bold),
                    )
                  : const Text(
                      'Tasks',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Heavitas',
                          fontSize: 45,
                          fontWeight: FontWeight.bold),
                    ),
              scrolledUnderElevation: 0,
              backgroundColor: const Color((0xff131313)),
            ),
          ),
        ),
        body: ListView(
          scrollDirection: Axis.vertical,
          children: [
            isNotePage
                ?
                //Note page
                value.getAllNotes().isEmpty
                    ? Lottie.asset('assets/animations/empty.json',
                        repeat: false)
                    : CupertinoListSection.insetGrouped(
                        dividerMargin: 0,
                        additionalDividerMargin: 0,
                        separatorColor: const Color(0xff3d3d3d),
                        backgroundColor: const Color(0xff131313),
                        children: List.generate(
                            value.getAllNotes().length,
                            (index) => CupertinoListTile(
                                  backgroundColor: const Color(0xff3d3d3d),
                                  backgroundColorActivated:
                                      const Color(0xff9900ff),
                                  title: Text(
                                    value.getAllNotes()[index].text,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  onTap: () => goToNotePage(
                                      value.getAllNotes()[index], false),
                                  trailing: IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                      onPressed: () async {
                                        await showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                  title: const Text(
                                                      'Delete this note?'),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context, false),
                                                        child: const Text(
                                                            'Cancel')),
                                                    TextButton(
                                                        onPressed: () => {
                                                              deleteNote(value
                                                                      .getAllNotes()[
                                                                  index]),
                                                              Navigator.pop(
                                                                  context,
                                                                  false)
                                                            },
                                                        child: const Text(
                                                          'Delete',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        ))
                                                  ],
                                                ));
                                      }),
                                )),
                      )

                //Bullet page
                : value.getAllBullets().isEmpty
                    ? Lottie.asset('assets/animations/empty.json',
                        repeat: false)
                    : CupertinoListSection.insetGrouped(
                        dividerMargin: 0,
                        additionalDividerMargin: 0,
                        separatorColor: const Color(0xff3d3d3d),
                        backgroundColor: const Color(0xff131313),
                        children: List.generate(
                            value.getAllBullets().length,
                            (index) => value.getAllBullets()[index].isDone
                                ? CupertinoListTile(
                                    backgroundColor: const Color(0xff00ff99),
                                    backgroundColorActivated:
                                        const Color(0xff9900ff),
                                    title: Row(
                                      children: [
                                        const Icon(
                                          Icons.check_circle_rounded,
                                          color: Colors.black,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: SizedBox(
                                              width: 210,
                                              child: Text(
                                                value
                                                    .getAllBullets()[index]
                                                    .text,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              )),
                                        ),
                                      ],
                                    ),
                                    onTap: () => checkBullet(
                                        value.getAllBullets()[index], false),
                                    trailing: IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.black,
                                        ),
                                        onPressed: () async {
                                          await showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
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
                                                          onPressed: () => {
                                                                deleteBullet(
                                                                    value.getAllBullets()[
                                                                        index]),
                                                                Navigator.pop(
                                                                    context,
                                                                    false)
                                                              },
                                                          child: const Text(
                                                            'Delete',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red),
                                                          ))
                                                    ],
                                                  ));
                                        }),
                                  )
                                : CupertinoListTile(
                                    backgroundColor: const Color(0xff3d3d3d),
                                    backgroundColorActivated:
                                        const Color(0xff9900ff),
                                    title: Row(
                                      children: [
                                        const Icon(
                                          Icons.circle_outlined,
                                          color: Colors.white,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: SizedBox(
                                              width: 210,
                                              child: Text(
                                                  value
                                                      .getAllBullets()[index]
                                                      .text,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      color: Colors.white))),
                                        ),
                                      ],
                                    ),
                                    onTap: () => checkBullet(
                                        value.getAllBullets()[index], true),
                                    trailing: IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ),
                                        onPressed: () async {
                                          await showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
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
                                                          onPressed: () => {
                                                                deleteBullet(
                                                                    value.getAllBullets()[
                                                                        index]),
                                                                Navigator.pop(
                                                                    context,
                                                                    false)
                                                              },
                                                          child: const Text(
                                                            'Delete',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red),
                                                          ))
                                                    ],
                                                  ));
                                        }),
                                  )),
                      )
          ],
        ),
      ),
    );
  }
}
