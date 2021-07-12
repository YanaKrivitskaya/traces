
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/screens/notes/bloc/note_details_bloc/bloc.dart';

import '../../../widgets/widgets.dart';
import '../bloc/note_bloc/bloc.dart';
import '../models/note.model.dart';

class NoteDeleteAlert extends StatelessWidget{
  final Note? note;
  final StringCallback? callback;

  const NoteDeleteAlert({Key? key, this.note, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<NoteDetailsBloc, NoteDetailsState>(
      listener: (context, state){
        if(state is ViewDetailsState && state.noteDeleted != null && state.noteDeleted!){
          callback!("Ok");
          Navigator.pop(context);
        }
        if(state is ErrorDetailsState){
          callback!(state.errorMessage.toString());
          Navigator.pop(context);
        }
      },
      child: BlocBuilder<NoteDetailsBloc, NoteDetailsState>(
        bloc: BlocProvider.of(context),
        builder: (context, state) {
          return AlertDialog(
            title: Text('Delete note?'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('${note!.title}'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Delete'),
                onPressed: () {
                  context.read<NoteDetailsBloc>().add(DeleteNote(note));
                  /*callback!("Delete");
                  Navigator.pop(context);*/
                },
              ),
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  callback!("Cancel");
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
    ),
    );
  }
}