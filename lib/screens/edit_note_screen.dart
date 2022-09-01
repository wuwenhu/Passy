import 'package:flutter/material.dart';
import 'package:passy/common/common.dart';
import 'package:passy/passy_data/loaded_account.dart';
import 'package:passy/passy_data/note.dart';
import 'package:passy/screens/note_screen.dart';
import 'package:passy/widgets/widgets.dart';
import 'package:passy/common/theme.dart';

import 'notes_screen.dart';
import 'splash_screen.dart';
import 'main_screen.dart';

class EditNoteScreen extends StatefulWidget {
  const EditNoteScreen({Key? key}) : super(key: key);

  static const routeName = '${NoteScreen.routeName}/edit';

  @override
  State<StatefulWidget> createState() => _EditNoteScreen();
}

class _EditNoteScreen extends State<EditNoteScreen> {
  bool _isLoaded = false;
  bool _isNew = true;

  String? _key;
  String _title = '';
  String _note = '';

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) {
      Object? _args = ModalRoute.of(context)!.settings.arguments;
      _isNew = _args == null;
      if (!_isNew) {
        Note _noteArgs = _args as Note;
        _key = _noteArgs.key;
        _title = _noteArgs.title;
        _note = _noteArgs.note;
      }
      _isLoaded = true;
    }

    return Scaffold(
      appBar: EditScreenAppBar(
        title: 'note',
        isNew: _isNew,
        onSave: () {
          final LoadedAccount _account = data.loadedAccount!;
          Note _noteArgs = Note(
            key: _key,
            title: _title,
            note: _note,
          );
          _account.setNote(_noteArgs);
          Navigator.pushNamed(context, SplashScreen.routeName);
          _account.save().whenComplete(() {
            Navigator.popUntil(
                context, (r) => r.settings.name == MainScreen.routeName);
            Navigator.pushNamed(context, NotesScreen.routeName);
            Navigator.pushNamed(context, NoteScreen.routeName,
                arguments: _noteArgs);
          });
        },
      ),
      body: ListView(children: [
        PassyTextFormField(
          initialValue: _title,
          decoration: const InputDecoration(labelText: 'Title'),
          onChanged: (value) => setState(() => _title = value.trim()),
        ),
        PassyTextFormField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          initialValue: _note,
          decoration: InputDecoration(
            labelText: 'Note',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28.0),
              borderSide: BorderSide(color: lightContentColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28.0),
              borderSide: BorderSide(color: darkContentSecondaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28.0),
              borderSide: BorderSide(color: lightContentColor),
            ),
          ),
          onChanged: (value) => setState(() => _note = value),
        ),
      ]),
    );
  }
}
