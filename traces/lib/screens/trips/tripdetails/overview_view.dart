 import 'package:flutter/material.dart';
import 'package:traces/constants/color_constants.dart';
import 'package:traces/screens/trips/model/expense.model.dart';

import '../../../utils/style/styles.dart';
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
  } else if (trip.startDate!.isAfter(today) && trip.endDate!.isAfter(today)){
    daysLeft = daysBetween(today, trip.startDate!);
  }
  else{
      tripFinished = true;
  }

  List<String> expenseList = [];
  List<String> plannedExpenseList = [];
  if(trip.expenses != null){
    Map<String, List<Expense>> expenses = trip.expenses!.groupListsBy((element) => element.currency!);

    expenses.forEach((key, group) {
      double sum = 0.0;
      double sumPlanned = 0.0;
      group.forEach((expense) {
        if(expense.isPaid != null && expense.isPaid!){
          sum += expense.amount!;
        } else{
          sumPlanned += expense.amount!;
        }        
      });
      sum > 0 ? expenseList.add(sum.toStringAsFixed(2) + ' ' + key) : null;
      sumPlanned > 0 ? plannedExpenseList.add(sumPlanned.toStringAsFixed(2) + ' ' + key) : null;
    });      
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
        Container(child: Container(
          //color: ColorsPalette.exodusFruit,
          width: MediaQuery.of(context).size.width * 0.9,
          margin: EdgeInsets.all(10.0),          
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text('Trip starts in ', style: quicksandStyle(fontSize: 25.0)),
                Text('$daysLeft', style: quicksandStyle(fontSize: 30.0, color: ColorsPalette.juicyOrange)),
                Text(' days', style: quicksandStyle(fontSize: 25.0))
            ],)
            ],)            
          ],),
        ),) : Container(),
        dayNumber != null ?
        Container(child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          margin: EdgeInsets.all(10.0),          
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Row(children: [
                Text('Today is the ', style: quicksandStyle(fontSize: fontSize)),
                Text('$dayNumber ', style: quicksandStyle(fontSize: accentFontSize, color: ColorsPalette.juicyOrange)),
                Text('day of the trip', style: quicksandStyle(fontSize: fontSize))
              ],)              
            ],)
          ],),
        ),) : Container(),
        tripFinished ? 
        Container(
          child: Container(            
            width: MediaQuery.of(context).size.width * 0.9,
            margin: EdgeInsets.all(10.0),          
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Row(children: [
                  Text('Trip has finished!', style: quicksandStyle(fontSize: 25.0)),
                ],)              
              ],)
            ],),
        )
        ): Container(),
        expenseList.length > 0 ? Expanded(
          child: Container(
            //color: ColorsPalette.beekeeper,
            width: MediaQuery.of(context).size.width * 0.9,
            margin: EdgeInsets.all(10.0),            
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Total spent:', style: quicksandStyle(fontSize: 20.0, color: ColorsPalette.juicyOrange))                
              ],),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                for(var expense in expenseList) Text(expense, style: quicksandStyle(fontSize: 18.0))
              ],)
            ],)
          ),
        ) : Container(),
        plannedExpenseList.length > 0 ? Expanded(
          child: Container(
            //color: ColorsPalette.beekeeper,
            width: MediaQuery.of(context).size.width * 0.9,
            margin: EdgeInsets.all(10.0),            
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Planned expenses:', style: quicksandStyle(fontSize: 20.0, color: ColorsPalette.juicyOrange, decoration: tripFinished ? TextDecoration.lineThrough : null))                
              ],),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                for(var expense in plannedExpenseList) Text(expense, style: quicksandStyle(fontSize: 18.0, decoration: tripFinished ? TextDecoration.lineThrough : null))
              ],)
            ],)
          ),
        ) : Container()
      ],),      
    ]));
}