import 'package:flutter/material.dart';
import 'package:traces/colorsPalette.dart';
import 'package:traces/screens/visas/model/entryExit.dart';
import 'package:traces/screens/visas/model/visa.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget isActiveLabel(Visa visa) => new Text(
    isVisaActive(visa) ? 'Active' : 'Expired',
    style: TextStyle(color: isVisaActive(visa) ? ColorsPalette.algalFuel : ColorsPalette.carminePink, fontSize: 15.0, fontWeight: FontWeight.bold)
);

Widget transportIcon(String transport) => new Container(
    child: transport == 'Train' ? FaIcon(FontAwesomeIcons.train, color: ColorsPalette.mazarineBlue)
        : transport == 'Plane' ? FaIcon(FontAwesomeIcons.plane, color: ColorsPalette.mazarineBlue)
        : transport =='Car/Bus' ? FaIcon(FontAwesomeIcons.car, color: ColorsPalette.mazarineBlue)
        : transport == 'Ship' ? FaIcon(FontAwesomeIcons.ship, color: ColorsPalette.mazarineBlue)
        : transport == 'On foot' ? FaIcon(FontAwesomeIcons.walking, color: ColorsPalette.mazarineBlue)
        : Container()
);

String daysLeft(Visa visa, List<EntryExit> entries){
  int daysLeft = visa.durationOfStay;

  int daysTillExpiration = visa.endDate.difference(DateTime.now()).inDays;

  for (var entry in entries){
    var duration = 0;
    if(entry.hasExit){
      duration = entry.exitDate.difference(entry.entryDate).inDays;
    }else{
      duration = DateTime.now().difference(entry.entryDate).inDays;
    }

    daysLeft -=duration;
  }
  if(daysTillExpiration < daysLeft) return daysTillExpiration.toString();

  return daysLeft.toString();
}

String daysUsed(Visa visa, List<EntryExit> entries){
  int daysUsed = 0;  

  for (var entry in entries){    
    if(entry.hasExit){
      daysUsed = entry.exitDate.difference(entry.entryDate).inDays;
    }else{
      daysUsed = DateTime.now().difference(entry.entryDate).inDays;
    }    
  } 

  return daysUsed.toString();
}

bool isVisaActive(Visa visa){
  var currentDate = DateTime.now();
  if(visa.endDate.difference(currentDate).inDays > 1) return true;
  return false;
}

String visaDuration(Visa visa){
  var visaDays = visa.endDate.difference(visa.startDate).inDays;
  if(visaDays > 30) return (visaDays / 30).toStringAsFixed(0) + " months";
  else return visaDays.toString() + " days";
}

String tripDuration(DateTime start, DateTime end){
  if(end == null) end = DateTime.now();
  var tripDuration = end.difference(start).inDays;
  if(tripDuration > 30) return (tripDuration / 30).toStringAsFixed(0) + " months";
  else return tripDuration.toString() + " days";
}
