import 'package:flutter/material.dart';

class TripsView extends StatefulWidget{
  TripsView();
  State<TripsView> createState() => _TripsStateView();
}

class _TripsStateView extends State<TripsView>{

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('No trips', style: TextStyle(fontSize: 23.0))
      )
    );
  }

}