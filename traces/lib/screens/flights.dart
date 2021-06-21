import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/color_constants.dart';

class FlightsPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return new _FightsPageState();
  }
}

class _FightsPageState extends State<FlightsPage>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Flights',
          style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.lynxWhite, fontSize: 40.0))
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.only(left: 25.0, right: 25.0)),            
                    foregroundColor: MaterialStateProperty.all<Color>(ColorsPalette.sizzlingRed)
                  ),  
          child: Text('Go back!'),
        ),
      ),
    );
  }
}