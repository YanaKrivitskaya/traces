import 'package:flutter/material.dart';
import 'package:traces/constants.dart';
import 'package:traces/screens/expenses.dart';
import 'package:traces/screens/flights.dart';
import 'package:traces/screens/home.dart';
import 'package:traces/screens/hotels.dart';
import 'package:traces/screens/loginSignup.dart';
import 'package:traces/screens/map.dart';
import 'package:traces/screens/notes.dart';
import 'package:traces/screens/profile.dart';
import 'package:traces/screens/settings.dart';
import 'package:traces/screens/trips.dart';
import 'package:traces/screens/visas.dart';

class Router {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      homeRoute: (context) => HomePage(),
      tripsRoute: (context) => TripsPage(),
      mapRoute: (context) => MapPage(),
      notesRoute: (context) => NotesPage(),
      flightsRoute: (context) => FlightsPage(),
      expensesRoute: (context) => ExpensesPage(),
      hotelsRoute: (context) => HotelsPage(),
      visasRoute: (context) => VisasPage(),
      profileRoute: (context) => ProfilePage(),
      settingsRoute: (context) => SettingsPage(),
      loginSignupRoute: (context) => LoginSignupPage()
    };
  }
}