
import 'package:flutter/material.dart';
import 'package:traces/screens/notes/note.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/shared/shared.dart';

import 'bloc/note_bloc/bloc.dart';

class NoteDeleteAlert extends StatelessWidget{
  final Note note;
  final StringCallback callback;

  const NoteDeleteAlert({Key key, this.note, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteBloc, NoteState>(
    bloc: BlocProvider.of(context),
    builder: (context, state) {
      return AlertDialog(
        title: Text('Delete note?'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('${note.title}'),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Delete'),
            onPressed: () {
              context.bloc<NoteBloc>().add(DeleteNote(note));
              callback("Delete");
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              callback("Cancel");
              Navigator.pop(context);
            },
          ),
        ],
      );
    }
    );
  }
}