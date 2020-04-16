import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../colorsPalette.dart';

class TripsPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return new _TripsPageState();
  }
}

class _TripsPageState extends State<TripsPage>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Trips',
          style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.grayLight, fontSize: 40.0))
        ),
        centerTitle: true,
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}