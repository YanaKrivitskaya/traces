import 'package:flutter/material.dart';

import '../../../utils/style/styles.dart';

Widget headerAppbarWidget(String tripName, BuildContext context) => new Container(
  padding: EdgeInsets.only(top: 35.0, left: 10.0),
  child: Row(
  children: [
    InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.arrow_back)),
    Expanded(child: Center(child: 
      Text(tripName, style: quicksandStyle(fontSize: 18.0, weight: FontWeight.bold))
    )),
  ],
),
  /*child: Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center, children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center, children: [
          InkWell(
            onTap: (){Navigator.pop(context);},
            child: Icon(Icons.arrow_back)
          ),
    ]), 
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text(tripName, style: quicksandStyle(fontSize: 18.0, weight: FontWeight.bold)),
            ),
          ]
        )
      )
    ])*/
);