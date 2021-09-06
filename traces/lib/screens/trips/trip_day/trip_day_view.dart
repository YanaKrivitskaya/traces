import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../constants/color_constants.dart';
import '../../../constants/route_constants.dart';
import '../../../utils/style/styles.dart';
import '../../../widgets/widgets.dart';
import '../model/activity.model.dart';
import '../model/booking.model.dart';
import '../model/ticket.model.dart';
import '../model/trip.model.dart';
import '../model/trip_arguments.model.dart';
import '../model/trip_day.model.dart';
import '../model/trip_object.model.dart';
import '../widgets/trip_helpers.dart';
import 'bloc/tripday_bloc.dart';

class TripDayView extends StatefulWidget{
  Trip trip;

  TripDayView({required this.trip});

  @override
  _TripDayState createState() => _TripDayState();
}

class _TripDayState extends State<TripDayView>{
  TripDay? tripDay;
  var isDialOpen = ValueNotifier<bool>(false);
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<TripDayBloc, TripDayState>(
      listener: (context, state){
        if(state.tripDay != null) tripDay = state.tripDay!;

        if(state is TripDayError){
            ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              backgroundColor: ColorsPalette.redPigment,
              content: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Container(width: 250,
                  child: Text(
                    state.error,
                    style: quicksandStyle(color: ColorsPalette.lynxWhite),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 5                    
                  ),
                ),
                Icon(Icons.error, color: ColorsPalette.lynxWhite)
                ],
                ),
                duration: Duration(seconds: 10),
              ));
          }
      },
      child: BlocBuilder<TripDayBloc, TripDayState>(
        builder: (context, state){
          if (tripDay != null)
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
                title: Text('${DateFormat.yMMMd().format(tripDay!.date)}',
                  style: quicksandStyle(fontSize: 30.0)),
                backgroundColor: ColorsPalette.white,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.close_rounded),
                  onPressed: ()=> Navigator.pop(context)
                )
            ),
            floatingActionButton: _floatingButton(widget.trip, tripDay!.date),
            body: tripDay != null && tripDay!.tripEvents.length > 0 ? Container(
              padding: EdgeInsets.only(bottom: 50.0),
              child: _timelineDay(tripDay!),
            ) : Container(child: Text('You have no scheduled events for this day', style: quicksandStyle(fontSize: 18.0))),
          ); 
          else return loadingWidget(ColorsPalette.juicyGreen);
        },
      ),
    );
  }

  Widget _timelineDay(TripDay day){
    var events = day.tripEvents.length;
    return Container(padding: EdgeInsets.only(left: 20.0, right: 20.0), child: ListView.builder(
      shrinkWrap: true,         
      itemCount: events,
      itemBuilder: (context, position){
        var tripEvent = day.tripEvents[position];
        DateTime startDate = tripEvent.startDate!;
        DateTime? endDate = tripEvent.endDate;
        return TimelineTile(              
          alignment: TimelineAlign.manual,
          lineXY: 0.19,
          isFirst: position == 0,
          isLast: position == events - 1,
          indicatorStyle: IndicatorStyle(
            indicator: getObjectIcon(tripEvent.type, tripEvent.event),                
            padding: EdgeInsets.all(8),
          ),
          startChild: Text('${DateFormat.Hm().format(startDate)} ${endDate != null 
            && tripEvent.type == TripEventType.Ticket ?' - ' + DateFormat.Hm().format(endDate) : ''}'),
          endChild: _eventCard(tripEvent),
          beforeLineStyle: const LineStyle(
            color:ColorsPalette.christmasGrey,
          ),
        );
    }));
  }

  Widget _eventCard(TripEvent tripEvent){ 
    switch (tripEvent.type){
      case TripEventType.Booking:{
        Booking booking = tripEvent.event as Booking;
        return Container(
          child: InkWell(child: 
          Card(
            child: Container(
              constraints: const BoxConstraints(
                minHeight: 60,
              ),
              padding: EdgeInsets.all(10.0),        
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                Text('${booking.name}', style: quicksandStyle(fontSize: 16.0,)),
                //Text('${DateFormat.E().format(date)}, ${DateFormat.yMMMd().format(date)}', style: quicksandStyle(fontSize: 16.0,)),
                SizedBox(height: 3.0,),
                SingleChildScrollView(                  
                  child:Text('${booking.details}', style: quicksandStyle(fontSize: 16.0,)))
              ],)),
          ),
          onTap: (){},
        )
        );
      }
      case TripEventType.Ticket:{
        Ticket ticket = tripEvent.event as Ticket;
        return Container(
          child: InkWell(child: 
          Card(
            child: Container(
              constraints: const BoxConstraints(
                minHeight: 60,
              ),
              padding: EdgeInsets.all(10.0),        
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                Text('${ticket.departureLocation} - ${ticket.arrivalLocation}', style: quicksandStyle(fontSize: 16.0,)),
                //Text('${DateFormat.E().format(date)}, ${DateFormat.yMMMd().format(date)}', style: quicksandStyle(fontSize: 16.0,)),
                SizedBox(height: 3.0,),
                SingleChildScrollView(                  
                  child:Text('${ticket.details}', style: quicksandStyle(fontSize: 16.0,)))
              ],)),
          ),
          onTap: (){},
        )
        );
      }
      case TripEventType.Activity:{
        Activity activity = tripEvent.event as Activity;
        return Container(
          child: InkWell(child: 
          Card(
            child: Container(
              constraints: const BoxConstraints(
                minHeight: 60,
              ),
              padding: EdgeInsets.all(10.0),        
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                Text('${activity.name}', style: quicksandStyle(fontSize: 16.0,)),
                //Text('${DateFormat.E().format(date)}, ${DateFormat.yMMMd().format(date)}', style: quicksandStyle(fontSize: 16.0,)),
                SizedBox(height: 3.0,),
                SingleChildScrollView(                  
                  child:Text('${activity.description}', style: quicksandStyle(fontSize: 16.0,)))
              ],)),
          ),
          onTap: (){},
        )
        );
      }
      default: return Container();
    }       
  }

  Widget _floatingButton(Trip trip, DateTime date) {
    EventArguments args = new EventArguments(trip: trip, date: date);
    return SpeedDial(
      foregroundColor: ColorsPalette.lynxWhite,
      icon: Icons.add,
      activeIcon: Icons.close,
      spacing: 3,
      openCloseDial: isDialOpen,
      childPadding: EdgeInsets.all(5),
      spaceBetweenChildren: 4,
      renderOverlay: true,
      overlayOpacity: 0.4,         
      tooltip: 'Add event',          
      elevation: 8.0,          
      animationSpeed: 200,          
      children: [
        SpeedDialChild(
          child: Icon(Icons.description),
          backgroundColor: ColorsPalette.juicyYellow,
          foregroundColor: ColorsPalette.lynxWhite,
          label: 'Note',
          onTap: () {},
        ),
        SpeedDialChild(
          child: Icon(Icons.train),
          backgroundColor: ColorsPalette.juicyOrange,
          foregroundColor: ColorsPalette.lynxWhite,
          label: 'Ticket',
          onTap: () {
            Navigator.pushNamed(context, ticketCreateRoute, arguments: args).then((value){
              //context.read<TripDetailsBloc>().add(UpdateTickets(trip!.id!));
            });
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.hotel),
          backgroundColor: ColorsPalette.juicyDarkBlue,
          foregroundColor: Colors.white,
          label: 'Booking',
          visible: true,
          onTap: () {
            Navigator.pushNamed(context, bookingCreateRoute, arguments: args).then((value){
              //context.read<TripDetailsBloc>().add(UpdateBookings(trip!.id!));
            });
          }
        ),
        SpeedDialChild(
          child: Icon(Icons.attach_money),
          backgroundColor: ColorsPalette.juicyGreen,
          foregroundColor: Colors.white,
          label: 'Expense',
          visible: true,
          onTap: () {
            Navigator.pushNamed(context, expenseCreateRoute, arguments: args).then((value){
              //context.read<TripDetailsBloc>().add(UpdateExpenses(trip!.id!));
            }); 
          }
        ),
        SpeedDialChild(
          child: Icon(Icons.assignment_turned_in),
          backgroundColor: ColorsPalette.juicyBlue,
          foregroundColor: Colors.white,
          label: 'Activity',
          visible: true,
          onTap: () {
            Navigator.pushNamed(context, activityCreateRoute, arguments: args).then((value){
              //context.read<TripDetailsBloc>().add(UpdateActivities(trip!.id!));
            });
          }
        ),
      ],
    );
  }
}