
import 'package:flutter/material.dart';
import 'package:traces/screens/notes/note.dart';
import 'package:traces/screens/notes/notes_bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef void StringCallback(String val);

class NoteDeleteAlert extends StatelessWidget{
  final Note note;
  final StringCallback callback;

  const NoteDeleteAlert({Key key, this.note, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesBloc, NotesState>(
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
              context.bloc<NotesBloc>().add(DeleteNote(note));
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