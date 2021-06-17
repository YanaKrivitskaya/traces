import 'package:flutter/material.dart';
import 'package:traces/colorsPalette.dart';
import 'package:traces/screens/trips/model/trip.dart';
import 'package:traces/screens/trips/tripdetails/bloc/tripdetails_bloc.dart';
import 'package:traces/shared/shared.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TripDeleteAlert extends StatelessWidget {
  final Trip trip;
  final StringCallback callback;

  const TripDeleteAlert({Key key, this.trip, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TripDetailsBloc, TripDetailsState>(
      bloc: BlocProvider.of(context),
      builder: (context, state){
        return AlertDialog(
          title: Text("Delete Trip?"),
          content: SingleChildScrollView(            
            child: Column( crossAxisAlignment: CrossAxisAlignment.start,
              children: [                
                Text('${trip.name}'),
                trip.description != null ? Text('${trip.description}') : Container(),
                Text('${DateFormat.yMMMd().format(trip.startDate)} - ${DateFormat.yMMMd().format(trip.endDate)}')                
              ],
            )
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Delete', style: TextStyle(color: ColorsPalette.meditSea)),
              onPressed: () {
                context.read<TripDetailsBloc>().add(DeleteTripClicked(trip.id));
                callback("Delete");
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Cancel', style: TextStyle(color: ColorsPalette.meditSea),),
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
