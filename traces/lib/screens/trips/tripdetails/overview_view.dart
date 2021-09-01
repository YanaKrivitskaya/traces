 import 'package:flutter/material.dart';
import 'package:traces/constants/color_constants.dart';

import '../../../utils/style/styles.dart';
import '../model/trip.model.dart';
import '../../../widgets/widgets.dart';

tripDetailsOverview(Trip trip, BuildContext context) {
  var today = DateTime.now();
  var dayNumber;
  var daysLeft;
  if((trip.startDate!.isBefore(today) || trip.startDate!.isSameDate(today)) && (trip.endDate!.isAfter(today) || trip.endDate!.isSameDate(today))){
    dayNumber = daysBetween(trip.startDate!, today);
  }else{
    daysLeft =  daysBetween(today, trip.startDate!);
  }
  return Container(child: Row(
    children: [
      Column(children: [
        Container(                 
          margin: EdgeInsets.all(10.0),
          child: SingleChildScrollView(child: Column(children: [
          Column(           
            crossAxisAlignment: CrossAxisAlignment.start, children: [
              trip.description!= null ? 
              Container(width: MediaQuery.of(context).size.width * 0.9, child: Text('${trip.description}', style: quicksandStyle(fontSize: 16.0),),) : Container()
          ])
        ],))
        ),
        daysLeft != null ?
        Expanded(child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          margin: EdgeInsets.all(10.0),          
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('Trip starts in', style: quicksandStyle(fontSize: 25.0)),
              Text('$daysLeft', style: quicksandStyle(fontSize: 30.0, color: ColorsPalette.juicyOrange)),
              Text('days', style: quicksandStyle(fontSize: 25.0))
            ],)
          ],),
        ),) : Container(),
        dayNumber != null ?
        Expanded(child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          margin: EdgeInsets.all(10.0),          
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Row(children: [
                Text('Today is the ', style: quicksandStyle(fontSize: 25.0)),
                Text('$dayNumber ', style: quicksandStyle(fontSize: 30.0, color: ColorsPalette.juicyOrange)),
                Text('day of the trip', style: quicksandStyle(fontSize: 25.0))
              ],)              
            ],)
          ],),
        ),) : Container() 
      ],),      
    ]));
}