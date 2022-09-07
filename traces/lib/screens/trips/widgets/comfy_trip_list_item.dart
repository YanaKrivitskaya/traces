

import 'package:flutter/material.dart';
import 'package:traces/constants/color_constants.dart';
import 'package:traces/screens/trips/model/trip.model.dart';
import 'package:traces/utils/style/styles.dart';
import 'package:intl/intl.dart';

Widget comfyTripsListItem(Trip trip, BuildContext context) => Container(child: Stack(
    alignment: AlignmentDirectional.bottomCenter,
    children: [
      Container(
        padding: EdgeInsets.only(bottom: imageCoverPadding),
        child: trip.coverImage != null ? Image.memory(trip.coverImage!) : Image.asset("assets/sunset.jpg")                            
        ),
      Positioned(
        bottom: 0,
          child: Container(
            margin: EdgeInsets.all(sizerHeight),
            child: Material(
              elevation: 10.0,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color:  ColorsPalette.white,
              child: Container(
                margin: EdgeInsets.all(sizerHeight),
                width: MediaQuery.of(context).size.width * 0.6,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start ,children: [                                
                  Text(trip.name!, style: quicksandStyle(fontSize: fontSize, weight: FontWeight.bold)),
                  Text(trip.endDate!.isAfter(trip.startDate!) ? 
                    '${DateFormat.yMMMd().format(trip.startDate!)} - ${DateFormat.yMMMd().format(trip.endDate!)}' 
                    : '${DateFormat.yMMMd().format(trip.startDate!)}',  
                    style: quicksandStyle(fontSize: fontSizesm)),
                ],)
              )
            )
          )
      )
    ]
  ));