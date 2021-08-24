import 'package:flutter/material.dart';
import 'package:traces/constants/color_constants.dart';
import 'package:traces/screens/trips/model/trip.model.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:traces/utils/style/styles.dart';
import '../../../widgets/widgets.dart';

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
        var days = trip.endDate!.difference(trip.startDate!).inDays + 1;
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
              indicatorStyle: const IndicatorStyle(
                width: 15,
                color: /*Color(0xFF27AA69)*/ColorsPalette.juicyYellow,
                padding: EdgeInsets.all(3),
              ),
              startChild: Text('Day ${position+1}'),
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
      
      var hasBooking = trip.bookings?.where((b) => 
        b.entryDate != null && b.exitDate != null  &&
        (b.entryDate!.isBefore(date) || b.entryDate!.isSameDate(date)) &&
        (b.exitDate!.isAfter(date) || b.exitDate!.isSameDate(date))
      ).isNotEmpty;

      var hasActivity = trip.activities?.where((a) => 
        a.date != null && a.date!.isSameDate(date)
      ).isNotEmpty;

      var hasExpense = trip.expenses?.where((e) => 
        e.date != null && e.date!.isSameDate(date)
      ).isNotEmpty;

      var tickets = trip.tickets?.where((t) => 
         t.departureDatetime != null && t.departureDatetime  != null  &&
        (t.departureDatetime !.isBefore(date) || t.departureDatetime !.isSameDate(date)) &&
        (t.arrivalDatetime!.isAfter(date) || t.arrivalDatetime!.isSameDate(date))
      ).toList();

      return Container(child: Card(
        child: Container(
          constraints: const BoxConstraints(
            minHeight: 60,
          ),
          padding: EdgeInsets.all(10.0),        
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
            Text('${DateFormat.E().format(date)}, ${DateFormat.yMMMd().format(date)}', style: quicksandStyle(fontSize: 16.0,)),
            SizedBox(height: 3.0,),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              hasBooking != null && hasBooking ? Icon(Icons.home, color: ColorsPalette.juicyBlue,) : Container(),
              tickets != null && tickets.length > 0 ? Icon(Icons.flight, color: ColorsPalette.juicyGreen,): Container(),
              hasActivity != null && hasActivity ? Icon(Icons.event_available, color: ColorsPalette.juicyOrange): Container(),
              hasExpense != null && hasExpense ? Icon(Icons.attach_money, color: ColorsPalette.juicyYellow): Container()
            ],)
          ],)),
      ));
       
    }

}