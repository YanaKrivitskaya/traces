import 'package:flutter/material.dart';
import 'package:traces/constants.dart';
import 'package:traces/screens/expenses.dart';
import 'package:traces/screens/flights.dart';
import 'package:traces/screens/home.dart';
import 'package:traces/screens/hotels.dart';
import 'package:traces/screens/loginSignup.dart';
import 'package:traces/screens/map.dart';
import 'package:traces/screens/notes/note-detail.dart';
import 'package:traces/screens/notes/notes.dart';
import 'package:traces/screens/profile.dart';
import 'package:traces/screens/settings.dart';
import 'package:traces/screens/trips.dart';
import 'package:traces/screens/visas.dart';

/*class Router {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      homeRoute: (context) => HomePage(),
      tripsRoute: (context) => TripsPage(),
      mapRoute: (context) => MapPage(),
      notesRoute: (context) => NotesPage(),
      noteDetailsRoute: (context) => NoteDetailsPage(),
      flightsRoute: (context) => FlightsPage(),
      expensesRoute: (context) => ExpensesPage(),
      hotelsRoute: (context) => HotelsPage(),
      visasRoute: (context) => VisasPage(),
      profileRoute: (context) => ProfilePage(),
      settingsRoute: (context) => SettingsPage(),
      loginSignupRoute: (context) => LoginSignupPage()
    };
  }
}*/

class RouteGenerator{
  static Route<dynamic> generateRoute(RouteSettings settings){
    final args = settings.arguments;

    switch(settings.name){
      case homeRoute: return MaterialPageRoute(builder: (_) => HomePage());
      case notesRoute: return MaterialPageRoute(builder: (_) => NotesPage());
      case noteDetailsRoute: {
        if(args is String){
          return MaterialPageRoute(builder: (_) => NoteDetailsPage(noteId: args));
        }
        return _errorRoute();
      }
      case loginSignupRoute: return MaterialPageRoute(builder: (_) => LoginSignupPage());
      default: return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Oops'),
        ),
        body: Center(
          child: Text('Something went wrong'),
        ),
      );
    });
  }

}