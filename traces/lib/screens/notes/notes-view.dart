
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:traces/colorsPalette.dart';
import 'package:traces/constants.dart';
import 'package:traces/screens/notes/notes_bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traces/screens/notes/note.dart';

class NotesView extends StatefulWidget{
  NotesView();
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  NotesBloc _notesBloc;

  @override
  void initState() {
    super.initState();
    _notesBloc = BlocProvider.of<NotesBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotesBloc, NotesState>(
        listener: (context, state) {
        },
        child: BlocBuilder<NotesBloc, NotesState>(
            bloc: BlocProvider.of(context),
            builder: (context, state){
              if(state is NotesEmpty){
                _notesBloc.add(GetNotes());
                return Center(child: CircularProgressIndicator());
              }
              if(state is NotesLoadInProgress){
                return Center(child: CircularProgressIndicator());
              }else if(state is NotesLoadSuccess){
                final notes = _sortNotes(state.notes, state.sortField);
                return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: notes.length,
                    reverse: state.sortDirection == SortDirections.ASC ? true : false,
                    itemBuilder: (context, position){
                      final note = notes[position];
                      return Card(
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.description, size: 40.0, color: ColorsPalette.nycTaxi,),
                              title: Text('${note.title}'),
                              subtitle: (note.dateCreated.day.compareTo(note.dateModified.day) == 0) ?
                              Text('${DateFormat.yMMMd().format(note.dateModified)}',
                                  style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.blueHorizon), fontSize: 12.0)) :
                              Text('${DateFormat.yMMMd().format(note.dateModified)} / ${DateFormat.yMMMd().format(note.dateCreated)}',
                                  style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.blueHorizon), fontSize: 12.0)),
                              trailing: _popupMenu(note, position),
                              onTap: (){
                                Navigator.pushNamed(context, noteDetailsRoute, arguments: note.id);
                              },
                            ),
                            /*(notes[position].categoryId != null && categories != null) ? Container(
                          child: Container(
                            child: _getCategoryNameById(notes[position].categoryId) != null ?
                            Align(
                              child: Chip(
                                label: Text('${_getCategoryNameById(notes[position].categoryId)}',
                                    style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.grayLight))),
                                backgroundColor: ColorsPalette.greenGrass,
                              ),
                              alignment: Alignment.centerLeft,
                            )
                                : Container(height: 0.0),
                            margin: EdgeInsets.only(left: 20.0),
                          )
                      ):Container(height: 0.0)*/
                          ],
                        ),
                      );
                    }
                );
              }else {
                return Container();
              }
            }
        ),
    );
  }

  List<Note> _sortNotes(List<Note> notes, SortFields sortOption){
    notes.sort((a, b){
      switch(sortOption){
        case SortFields.DATECREATED:{
          return a.dateCreated.millisecondsSinceEpoch.compareTo(b.dateCreated.millisecondsSinceEpoch);
        }
        case SortFields.DATEMODIFIED:{
          return a.dateModified.millisecondsSinceEpoch.compareTo(b.dateModified.millisecondsSinceEpoch);
        }
        case SortFields.TITLE:{
          return a.title.toUpperCase().compareTo(b.title.toUpperCase());
        }
      }
      return a.title.compareTo(b.title);
    });
    return notes;
  }

  Widget _popupMenu(Note note, int position) => PopupMenuButton<int>(
    itemBuilder: (context) => [
      PopupMenuItem(
        value: 2,
        child: Text(
          "Delete",
          style:
          TextStyle(color: ColorsPalette.blueHorizon, fontWeight: FontWeight.w700),
        ),
      ),
    ],
    onSelected: (value) async{
      if(value == 2){
        _deleteAlert(note).then((res){});
      }
      print("value:$value");
    },
  );

  Future<String> _deleteAlert(Note note) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
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
                _notesBloc.add(DeleteNote(note));
                Navigator.pop(context, "Delete");
              },
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context, "Cancel");
              },
            ),
          ],
        );
      },
    );
  }
}


