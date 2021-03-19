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
        child: ElevatedButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.only(left: 25.0, right: 25.0)),
            backgroundColor: MaterialStateProperty.all<Color>(ColorsPalette.picoVoid),
            foregroundColor: MaterialStateProperty.all<Color>(ColorsPalette.lynxWhite)
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}