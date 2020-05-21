import 'package:flutter/material.dart';
import 'package:traces/constants.dart';
import 'package:traces/screens/expenses.dart';
import 'package:traces/screens/flights.dart';
import 'package:traces/screens/home.dart';
import 'package:traces/screens/hotels.dart';
import 'package:traces/screens/map.dart';
import 'package:traces/screens/notes/bloc/note_bloc/bloc.dart';
import 'package:traces/screens/notes/note_detail_view.dart';
import 'package:traces/screens/notes/note_page.dart';
import 'package:traces/screens/notes/repository/firebase_notes_repository.dart';
import 'package:traces/screens/profile/profile_page.dart';
import 'package:traces/screens/settings.dart';
import 'package:traces/screens/trips.dart';
import 'package:traces/screens/visas.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screens/notes/bloc/note_details_bloc/bloc.dart';
import 'screens/notes/bloc/tag_filter_bloc/bloc.dart';

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
      case notesRoute: return MaterialPageRoute(builder: (_) =>
          BlocProvider<NoteBloc>(
            create: (context) => NoteBloc(notesRepository: FirebaseNotesRepository(),
            ),
            child: NotesPage(),
          ),
      );
      case noteDetailsRoute: {
        if(args is String){
          return MaterialPageRoute(builder: (_) =>
              MultiBlocProvider(
                providers: [
                  BlocProvider<NoteDetailsBloc>(
                    create: (context) => NoteDetailsBloc(notesRepository: FirebaseNotesRepository(),
                    )..add(args != '' ? GetNoteDetails(args) : NewNoteMode()),
                  ),
                  BlocProvider<TagFilterBloc>(
                    create: (context) => TagFilterBloc(notesRepository: FirebaseNotesRepository(),
                    )..add(GetTags()),
                  ),
                ],
                child: NoteDetailsView(),
              ));
        }
        return _errorRoute();
      }
      case profileRoute: return MaterialPageRoute(builder: (_) => ProfilePage());
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