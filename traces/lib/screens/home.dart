
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:traces/screens/settings/app_settings/bloc/settings_bloc.dart';
import 'package:traces/screens/settings/model/app_menu.dart';
import 'package:traces/screens/trips/model/activity.model.dart';
import 'package:traces/screens/trips/model/booking.model.dart';
import 'package:traces/screens/trips/model/ticket.model.dart';
import 'package:traces/screens/trips/model/trip_day.model.dart';
import 'package:traces/screens/trips/model/trip_object.model.dart';

import '../constants/color_constants.dart';
import '../constants/route_constants.dart';
import '../utils/misc/state_types.dart';
import '../utils/style/styles.dart';
import '../widgets/widgets.dart';
import 'profile/bloc/profile/bloc.dart';
import 'settings/model/app_theme.dart';
import 'trips/current_trip/bloc/current_trip_bloc.dart';
import 'trips/model/expense.model.dart';
import 'trips/model/trip.model.dart';
import 'trips/model/trip_arguments.model.dart';
import 'trips/tripdetails/expenses/expense_edit/bloc/expensecreate_bloc.dart';
import 'trips/widgets/comfy_trip_list_item.dart';
import 'trips/widgets/create_expense_dialog.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:intl/intl.dart';

import 'trips/widgets/trip_helpers.dart';

class HomePage extends StatefulWidget {
   
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AppTheme? _theme; 
  AppMenu? _menu;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isCurrentTrip = false;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppSettingsBloc>(
          create: (BuildContext context) => AppSettingsBloc()..add(GetAppSettings()),
        ),
        BlocProvider<ProfileBloc>(
          create: (BuildContext context) => ProfileBloc()..add(GetProfile()),
        ),
        BlocProvider<CurrentTripBloc>(
          create: (BuildContext context) => CurrentTripBloc()..add(GetCurrentTrip()),
        )
      ],
      child: BlocBuilder<AppSettingsBloc, AppSettingsState>(
        builder: (context, state){
          if(state is SuccessSettingsState){         
            _theme = state.userTheme;
            _menu = state.userMenu;
            
            return BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state){
                if(state.status == StateStatus.Success){                  
                  return _menu?.name == 'drawer' ? _homeMenuNewUI(_theme, context, state, _scaffoldKey, isCurrentTrip) : _homeMenu(_theme, context);
                }
                return new Scaffold(body: loadingWidget(ColorsPalette.juicyGreen));
              }
            );
          }
          return new Scaffold(body: loadingWidget(ColorsPalette.juicyGreen));
        }
      ),
    );    
  }
}

Widget _homeMenu(AppTheme? _theme, BuildContext context) => new Scaffold(
  appBar: AppBar(
    elevation: 0,
    centerTitle: true,
    title: Text('Traces', style:quicksandStyle(color: ColorsPalette.lynxWhite, fontSize: headerFontSize)),
    backgroundColor: ColorsPalette.juicyGreen        
  ),
  body: Center(
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(width: 10, color: ColorsPalette.juicyGreen),
            color: ColorsPalette.backColor
        ),
        padding: EdgeInsets.all(viewPadding),
        child: Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _menuTile(FontAwesomeIcons.route, _theme, '1-trips.png', 'Trips', context, tripsRoute),
                _menuTile(FontAwesomeIcons.plane, _theme, '4-flights.png', 'Tickets', context, flightsRoute),
                _menuTile(FontAwesomeIcons.passport, _theme, '7-visas.png', 'Visas', context, visasRoute),
              ],
            ),
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _menuTile(FontAwesomeIcons.earthEurope, _theme, '2-map.png', 'Map', context, mapRoute),
                _menuTile(FontAwesomeIcons.dollarSign, _theme, '5-expenses.png', 'Expenses', context, expensesRoute),
                _menuTile(FontAwesomeIcons.user, _theme, '8-profile.png', 'Profile', context, profileRoute),
              ],
            ),
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _menuTile(FontAwesomeIcons.clipboard, _theme, '3-notes.png', 'Notes', context, notesRoute),
                _menuTile(FontAwesomeIcons.hotel, _theme, '6-hotels.png', 'Bookings', context, hotelsRoute),
                _menuTile(FontAwesomeIcons.gear, _theme, '9-settings.png', 'Settings', context, settingsRoute)
              ],
            )
          ],
        )            
      )
  )
);

Column _menuTile(IconData icon, AppTheme? theme, String iconName, String title, BuildContext context, String routeName) => Column(
  children: <Widget>[
    TextButton(
      onPressed: () {
        Navigator.pushNamed(context, routeName); 
      },
      style: ButtonStyle(padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(viewPadding))),
      child: Column(        
        children: theme?.iconsPath != null ?  
          <Widget>[
            Image(image: AssetImage('${theme!.iconsPath}$iconName'), height: homeBigIconSize, width: homeBigIconSize,),
            Text(title, style: TextStyle(color: ColorsPalette.iconTitle, fontSize: fontSize))            
          ]
        : <Widget>[ 
            FaIcon(icon, color: ColorsPalette.iconColor, size: homeIconSize),            
            Text(title, style: TextStyle(color: ColorsPalette.iconTitle, fontSize: fontSize))
        ],
      ),
    ),
  ]
);

Widget _homeMenuNewUI(AppTheme? _theme, BuildContext context, ProfileState state, GlobalKey _scaffoldKey, bool isCurrentTrip) => new Scaffold( 
  key: _scaffoldKey,
  appBar: AppBar(
    elevation: 0,    
    title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [      
      Text('Hello, ', style:quicksandStyle(fontSize: accentFontSize)), 
      InkWell(
        child: Text('${state.profile?.name}!', style:quicksandStyle(color: ColorsPalette.juicyOrange, fontSize: accentFontSize)),
        onTap: (){
          Navigator.pushNamed(context, profileRoute).then((value) => 
           BlocProvider.of<ProfileBloc>(context)..add(GetProfile())
          ); 
        },
      )
    ]),
    backgroundColor: ColorsPalette.white,
    leading: Builder(
      builder: (context) => Container(padding: EdgeInsets.all(borderPaddingSm), child: InkWell(
        child:         
        Icon(Icons.menu, color: ColorsPalette.black,),
        onTap: () => Scaffold.of(context).openDrawer(),
      )),
    ),
  ),
  drawer: Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
            color: ColorsPalette.juicyYellow,
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [            
          Row(children: [
              Text('Welcome to ', style:quicksandStyle(fontSize: accentFontSize, color: ColorsPalette.white)), 
              Text('Traces!', style:quicksandStyle(fontSize: accentFontSize, color: ColorsPalette.white, weight: FontWeight.bold)),        
            ],)
          ],)
        ),
        _menuTileNewUI(_theme, '0-house.png', Icons.home, "Home", context, homeRoute),
        _menuTileNewUI(_theme, '1-trips.png', Icons.map, "Trips", context, tripsRoute),
        _menuTileNewUI(_theme, '3-notes.png', Icons.description, "Notes", context, notesRoute),
        _menuTileNewUI(_theme, '7-visas.png', Icons.branding_watermark, "Visas", context, visasRoute),
        _menuTileNewUI(_theme, '8-profile.png', Icons.account_circle, "Profile", context, profileRoute),
        _menuTileNewUI(_theme, '9-settings.png', Icons.settings, "Settings", context, settingsRoute),
      ],
    ),
  ),
  body: BlocBuilder<CurrentTripBloc, CurrentTripState>(
    builder: (context, state){
      if(state is CurrentTripSuccessState){
        if(state.trip != null){
          isCurrentTrip = !state.trip!.startDate!.isAfter(DateTime.now());

          return Container(
            padding: EdgeInsets.symmetric(horizontal: viewPadding),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
              Text(isCurrentTrip ? "Today's trip:" : "Upcoming trip:", style: quicksandStyle(fontSize: accentFontSize, color: ColorsPalette.juicyOrange, weight: FontWeight.bold)),
              SizedBox(height: sizerHeightlg),
              InkWell(
              child: comfyTripsListItem(state.trip!, context),
              onTap: (){
                TripDetailsArguments args = new TripDetailsArguments(isRoot: true, tripId: state.trip!.id!);
                Navigator.pushNamed(context, tripDetailsRoute, arguments: args).then((value) => {});
              }
            ),          
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              _addExpenseButton(state.trip!, context),
            ]),
            state.tripDay != null && isCurrentTrip ? Column(children: [
              Row(children: [
                Text("Plan for today:", style: quicksandStyle(fontSize: accentFontSize, color: ColorsPalette.juicyOrange, weight: FontWeight.bold)),
              ],),            
              _timelineDay(state.tripDay!, state.trip!)
            ]) : SizedBox(height: 0)
          ]));
        }else{
          return Container(
            padding: EdgeInsets.symmetric(horizontal: viewPadding),
            child: Column(children: [
              SizedBox(height: tripItemHeight),
              Text("No plans for today", style: quicksandStyle(fontSize: accentFontSize, color: ColorsPalette.juicyOrange, weight: FontWeight.bold)),
              SizedBox(height: sizerHeightlg),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              _addTripButton(context),
            ]),
            ],)
          );
        }        
      }
      return loadingWidget(ColorsPalette.juicyGreen);
    }
  ),
);

Widget _menuTileNewUI(AppTheme? theme, String iconName, IconData icon, String title, BuildContext context, String routeName) => ListTile(
  leading: theme?.iconsPath != null ?  
          Image(image: AssetImage('${theme!.iconsPath}$iconName'), height: iconSizeSm, width: iconSizeSm,)
        : Icon(icon, color: ColorsPalette.juicyOrange, size: iconSizeSm),
  title: Text(title, style: quicksandStyle(fontSize: fontSize)),
  onTap: (){
    Navigator.pushNamed(context, routeName).then((value) => 
      BlocProvider.of<ProfileBloc>(context)..add(GetProfile())
    ); 
  },
);

Widget _addExpenseButton(Trip trip, BuildContext context) => ElevatedButton(
  child: Row(children: [
    Text("\$", style: quicksandStyle(fontSize: accentFontSize, color: ColorsPalette.white, weight: FontWeight.bold)),
    SizedBox(width: sizerWidthMd), 
    Text("Add expense")
  ],),
  style: ButtonStyle(
    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.only(left: 25.0, right: 25.0)),
    backgroundColor: MaterialStateProperty.all<Color>(ColorsPalette.amMint),
    foregroundColor: MaterialStateProperty.all<Color>(ColorsPalette.white)
  ),
  onPressed: () {
    Expense expense = new Expense(date: DateTime.now());             
    
    showDialog(                
      barrierDismissible: false, context: context, builder: (dialogContext) =>
        BlocProvider<ExpenseCreateBloc>(
          create: (dialogContext) => ExpenseCreateBloc()..add(AddExpenseMode(null, expense)),
          child: CreateExpenseDialog(trip: trip, submitExpense: true, callback: (val) async {
            if(val != null){
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  backgroundColor: ColorsPalette.amMint,
                  content: Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [ 
                        Icon(Icons.check, color: ColorsPalette.lynxWhite,)
                    ],
                    ),
                  ));                                          
            }
          }),
        )
    );}
);

Widget _addTripButton(BuildContext context) => ElevatedButton(
  child: Row(children: [    
    Text("Plan trip")
  ],),
  style: ButtonStyle(
    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.only(left: 25.0, right: 25.0)),
    backgroundColor: MaterialStateProperty.all<Color>(ColorsPalette.amMint),
    foregroundColor: MaterialStateProperty.all<Color>(ColorsPalette.white)
  ),
  onPressed: () {
    Navigator.pushNamed(context, tripStartPlanningRoute).then((value) {} /*context.read<TripsBloc>().add(GetAllTrips())*/);
  }
);

Widget _timelineDay(TripDay day, Trip trip){    
    var events = sortObjects(day.tripEvents);
    //print("$fullWidth * $fullheight");
    return Container(padding: EdgeInsets.symmetric(horizontal: borderPadding), 
    child: SingleChildScrollView(child: Container(
      constraints: BoxConstraints(
          maxHeight: scrollViewHeightMd,
        ),
      child: ListView.builder(
        shrinkWrap: true,         
        itemCount: events.length,
        itemBuilder: (context, position){
          var tripEvent = events[position];
          DateTime? startDate = tripEvent.startDate;
          DateTime? endDate = tripEvent.endDate;
          return TimelineTile(              
            alignment: TimelineAlign.manual,
            lineXY: 0.19,
            isFirst: position == 0,
            isLast: position == events.length - 1,
            indicatorStyle: IndicatorStyle(
              indicator: getObjectIcon(tripEvent.type, tripEvent.event),                
              padding: EdgeInsets.all(8),
            ),
            startChild: Text('${startDate != null ? DateFormat.Hm().format(startDate) : ''} ${startDate != null && endDate != null 
              && tripEvent.type == TripEventType.Ticket ?' - ' : ''} ${ endDate != null && tripEvent.type == TripEventType.Ticket ? DateFormat.Hm().format(endDate) : ''}'),
            endChild: _eventCard(tripEvent, context, trip),
            beforeLineStyle: const LineStyle(
              color:ColorsPalette.christmasGrey,
            ),
          );
      }))));
  }

  Widget _eventCard(TripEvent tripEvent, BuildContext context, Trip trip){ 
    switch (tripEvent.type){
      case TripEventType.Booking:{
        Booking booking = tripEvent.event as Booking;
        return Container(
          child: InkWell(child: 
          Card(
            child: Container(
              constraints: BoxConstraints(
                minHeight: minCardHeight,
              ),
              padding: EdgeInsets.all(borderPadding),        
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                Text('${booking.name}', style: quicksandStyle(fontSize: fontSizesm,)),                
                SizedBox(height: 3.0,),
                SingleChildScrollView(                  
                  child:Text('${booking.details}', style: quicksandStyle(fontSize: fontSizexs,)))
              ],)),
          ),
          onTap: (){
            BookingViewArguments args = new BookingViewArguments(bookingId: booking.id!, trip: trip);

            Navigator.of(context).pushNamed(bookingViewRoute, arguments: args).then((value) => {
              //BlocProvider.of<TripDayBloc>(context)..add(TripDayLoaded(tripDay!))
            });
          },
        )
        );
      }
      case TripEventType.Ticket:{
        Ticket ticket = tripEvent.event as Ticket;
        return Container(
          child: InkWell(child: 
          Card(
            child: Container(
              constraints: BoxConstraints(
                minHeight: minCardHeight,
                maxHeight: maxCardHeight
              ),
              padding: EdgeInsets.all(borderPadding),        
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                Text('${ticket.departureLocation} - ${ticket.arrivalLocation}', style: quicksandStyle(fontSize: fontSizesm,)),                
                SizedBox(height: 3.0,),
                Text('${ticket.carrier} - ${ticket.carrierNumber}', style: quicksandStyle(fontSize: fontSizexs)),
                SizedBox(height: 3.0,),
                SingleChildScrollView(                  
                  child:Text('${ticket.details}', style: quicksandStyle(fontSize: 15.0,)))
              ],)),
          ),
          onTap: (){
            TicketViewArguments args = new TicketViewArguments(ticketId: ticket.id!, trip: trip);

            Navigator.of(context).pushNamed(ticketViewRoute, arguments: args).then((value) => {
              //BlocProvider.of<TripDayBloc>(context)..add(TripDayLoaded(tripDay!))
            });
          },
        )
        );
      }
      case TripEventType.Activity:{
        Activity activity = tripEvent.event as Activity;
        return Container(
          child: InkWell(child: 
          Card(
            child: Container(
              constraints: BoxConstraints(
                minHeight: minCardHeight,
              ),
              padding: EdgeInsets.all(borderPadding),        
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                Text('${activity.name}', style: quicksandStyle(fontSize: fontSizesm)),                
                SizedBox(height: 3.0,),
                SingleChildScrollView(                  
                  child:Text('${activity.description}', style: quicksandStyle(fontSize: fontSizexs)))
              ],)),
          ),
          onTap: (){
            ActivityViewArguments args = new ActivityViewArguments(activityId: activity.id!, trip: trip);

            Navigator.of(context).pushNamed(activityViewRoute, arguments: args).then((value) => {
              //BlocProvider.of<TripDayBloc>(context)..add(TripDayLoaded(tripDay!))
            });
          },
        )
        );
      }
      default: return SizedBox(height:0);
    }       
  }

