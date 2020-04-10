import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colorsPalette.dart';

class HotelsPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return new _HotelsPageState();
  }
}

class _HotelsPageState extends State<HotelsPage>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hotels',
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