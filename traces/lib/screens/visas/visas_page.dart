import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traces/colorsPalette.dart';
import 'package:traces/screens/visas/visas_view.dart';

class VisasPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Visas', style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.lynxWhite, fontSize: 25.0))),
        //backgroundColor: ColorsPalette.mazarineBlue,
        backgroundColor: ColorsPalette.mazarineBlue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: VisasView(),
        floatingActionButton: FloatingActionButton(
          onPressed: (){},
          tooltip: 'Add New Visa',
          backgroundColor: ColorsPalette.algalFuel,
          child: Icon(Icons.add, color: ColorsPalette.lynxWhite),
        )
    );
  }
}
