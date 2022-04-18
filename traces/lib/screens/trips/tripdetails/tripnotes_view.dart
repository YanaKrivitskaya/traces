import 'package:flutter/material.dart';
import 'package:traces/constants/color_constants.dart';
import 'package:traces/constants/route_constants.dart';
import 'package:traces/screens/notes/models/note.model.dart';
import 'package:traces/screens/notes/models/note_details_args.dart';
import 'package:traces/screens/notes/widgets/note_tile.dart';
import 'package:traces/screens/trips/tripdetails/bloc/tripdetails_bloc.dart';
import 'package:traces/utils/style/styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TripNotesView extends StatelessWidget{
  final List<Note>? notes;  
  final int tripId;

  TripNotesView(this.notes, this.tripId);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          //state.searchEnabled! ? _searchBar() : Container(),
          notes != null && notes!.length > 0 ?
          Container(
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: notes!.length,              
              itemBuilder: (context, position){
                final note = notes![position];
                return _noteCard(note, context);
              }
            ),
          ) : Container(
            padding: new EdgeInsets.all(25.0),
            child: Center(
              child: Container(child: Center(child: Text("No notes here", style: quicksandStyle(fontSize: 18.0)))),
            )
          )
        ],
      ),
    );
  }

  Widget _noteCard(Note note, BuildContext context) => new Card(    
    child: Column(      
      children: <Widget>[          
        InkWell(
            onTap: (){   
              NoteDetailsArgs args = new NoteDetailsArgs(noteId: note.id, tripId: null);
              Navigator.pushNamed(context, noteDetailsRoute, arguments: args).then((value)
                {
                  BlocProvider.of<TripDetailsBloc>(context)..add(GetTripDetails(tripId));
                });
              },
          child: NoteTileView(note, false, null),
        )
      ],
    ),
  ); 
}