
import 'package:flutter/material.dart';
import 'package:traces/constants/color_constants.dart';
import 'package:traces/screens/trips/model/ticket.model.dart';
import 'package:traces/screens/trips/model/trip.model.dart';
import 'package:traces/screens/trips/model/trip_day.model.dart';
import 'package:traces/screens/trips/model/trip_object.model.dart';
import 'package:traces/widgets/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget getObjectIcon(TripEventType type, dynamic event) {    
    switch (type){
      case TripEventType.Activity:
        return FaIcon(FontAwesomeIcons.calendarAlt, color: ColorsPalette.juicyOrange);        
      case TripEventType.Booking:
        return FaIcon(FontAwesomeIcons.home, color: ColorsPalette.juicyGreen);       
      case TripEventType.Ticket:
        return transportIcon((event as Ticket).type, ColorsPalette.juicyBlue);       
      default:
        return Container();
    }
  }