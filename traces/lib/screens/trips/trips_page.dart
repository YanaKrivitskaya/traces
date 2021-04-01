import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../colorsPalette.dart';
import 'trips_view.dart';

class TripsPage extends StatelessWidget{
  TripsPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Trips', style: GoogleFonts.quicksand(textStyle: 
          TextStyle(color: ColorsPalette.lynxWhite, fontSize: 30.0))),
        leading: IconButton(
          icon: FaIcon(FontAwesomeIcons.arrowLeft, color: ColorsPalette.lynxWhite),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        backgroundColor: ColorsPalette.freshBlue,
      ),
      body: TripsView(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        tooltip: 'Add new Trip',
        backgroundColor: ColorsPalette.freshYellow,
        child: Icon(Icons.add, color: ColorsPalette.lynxWhite),
      ),      
    );
  }

  
}