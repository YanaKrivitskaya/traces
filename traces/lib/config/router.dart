import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constants/route_constants.dart';
import '../screens/expenses.dart';
import '../screens/home.dart';
import '../screens/hotels.dart';
import '../screens/map.dart';
import '../screens/notes/bloc/note_bloc/bloc.dart';
import '../screens/notes/bloc/note_details_bloc/bloc.dart';
import '../screens/notes/bloc/tag_filter_bloc/bloc.dart';
import '../screens/notes/screens/note_detail_view.dart';
import '../screens/notes/screens/note_page.dart';
import '../screens/profile/bloc/profile/bloc.dart';
import '../screens/profile/profile_page.dart';
import '../screens/settings/bloc/settings_bloc.dart';
import '../screens/settings/settings_page.dart';
import '../screens/settings/themes_settings_view.dart';
import '../screens/trips/bloc/trips_bloc.dart';
import '../screens/trips/start_planning/bloc/startplanning_bloc.dart';
import '../screens/trips/start_planning/start_planning_view.dart';
import '../screens/trips/tripdetails/bloc/tripdetails_bloc.dart';
import '../screens/trips/tripdetails/tripdetails_view.dart';
import '../screens/trips/trips_page.dart';
import '../screens/visas/bloc/visa/visa_bloc.dart';
import '../screens/visas/bloc/visa_details/visa_details_bloc.dart';
import '../screens/visas/bloc/visa_tab/visa_tab_bloc.dart';
import '../screens/visas/visa_details_view.dart';
import '../screens/visas/visa_edit_view.dart';
import '../screens/visas/visas_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case homeRoute:       
        return MaterialPageRoute(
          builder: (_) => BlocProvider<SettingsBloc>(
            create: (context) =>
                SettingsBloc(/*settingsRepository: FirebaseAppSettingsRepository()*/),
            child: HomePage(),
          ),
      );
      case notesRoute:
      return MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
                      providers: [                       
                        BlocProvider<TagFilterBloc>(
                          create: (context) => TagFilterBloc(),
                        ),
                         BlocProvider<NoteBloc>(
                          create: (context) => NoteBloc()..add(GetAllNotes())
                        ),
                      ],
                      child: NotesPage(),
                    )
      );
      case noteDetailsRoute:
        {
          if (args is int) {
            return MaterialPageRoute(
                builder: (_) => MultiBlocProvider(
                      providers: [
                        BlocProvider<NoteDetailsBloc>(
                          create: (context) => NoteDetailsBloc()..add(args != 0
                              ? GetNoteDetails(args)
                              : NewNoteMode()),
                        ),
                        BlocProvider<TagFilterBloc>(
                          create: (context) => TagFilterBloc()..add(GetTags()),
                        ),
                      ],
                      child: NoteDetailsView(),
                    ));
          }
          return _errorRoute();
        }
    case profileRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<ProfileBloc>(
            create: (context) =>
                ProfileBloc(),
            child: ProfilePage(),
          ),
        );
      case settingsRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<SettingsBloc>(
            create: (context) =>
                SettingsBloc(),
            child: SettingsPage(),
          ),
      );
      case themeSettingsRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<SettingsBloc>(
            create: (context) =>
                SettingsBloc()
                  ..add(GetAppSettings()),
            child: ThemeSettingsView(),
          ),
      );
      case visasRoute:
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider<VisaTabBloc>(
                        create: (context) => VisaTabBloc()),
                    BlocProvider<VisaBloc>(
                      create: (context) => VisaBloc()..add(GetAllVisas()),
                    ),
                  ],
                  child: VisasPage(),
                ));
      case visaDetailsRoute:
        {
          if (args is int) {
            return MaterialPageRoute(
              builder: (_) => BlocProvider<VisaDetailsBloc>(
                create: (context) => VisaDetailsBloc()
                  ..add(GetVisaDetails(args)),
                child: VisaDetailsView(),
              ),
            );
          }
          return _errorRoute();
        }
      case visaEditRoute:
        {
          if (args is int) {
            return MaterialPageRoute(
              builder: (_) => BlocProvider<VisaDetailsBloc>(
                create: (context) => VisaDetailsBloc()
                  ..add(args != 0 ? EditVisaClicked(args) : NewVisaMode()),
                child: VisaEditView(visaId: args),
              ),
            );
          }
          return _errorRoute();
        }        
      case tripsRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<TripsBloc>(
            create: (context) =>
                TripsBloc()..add(GetAllTrips()),
            child: TripsPage(),
          ),
      );
      case tripStartPlanningRoute:
      {
        return MaterialPageRoute(
            builder: (_) => BlocProvider<StartPlanningBloc>(
              create: (context) => StartPlanningBloc(
                  /*FirebaseTripsRepository()*/)
                ..add(NewTripMode()),
              child: StartPlanningView(),
            ),
          );
      }      
      case tripDetailsRoute:
        {
          if (args is int) {
            return MaterialPageRoute(
              builder: (_) => BlocProvider<TripDetailsBloc>(
                create: (context) => TripDetailsBloc()..add(GetTripDetails(args)),
                child: TripDetailsView(tripId: args),
              ),
            );
          }
          return _errorRoute();
        }
      case expensesRoute:
        return MaterialPageRoute(builder: (_) => ExpensesPage());
      case hotelsRoute:
        return MaterialPageRoute(builder: (_) => HotelsPage());
      case mapRoute:
        return MaterialPageRoute(builder: (_) => MapPage());
      default:
        return _errorRoute();
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
