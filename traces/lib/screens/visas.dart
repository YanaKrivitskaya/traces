import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../colorsPalette.dart';

class VisasPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return new _VisasPageState();
  }
}

class _VisasPageState extends State<VisasPage>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Visas',
          style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.lynxWhite, fontSize: 40.0))
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