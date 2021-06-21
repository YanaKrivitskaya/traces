import 'package:flutter/material.dart';
import 'package:traces/constants/color_constants.dart';
import 'package:traces/screens/visas/model/entryExit.dart';
import 'package:traces/screens/visas/model/visa.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget isActiveLabel(Visa visa) => new Text(
    isVisaActive(visa) ? 'Active' : 'Expired',
    style: TextStyle(color: isVisaActive(visa) ? ColorsPalette.algalFuel : ColorsPalette.carminePink, fontSize: 15.0, fontWeight: FontWeight.bold)
);

Widget transportIcon(String? transport) => new Container(
    child: transport == 'Train' ? FaIcon(FontAwesomeIcons.train, color: ColorsPalette.mazarineBlue)
        : transport == 'Plane' ? FaIcon(FontAwesomeIcons.plane, color: ColorsPalette.mazarineBlue)
        : transport =='Car/Bus' ? FaIcon(FontAwesomeIcons.car, color: ColorsPalette.mazarineBlue)
        : transport == 'Ship' ? FaIcon(FontAwesomeIcons.ship, color: ColorsPalette.mazarineBlue)
        : transport == 'On foot' ? FaIcon(FontAwesomeIcons.walking, color: ColorsPalette.mazarineBlue)
        : Container()
);

int daysLeft(Visa visa, List<EntryExit> entries){
  int daysLeft = visa.durationOfStay!;

  int daysTillExpiration = visa.endDate!.difference(DateTime.now()).inDays;

  for (var entry in entries){
    daysLeft -= entry.duration!;
  }

  int? days = -1;
  if(daysTillExpiration < daysLeft!) days =  daysTillExpiration;
  else days = daysLeft;

  if(days < 0) return 0;

  return days;
}

String daysUsed(Visa visa, List<EntryExit> entries){
  int daysUsed = 0;  

  for (var entry in entries){    
    daysUsed += entry.duration!;
  }
  return daysUsed.toString();
}

bool isVisaActive(Visa visa){
  var currentDate = DateTime.now();
  if(visa.endDate!.difference(currentDate).inDays > 1) return true;
  return false;
}

String visaDuration(Visa visa){
  var visaDays = visa.endDate!.difference(visa.startDate!).inDays;
  if(visaDays > 30) return (visaDays / 30).toStringAsFixed(0) + " months";
  else return visaDays.toString() + " days";
}

int tripDuration(DateTime start, DateTime? end){
  if(end == null) end = DateTime.now();
  var tripDuration = end.difference(start).inDays; 

  return tripDuration+=1;
}
