import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../colorsPalette.dart';

class ExpensesPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return new _ExpensesPageState();
  }
}

class _ExpensesPageState extends State<ExpensesPage>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Expenses',
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