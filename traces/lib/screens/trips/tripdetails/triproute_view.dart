import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../constants/color_constants.dart';
import '../../../constants/route_constants.dart';
import '../../../utils/style/styles.dart';
import '../../../widgets/widgets.dart';
import '../model/trip.model.dart';
import '../model/trip_arguments.model.dart';
import '../model/trip_day.model.dart';
import '../model/trip_object.model.dart';
import '../widgets/trip_helpers.dart';
import 'bloc/tripdetails_bloc.dart';

class RouteView extends StatefulWidget{
  final Trip trip;  

  RouteView({required this.trip});

  @override
  _RouteViewViewState createState() => _RouteViewViewState();
}

class _RouteViewViewState extends State<RouteView>{
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 50.0),
      child: _timelineDays(widget.trip),
    );
  }

  Widget _timelineDays(Trip trip){
    var today = DateTime.now();
    var days = trip.endDate!.difference(trip.startDate!).inDays + 1;
    int tripDayNumber = today.difference(trip.startDate!).inDays;

    return Container(padding: EdgeInsets.only(left: 20.0), child: ListView.builder(
      shrinkWrap: true,         
      itemCount: days,
      itemBuilder: (context, position){        
        var date = trip.startDate!.add(Duration(days: position));
        return TimelineTile(              
          alignment: TimelineAlign.manual,
          lineXY: 0.15,
          isFirst: position == 0,
          isLast: position == days - 1,
          indicatorStyle: IndicatorStyle(
            width: 15,
            color: ColorsPalette.juicyYellow,
            padding: EdgeInsets.all(3),
            indicator: tripDayNumber < position ? Container(
              decoration: BoxDecoration(border: Border.fromBorderSide(
                BorderSide(
                  color: ColorsPalette.juicyYellow,
                  width: 2.0
                ),
              ),
              shape: BoxShape.circle,),
            ) : null
          ),
          startChild: Text('Day ${position+1}', style: tripDayNumber == position ? quicksandStyle(weight: FontWeight.bold,) : null),
          endChild: _dayCard(trip, position + 1, date),
          beforeLineStyle: const LineStyle(
            color:ColorsPalette.juicyYellow,
          ),
        );
      }
    )
    );
  }

    Widget _dayCard(Trip trip, int dayNumber, DateTime date){
      
      var bookings = trip.bookings?.where((b) => 
        b.entryDate != null && b.exitDate != null  &&
        (b.entryDate!.isBefore(date) || b.entryDate!.isSameDate(date)) &&
        (b.exitDate!.isAfter(date) || b.exitDate!.isSameDate(date))
      );

      var activities = trip.activities?.where((a) => 
        a.date != null && a.date!.isSameDate(date)
      );

      var tickets = trip.tickets?.where((t) => 
         t.departureDatetime != null && t.departureDatetime  != null  &&
        (t.departureDatetime !.isBefore(date) || t.departureDatetime !.isSameDate(date)) &&
        (t.arrivalDatetime!.isAfter(date) || t.arrivalDatetime!.isSameDate(date))
      ).toList();

      List<TripEvent> tripEvents = [];

      bookings?.forEach((booking) {
        var objectDate = new DateTime.utc(date.year, date.month, date.day, 23, 59);
        if(booking.entryDate!.isSameDate(date)) objectDate = booking.entryDate!;
        if(booking.exitDate!.isSameDate(date)) objectDate = booking.exitDate!;
        
        tripEvents.add(new TripEvent(
          type: TripEventType.Booking,
          id: booking.id!,
          startDate: objectDate,
          event: booking
        ));
      });

      activities?.forEach((activity) {
        tripEvents.add(new TripEvent(
          type: TripEventType.Activity,
          id: activity.id!,
          startDate: activity.date!,
          event: activity
        ));
      });

      tickets?.forEach((ticket) {
        var startDate;
        var endDate;
        if(ticket.arrivalDatetime!.isSameDate(date)) endDate = ticket.arrivalDatetime!;
        if(ticket.departureDatetime!.isSameDate(date)) startDate = ticket.departureDatetime!;

        tripEvents.add(new TripEvent(
          type: TripEventType.Ticket,
          id: ticket.id!,
          startDate: startDate,
          endDate: endDate,          
          event: ticket
        ));
      });

      return Container(child: InkWell(child: 
        Card(
          child: Container(
            constraints: const BoxConstraints(
              minHeight: 60,
            ),
            padding: EdgeInsets.all(10.0),        
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
              Text('${DateFormat.E().format(date)}, ${DateFormat.yMMMd().format(date)}', style: quicksandStyle(weight: date.isSameDate(DateTime.now()) ? FontWeight.bold : FontWeight.normal, fontSize: 16.0)),
              SizedBox(height: 3.0,),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  for(var tripEvent in sortObjects(tripEvents)) 
                    Row(children: [
                      getObjectIcon(tripEvent.type, tripEvent.event), 
                      SizedBox(width: 10.0)]
                    )
                ],))],)),
        ),
        onTap: (){
          TripDay tripDay = new TripDay(
            tripId: trip.id!,
            date: date,
            tripEvents: tripEvents
          );

          TripDayArguments args = new TripDayArguments(day: tripDay, trip: trip);

          Navigator.of(context).pushNamed(tripDayRoute, arguments: args).then((value) {
            TripDetailsArguments tripArgs = new TripDetailsArguments(isRoot: false, tripId: trip.id!);
            BlocProvider.of<TripDetailsBloc>(context)..add(GetTripDetails(tripArgs));
          });
        },
      ));
       
    }  
}