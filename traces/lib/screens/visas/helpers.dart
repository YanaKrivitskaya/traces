import 'package:flutter/material.dart';
import 'package:traces/constants/color_constants.dart';
import 'package:traces/screens/visas/model/visa_entry.model.dart';

import 'model/visa.model.dart';

Widget isActiveLabel(Visa visa) => new Text(
    isVisaActive(visa) ? 'Active' : 'Expired',
    style: TextStyle(color: isVisaActive(visa) ? ColorsPalette.algalFuel : ColorsPalette.carminePink, fontSize: 15.0, fontWeight: FontWeight.bold)
);

int daysLeft(Visa visa, List<VisaEntry> entries){
  int daysLeft = visa.durationOfStay!;

  int daysTillExpiration = visa.endDate!.difference(DateTime.now()).inDays;

  for (var entry in entries){
    daysLeft -= tripDuration(entry.entryDate, entry.exitDate);
  }

  int? days = -1;
  if(daysTillExpiration < daysLeft) days =  daysTillExpiration;
  else days = daysLeft;

  if(days < 0) return 0;

  return days;
}

String daysUsed(Visa visa, List<VisaEntry> entries){
  int daysUsed = 0;  

  for (var entry in entries){    
    daysUsed += tripDuration(entry.entryDate, entry.exitDate);
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
