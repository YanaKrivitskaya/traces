import 'package:flutter/material.dart';
import 'package:traces/constants/color_constants.dart';
import 'package:traces/constants/route_constants.dart';
import 'package:traces/screens/notes/models/note.model.dart';
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
              //everse: state.sortDirection == SortDirections.ASC ? true : false,
              itemBuilder: (context, position){
                final note = notes![position];
                return _noteCard(note, context);
              }
            ),
          ) : Container(
            padding: new EdgeInsets.all(25.0),
            child: Center(
              child: Text("No notes here", style: quicksandStyle(color: ColorsPalette.juicyBlue, fontSize: 18.0)),
            )
          )
        ],
      ),
    );
  }

  Widget _noteCard(Note note, BuildContext context) => new Card(    
    child: Column(
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        note.trip != null ? Container(
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          alignment: Alignment.centerLeft,
          child: Chip(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
            backgroundColor: /*ColorsPalette.natureGreenLight*/ColorsPalette.amMint,
            label: Text(note.trip!.name!, style: TextStyle(color: /*ColorsPalette.juicyGreen*/ColorsPalette.white)),
          ),
        ) : Container(),    
        InkWell(
            onTap: (){             
            Navigator.pushNamed(context, noteDetailsRoute, arguments: note.id).then((value)
              {
                BlocProvider.of<TripDetailsBloc>(context)..add(GetTripDetails(tripId));
              });
            },
          child: NoteTileView(note, false, null),
        )
      ],
    ),
  );

  /*@override
  _TripNotesViewState createState() => _TripNotesViewState();*/
}