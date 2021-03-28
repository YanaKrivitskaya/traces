import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'constants.dart';
import 'screens/expenses.dart';
import 'screens/home.dart';
import 'screens/hotels.dart';
import 'screens/map.dart';
import 'screens/notes/bloc/note_bloc/bloc.dart';
import 'screens/notes/bloc/note_details_bloc/bloc.dart';
import 'screens/notes/bloc/tag_filter_bloc/bloc.dart';
import 'screens/notes/note_detail_view.dart';
import 'screens/notes/note_page.dart';
import 'screens/notes/repository/firebase_notes_repository.dart';
import 'screens/profile/bloc/profile/bloc.dart';
import 'screens/profile/profile_page.dart';
import 'screens/profile/repository/firebase_profile_repository.dart';
import 'screens/settings/bloc/settings_bloc.dart';
import 'screens/settings/repository/firebase_appSettings_repository.dart';
import 'screens/settings/settings_page.dart';
import 'screens/settings/themes_settings_view.dart';
import 'screens/trips.dart';
import 'screens/visas/bloc/entry_exit/entry_exit_bloc.dart';
import 'screens/visas/bloc/visa/visa_bloc.dart';
import 'screens/visas/bloc/visa_details/visa_details_bloc.dart';
import 'screens/visas/bloc/visa_tab/visa_tab_bloc.dart';
import 'screens/visas/entry_exit_details_view.dart';
import 'screens/visas/repository/firebase_visas_repository.dart';
import 'screens/visas/visa_details_view.dart';
import 'screens/visas/visa_edit_view.dart';
import 'screens/visas/visas_page.dart';

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

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(
          builder: (_) => HomePage()
        );
        //return MaterialPageRoute(builder: (_) => HomePage());
      case notesRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<NoteBloc>(
            create: (context) =>
                NoteBloc(notesRepository: FirebaseNotesRepository()),
            child: NotesPage(),
          ),
        );
      case noteDetailsRoute:
        {
          if (args is String) {
            return MaterialPageRoute(
                builder: (_) => MultiBlocProvider(
                      providers: [
                        BlocProvider<NoteDetailsBloc>(
                          create: (context) => NoteDetailsBloc(
                            notesRepository: FirebaseNotesRepository(),
                          )..add(args != ''
                              ? GetNoteDetails(args)
                              : NewNoteMode()),
                        ),
                        BlocProvider<TagFilterBloc>(
                          create: (context) => TagFilterBloc(
                            notesRepository: FirebaseNotesRepository(),
                          )..add(GetTags()),
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
                ProfileBloc(profileRepository: FirebaseProfileRepository()),
            child: ProfilePage(),
          ),
        );
      case settingsRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<SettingsBloc>(
            create: (context) =>
                SettingsBloc(settingsRepository: FirebaseAppSettingsRepository()),
            child: SettingsPage(),
          ),
      );
      case themeSettingsRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<SettingsBloc>(
            create: (context) =>
                SettingsBloc(settingsRepository: FirebaseAppSettingsRepository())
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
                      create: (context) => VisaBloc(
                        visasRepository: FirebaseVisasRepository(),
                      )..add(GetAllVisas()),
                    ),
                  ],
                  child: VisasPage(),
                ));
      case visaDetailsRoute:
        {
          if (args is String) {
            return MaterialPageRoute(
              builder: (_) => BlocProvider<VisaDetailsBloc>(
                create: (context) => VisaDetailsBloc(
                    visasRepository: FirebaseVisasRepository(),
                    profileRepository: FirebaseProfileRepository())
                  ..add(GetVisaDetails(args)),
                child: VisaDetailsView(),
              ),
            );
          }
          return _errorRoute();
        }
      case visaEditRoute:
        {
          if (args is String) {
            return MaterialPageRoute(
              builder: (_) => BlocProvider<VisaDetailsBloc>(
                create: (context) => VisaDetailsBloc(
                    visasRepository: FirebaseVisasRepository(),
                    profileRepository: FirebaseProfileRepository())
                  ..add(args != '' ? EditVisaClicked(args) : NewVisaMode()),
                child: VisaEditView(visaId: args),
              ),
            );
          }
          return _errorRoute();
        }
      case visaAddEntryRoute:
        {
          if (args is String) {
            return MaterialPageRoute(
              builder: (_) => BlocProvider<EntryExitBloc>(
                create: (context) => EntryExitBloc(
                    visasRepository:
                        FirebaseVisasRepository()) /*..add(args != '' ? EditVisaClicked(args) : NewVisaMode())*/,
                child: EntryExitDetailsView(/*entryId: args*/),
              ),
            );
          }
          return _errorRoute();
        }
      case tripsRoute:
        return MaterialPageRoute(builder: (_) => TripsPage());
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
