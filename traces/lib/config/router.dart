import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth/login_signup/otp/bloc/otp_bloc.dart';
import '../auth/login_signup/otp/otp_verification_view.dart';
import '../constants/route_constants.dart';
import '../screens/expenses.dart';
import '../screens/home.dart';
import '../screens/hotels.dart';
import '../screens/map.dart';
import '../screens/notes/bloc/note_bloc/bloc.dart';
import '../screens/notes/bloc/note_details_bloc/bloc.dart';
import '../screens/notes/bloc/tag_filter_bloc/bloc.dart';
import '../screens/notes/models/note_details_args.dart';
import '../screens/notes/screens/note_detail_view.dart';
import '../screens/notes/screens/note_image_view.dart';
import '../screens/notes/screens/note_page.dart';
import '../screens/profile/bloc/profile/bloc.dart';
import '../screens/profile/profile_page.dart';
import '../screens/settings/app_settings/bloc/settings_bloc.dart';
import '../screens/settings/app_settings/menu_settings_view.dart';
import '../screens/settings/app_settings/themes_settings_view.dart';
import '../screens/settings/categories/bloc/categories_bloc.dart';
import '../screens/settings/categories/categories_page.dart';
import '../screens/settings/settings_page.dart';
import '../screens/trips/bloc/trips_bloc.dart';
import '../screens/trips/model/trip_arguments.model.dart';
import '../screens/trips/start_planning/bloc/startplanning_bloc.dart';
import '../screens/trips/start_planning/start_planning_view.dart';
import '../screens/trips/trip_day/bloc/tripday_bloc.dart';
import '../screens/trips/trip_day/trip_day_view.dart';
import '../screens/trips/tripdetails/activities/activity_details_view/activity_view.dart';
import '../screens/trips/tripdetails/activities/activity_details_view/bloc/activityview_bloc.dart';
import '../screens/trips/tripdetails/activities/activity_edit/activity_create_view.dart';
import '../screens/trips/tripdetails/activities/activity_edit/bloc/activitycreate_bloc.dart';
import '../screens/trips/tripdetails/bloc/tripdetails_bloc.dart';
import '../screens/trips/tripdetails/bookings/booking_edit/bloc/bookingcreate_bloc.dart';
import '../screens/trips/tripdetails/bookings/booking_edit/booking_create.view.dart';
import '../screens/trips/tripdetails/bookings/booking_view/bloc/bookingview_bloc.dart';
import '../screens/trips/tripdetails/bookings/booking_view/booking_view.dart';
import '../screens/trips/tripdetails/expenses/expense_edit/bloc/expensecreate_bloc.dart';
import '../screens/trips/tripdetails/expenses/expense_edit/expense_create_view.dart';
import '../screens/trips/tripdetails/expenses/expenses_view/bloc/expenseview_bloc.dart';
import '../screens/trips/tripdetails/expenses/expenses_view/expense_view.dart';
import '../screens/trips/tripdetails/tickets/ticket_edit/bloc/ticketedit_bloc.dart';
import '../screens/trips/tripdetails/tickets/ticket_edit/ticket_edit_view.dart';
import '../screens/trips/tripdetails/tickets/ticket_view/bloc/ticketview_bloc.dart';
import '../screens/trips/tripdetails/tickets/ticket_view/ticket_view.dart';
import '../screens/trips/tripdetails/tripdetails_view.dart';
import '../screens/trips/trips_page.dart';
import '../screens/visas/bloc/visa/visa_bloc.dart';
import '../screens/visas/bloc/visa_details/visa_details_bloc.dart';
import '../screens/visas/bloc/visa_tab/visa_tab_bloc.dart';
import '../screens/visas/visa_details_view.dart';
import '../screens/visas/visa_edit_view.dart';
import '../screens/visas/visas_page.dart';
import '../widgets/image_crop_view.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case homeRoute:       
        return MaterialPageRoute(
          builder: (_) => BlocProvider<AppSettingsBloc>(
            create: (context) =>
                AppSettingsBloc(/*settingsRepository: FirebaseAppSettingsRepository()*/),
            child: HomePage(),
          ),
      );
      case otpVerificationRoute:
        {
          if (args is String) {
            return MaterialPageRoute(
              builder: (_) => BlocProvider<OtpBloc>(
                create: (context) => OtpBloc()
                  /*..add(OtpSent(args))*/,
                child: OtpVerificationView(args),
              ),
            );
          }
          return _errorRoute();
        }  
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
      case noteImageView:
      {
        if (args is Uint8List) {
            return MaterialPageRoute(
              builder: (_) => NotesImageView(args));
          }
          return _errorRoute();
      }      
      case noteDetailsRoute:
        {
          if (args is NoteDetailsArgs) {
            return MaterialPageRoute(
              builder: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider<NoteDetailsBloc>(
                    create: (context) => NoteDetailsBloc()..add(args.noteId != 0
                      ? GetNoteDetails(args.noteId)
                      : NewNoteMode(args.tripId)),
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
                ProfileBloc()..add(GetProfile()),
            child: ProfilePage(),
          ),
        );
      case settingsRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<AppSettingsBloc>(
            create: (context) =>
                AppSettingsBloc(),
            child: SettingsPage(),
          ),
      );
      case themeSettingsRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<AppSettingsBloc>(
            create: (context) =>
                AppSettingsBloc()
                  ..add(GetAppSettings()),
            child: ThemeSettingsView(),
          ),
      );
      case menuSettingsRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<AppSettingsBloc>(
            create: (context) =>
                AppSettingsBloc()
                  ..add(GetAppSettings()),
            child: MenuSettingsView(),
          ),
      );
      case categoriesRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<CategoriesBloc>(
            create: (context) =>
                CategoriesBloc()
                  ..add(GetCategories()),
            child: CategoriesPage(),
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
          if (args is TripDetailsArguments) {
            return MaterialPageRoute(
              builder: (_) => BlocProvider<TripDetailsBloc>(
                create: (context) => TripDetailsBloc()..add(GetTripDetails(args)),
                child: TripDetailsView(tripId: args.tripId),
              ),
            );
          }
          return _errorRoute();
        }
      case ticketCreateRoute:
      {
        if (args is EventArguments) {
          return MaterialPageRoute(
            builder: (_) => BlocProvider<TicketEditBloc>(
              create: (context) => TicketEditBloc()..add(NewTicketMode(args.date)),
              child: TicketEditView(trip: args.trip),
            ),
          );
        }
        return _errorRoute();          
      }
      case ticketEditRoute:
      {
        if (args is TicketEditArguments) {
          return MaterialPageRoute(
            builder: (_) => BlocProvider<TicketEditBloc>(
              create: (context) => TicketEditBloc()..add(EditTicketMode(args.ticket)),
              child: TicketEditView(trip: args.trip),
            ),
          );
        }
        return _errorRoute();          
      }
      case ticketViewRoute:
      {
        if (args is TicketViewArguments) {
          return MaterialPageRoute(
            builder: (_) => BlocProvider<TicketViewBloc>(
              create: (context) => TicketViewBloc()..add(GetTicketDetails(args.ticketId)),
              child: TicketView(trip: args.trip),
            ),
          );
        }
        return _errorRoute();          
      }
      case bookingCreateRoute:
        {
          if (args is EventArguments) {
            return MaterialPageRoute(
              builder: (_) => BlocProvider<BookingCreateBloc>(
                create: (context) => BookingCreateBloc()..add(NewBookingMode(args.date)),
                child: BookingCreateView(trip: args.trip),
              ),
            );
          }
          return _errorRoute();          
        }
      case bookingViewRoute:
      {
        if (args is BookingViewArguments) {
          return MaterialPageRoute(
            builder: (_) => BlocProvider<BookingViewBloc>(
              create: (context) => BookingViewBloc()..add(GetBookingDetails(args.bookingId)),
              child: BookingView(trip: args.trip),
            ),
          );
        }
        return _errorRoute();          
      }
       case bookingEditRoute:
      {
        if (args is BookingEditArguments) {
          return MaterialPageRoute(
            builder: (_) => BlocProvider<BookingCreateBloc>(
              create: (context) => BookingCreateBloc()..add(EditBookingMode(args.booking)),
              child: BookingCreateView(trip: args.trip),
            ),
          );
        }
        return _errorRoute();          
      }
      case expenseCreateRoute:
        {
          if (args is EventArguments) {
            return MaterialPageRoute(
              builder: (_) => BlocProvider<ExpenseCreateBloc>(
                create: (context) => ExpenseCreateBloc()..add(NewExpenseMode(args.date)),
                child: ExpenseCreateView(trip: args.trip),
              ),
            );
          }
          return _errorRoute();          
        }
        case expenseEditRoute:
        {
          if (args is ExpenseEditArguments) {
            return MaterialPageRoute(
              builder: (_) => BlocProvider<ExpenseCreateBloc>(
                create: (context) => ExpenseCreateBloc()..add(EditExpenseMode(args.expense)),
                child: ExpenseCreateView(trip: args.trip),
              ),
            );
          }
          return _errorRoute();          
        }
        case expenseViewRoute:
        {
          if (args is ExpenseViewArguments) {
            return MaterialPageRoute(
              builder: (_) => BlocProvider<ExpenseViewBloc>(
                create: (context) => ExpenseViewBloc()..add(GetExpenseDetails(args.expenseId)),
                child: ExpenseView(trip: args.trip),
              ),
            );
          }
          return _errorRoute();          
        }
      case activityCreateRoute:
        {
          if (args is EventArguments) {
            return MaterialPageRoute(
              builder: (_) => BlocProvider<ActivityCreateBloc>(
                create: (context) => ActivityCreateBloc()..add(NewActivityMode(args.date)),
                child: ActivityCreateView(trip: args.trip),
              ),
            );
          }
          return _errorRoute();          
        }
      case activityViewRoute:
      {
        if (args is ActivityViewArguments) {
          return MaterialPageRoute(
            builder: (_) => BlocProvider<ActivityViewBloc>(
              create: (context) => ActivityViewBloc()..add(GetActivityDetails(args.activityId)),
              child: ActivityView(trip: args.trip),
            ),
          );
        }
        return _errorRoute();          
      }
       case activityEditRoute:
      {
        if (args is ActivityEditArguments) {
          return MaterialPageRoute(
            builder: (_) => BlocProvider<ActivityCreateBloc>(
              create: (context) => ActivityCreateBloc()..add(EditActivityMode(args.activity)),
              child: ActivityCreateView(trip: args.trip),
            ),
          );
        }
        return _errorRoute();          
      }
      case imageCropRoute:
        {
          if (args is ImageCropArguments) {
            return MaterialPageRoute(
              builder: (_) {
                return ImageCropView(args.file, args.compress);
              }
            );
          }
        return _errorRoute();          
      }
      case tripDayRoute:
        {
          if (args is TripDayArguments) {
            return MaterialPageRoute(
              builder: (_) => BlocProvider<TripDayBloc>(
                create: (context) => TripDayBloc()..add(TripDayLoaded(args.day)),
                child: TripDayView(trip: args.trip),
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
