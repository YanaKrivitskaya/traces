import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colorsPalette.dart';

class MapPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return new _MapPageState();
  }
}

class _MapPageState extends State<MapPage>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Map',
          style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.grayLight, fontSize: 40.0))
        ),
        centerTitle: true,
        backgroundColor: ColorsPalette.boyzone,
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