 import 'package:flutter/material.dart';
import 'package:traces/constants/color_constants.dart';
import 'package:traces/screens/trips/model/expense.model.dart';
import 'package:traces/screens/trips/widgets/trip_helpers.dart';

import '../../../utils/style/styles.dart';
import '../model/ticket.model.dart';
import '../model/trip.model.dart';
import '../../../widgets/widgets.dart';
import 'package:collection/collection.dart';

tripDetailsOverview(Trip trip, BuildContext context) {
  var today = DateTime.now();
  var dayNumber;
  var daysLeft;
  bool tripFinished = false;
  if((trip.startDate!.isBefore(today) || trip.startDate!.isSameDate(today)) && (trip.endDate!.isAfter(today) || trip.endDate!.isSameDate(today))){
    dayNumber = daysBetween(trip.startDate!, today);
    if(trip.startDate!.isSameDate(today)) dayNumber = 1;
  } else if (trip.startDate!.isAfter(today) && trip.endDate!.isAfter(today)){
    daysLeft = daysBetween(today, trip.startDate!);
  }
  else{
      tripFinished = true;
  } 

  int nights = daysBetween(trip.startDate!, trip.endDate!);
  int days = daysBetween(trip.startDate!, trip.endDate!) + 1;

  int bookedNights = 0;

  trip.bookings?.forEach((b) {
    bookedNights += daysBetween(b.entryDate!, b.exitDate!);
  });

  Map<String, List<Ticket>> tickets = trip.tickets!.groupListsBy((element) => element.type!);     

  Map<String, int> ticketsByType = new Map();

   tickets.forEach((key, group) {
      ticketsByType[key] = group.length;
   });   
  
  return Container(child: Row(
    children: [
      Column(children: [
        Container(                 
          //margin: EdgeInsets.all(10.0),
          child: SingleChildScrollView(child: Column(children: [
          Column(           
            crossAxisAlignment: CrossAxisAlignment.start, children: [
              trip.description!= null ? 
              Container(width: MediaQuery.of(context).size.width * 0.9, child: Text('${trip.description}', style: quicksandStyle(fontSize: 16.0),),) : SizedBox(height:0)
          ])
        ],))
        ),        
        daysLeft != null ?
        Container(child: Container(
          //color: ColorsPalette.exodusFruit,
          width: MediaQuery.of(context).size.width * 0.9,
          //margin: EdgeInsets.all(10.0),          
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text('Trip starts in ', style: quicksandStyle(fontSize: fontSize)),
                Text('$daysLeft', style: quicksandStyle(fontSize: accentFontSize, color: ColorsPalette.juicyOrange)),
                Text(' day(s)', style: quicksandStyle(fontSize: fontSize))
            ],)
            ],)            
          ],),
        ),) : SizedBox(height:0),
        dayNumber != null ?
        Container(child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          //margin: EdgeInsets.all(10.0),          
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Row(children: [
                Text('Today is the ', style: quicksandStyle(fontSize: fontSize)),
                Text('${dayNumber + 1} ', style: quicksandStyle(fontSize: accentFontSize, color: ColorsPalette.juicyOrange)),
                Text('day of the trip', style: quicksandStyle(fontSize: fontSize))
              ],)              
            ],)
          ],),
        ),) : SizedBox(height:0),
        tripFinished ? 
        Container(
          child: Container(            
            width: MediaQuery.of(context).size.width * 0.9,
            //margin: EdgeInsets.all(10.0),          
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Row(children: [
                  Text('Trip has finished', style: quicksandStyle(fontSize: fontSize)),
                ],)              
              ],)
            ],),
        )
        ): SizedBox(height:0),
        Divider(color: ColorsPalette.juicyYellow),        
        Expanded(
          child: Container(            
            width: MediaQuery.of(context).size.width * 0.8,
            margin: EdgeInsets.all(10.0),            
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                days > 0 ? Container(
                  child: Row(children: [
                    Text('$days days, $nights nights', style: quicksandStyle(fontSize: fontSize)),
                  ],)
                ) : SizedBox(height:0),
                SizedBox(height: sizerHeight),
                trip.bookings != null && trip.bookings!.length > 0 ?Row(children: [
                  Icon(Icons.home, color: ColorsPalette.amMint,),
                  SizedBox(width: sizerWidthMd),
                  Text("${trip.bookings!.length}" , style: quicksandStyle(fontSize: fontSize)),
                  SizedBox(width: sizerWidthMd),
                  Text("($bookedNights nights)", style: quicksandStyle(fontSize: fontSize)),
                ],) :SizedBox(height:0),
                SizedBox(height: sizerHeight),
                Row(children: [                 
                  for(var ticketType in ticketsByType.entries) Row(children: [                    
                    transportIcon(ticketType.key, ColorsPalette.amMint),
                    SizedBox(width: sizerWidthMd),
                    Text(ticketType.value.toString(), style: quicksandStyle(fontSize: fontSize)),
                    SizedBox(width: sizerWidthMd)
                  ],)
                ],),
              ],)
            ],)
          ),
        )        
      ],),      
    ]));
}