import 'package:flutter/material.dart';

import '../../../utils/style/styles.dart';
import '../model/trip.model.dart';

tripDetailsOverview(Trip trip) => Container(child: Row(
  mainAxisAlignment: MainAxisAlignment.start, children: [
    Container(                    
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Description:', style: quicksandStyle(fontSize: 18.0, weight: FontWeight.bold)),
          Text('${trip.description}', style: quicksandStyle(fontSize: 15.0),),
        ])
    )
  ]));