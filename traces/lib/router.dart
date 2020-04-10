import 'package:flutter/material.dart';
import 'package:traces/constants.dart';
import 'package:traces/expenses.dart';
import 'package:traces/flights.dart';
import 'package:traces/hotels.dart';
import 'package:traces/map.dart';
import 'package:traces/notes.dart';
import 'package:traces/profile.dart';
import 'package:traces/settings.dart';
import 'package:traces/trips.dart';
import 'package:traces/visas.dart';

class Router {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      //homeRoute: (context) => HomePage(),
      tripsRoute: (context) => TripsPage(),
      mapRoute: (context) => MapPage(),
      notesRoute: (context) => NotesPage(),
      flightsRoute: (context) => FlightsPage(),
      expensesRoute: (context) => ExpensesPage(),
      hotelsRoute: (context) => HotelsPage(),
      visasRoute: (context) => VisasPage(),
      profileRoute: (context) => ProfilePage(),
      settingsRoute: (context) => SettingsPage(),
    };
  }
}