import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/constants/color_constants.dart';

import '../../../constants/route_constants.dart';
import '../../../utils/style/styles.dart';
import '../../notes/models/note.model.dart';
import '../../notes/models/note_details_args.dart';
import '../../notes/widgets/note_tile.dart';
import 'bloc/tripdetails_bloc.dart';

class TripNotesView extends StatelessWidget{
  final List<Note>? notes;  
  final int tripId;

  TripNotesView(this.notes, this.tripId);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[          
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
            padding: new EdgeInsets.all(viewPadding),
            child: Center(
              child: Container(child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
                  Icon(Icons.notes_outlined, color: ColorsPalette.juicyGreen, size: headerFontSize),
                  SizedBox(height: sizerHeight),
                  Text('No notes here', style: quicksandStyle(fontSize: fontSize))
                ]))),
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