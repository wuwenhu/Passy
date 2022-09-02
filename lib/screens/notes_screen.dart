import 'package:flutter/material.dart';

import 'package:passy/common/common.dart';
import 'package:passy/passy_data/note.dart';
import 'package:passy/passy_flutter/passy_flutter.dart';

import 'main_screen.dart';
import 'note_screen.dart';
import 'search_screen.dart';
import 'edit_note_screen.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  static const routeName = '${MainScreen.routeName}/notes';

  @override
  State<StatefulWidget> createState() => _NotesScreen();
}

class _NotesScreen extends State<NotesScreen> {
  void _onAddPressed() =>
      Navigator.pushNamed(context, EditNoteScreen.routeName);

  void _onSearchPressed() {
    Navigator.pushNamed(context, SearchScreen.routeName,
        arguments: (String terms) {
      final List<Note> _found = [];
      final List<String> _terms = terms.trim().toLowerCase().split(' ');
      for (Note _note in data.loadedAccount!.notes) {
        {
          bool testNote(Note value) => _note.key == value.key;

          if (_found.any(testNote)) continue;
        }
        {
          int _positiveCount = 0;
          for (String _term in _terms) {
            if (_note.title.toLowerCase().contains(_term)) {
              _positiveCount++;
              continue;
            }
          }
          if (_positiveCount == _terms.length) {
            _found.add(_note);
          }
        }
      }
      return NoteButtonListView(
        notes: data.loadedAccount!.notes.toList(),
        shouldSort: true,
        onPressed: (note) => Navigator.pushNamed(context, NoteScreen.routeName),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EntriesScreenAppBar(
          title: const Center(child: Text('Notes')),
          onSearchPressed: _onSearchPressed,
          onAddPressed: _onAddPressed),
      body: NoteButtonListView(
        notes: data.loadedAccount!.notes.toList(),
        shouldSort: true,
        onPressed: (note) => Navigator.pushNamed(context, NoteScreen.routeName),
      ),
    );
  }
}
