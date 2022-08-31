
import 'package:flutter/material.dart';
import 'package:traces/constants/color_constants.dart';
import 'package:traces/screens/trips/model/ticket.model.dart';
import 'package:traces/screens/trips/model/trip_object.model.dart';
import 'package:traces/widgets/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget getObjectIcon(TripEventType type, dynamic event) {    
    switch (type){
      case TripEventType.Activity:
        return Icon(Icons.calendar_month, color: ColorsPalette.juicyOrange);        
      case TripEventType.Booking:
        return Icon(Icons.home, color: ColorsPalette.juicyGreen);       
      case TripEventType.Ticket:
        return transportIcon((event as Ticket).type, ColorsPalette.juicyBlue);       
      default:
        return SizedBox(height:0);
    }
  }

List<TripEvent> sortObjects(List<TripEvent> objects) {
    objects.sort((a, b) {
      var aDate = a.startDate?.millisecondsSinceEpoch ?? a.endDate?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch;
      var bDate = b.startDate?.millisecondsSinceEpoch ?? b.endDate?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch;
      return aDate
          .compareTo(bDate);
    });
    return objects;
  }