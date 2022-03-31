import 'package:flutter/material.dart';
import 'package:traces/constants/color_constants.dart';
import 'package:traces/screens/notes/bloc/trip_list_bloc/trip_list_bloc.dart';
import 'package:traces/screens/trips/model/trip.model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/widgets/widgets.dart';

class TripsListDialog extends StatefulWidget{
  final int noteId;
  final StringCallback? callback;
  
  const TripsListDialog({required this.noteId, this.callback});

  @override
  _TripsListDialogState createState() => new _TripsListDialogState();
}

class _TripsListDialogState extends State<TripsListDialog>{
  @override
  Widget build(BuildContext context) {
    //List<Trip> _trips = new List<Trip>.empty(growable: true);
    Trip defaultTrip = new Trip(id: -1, name: "No trip reference");

    return BlocListener<TripListBloc, TripListState>(
      listener: (context, state){        
        if(state is TripListSubmitted){
          widget.callback!("Ok");
          Navigator.pop(context);
        }
      },
      child: BlocBuilder<TripListBloc, TripListState>(
        builder:  (context, state){
          if(state is TripListSuccess){            
            return new AlertDialog(
            title: Text('Trip reference'),
            actions: [
              TextButton(
                onPressed: (){
                  context.read<TripListBloc>().add(TripSubmitted(widget.noteId, state.selectedTrip!.id!));
                  //Navigator.pop(context);
                }, 
                child: Text('Done')
              )
            ],
            content: Container(child: DropdownButtonFormField<Trip>(
                value: state.selectedTrip ?? state.trips!.first,
                isExpanded: true,
                decoration: InputDecoration(
                    labelText: "Trip",
                    labelStyle: TextStyle(color: ColorsPalette.mazarineBlue)),
                items: state.trips!.map((Trip trip) {
                  return new DropdownMenuItem<Trip>(
                    value: trip,
                    child: new Text(trip.name!),
                  );
                }).toList(),
                onChanged: (Trip? value) {
                  if(value != null){
                    context.read<TripListBloc>().add(TripUpdated(value));                    
                  }                  
                }
                )),
          );
          }
          return loadingWidget(ColorsPalette.juicyYellow);
          
        }
      )
    );
  }

}