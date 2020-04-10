import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traces/colorsPalette.dart';
import 'package:traces/router.dart';

import 'home.dart';

void main() => runApp(TracesApp());

class TracesApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Traces',
      theme: ThemeData(
        primaryColor: ColorsPalette.mainColor,
        accentColor: ColorsPalette.iconColor,
        textTheme: GoogleFonts.quicksandTextTheme(Theme.of(context).textTheme)
      ),
      routes: Router.getRoutes(),
      home: HomePage(title: 'Traces'),
    );
  }
}
