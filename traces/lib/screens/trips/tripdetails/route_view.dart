import 'package:flutter/material.dart';
import 'package:traces/screens/trips/model/trip.model.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';

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
        return Container(child: ListView.builder(
          shrinkWrap: true,         
          itemCount: days,
          itemBuilder: (context, position){            
            return TimelineTile(
              alignment: TimelineAlign.manual,
              lineXY: 0.1,
              isFirst: position == 0,
              isLast: position == days - 1,
              indicatorStyle: const IndicatorStyle(
                width: 20,
                color: Color(0xFF27AA69),
                padding: EdgeInsets.all(6),
              ),
              endChild: Card(child: Text('Day ${position + 1} - ${DateFormat.yMMMd().format(trip.startDate!.add(Duration(days: position)))}'),),
              beforeLineStyle: const LineStyle(
                color: Color(0xFF27AA69),
              ),
            );
          }
        )
        );
      }

}