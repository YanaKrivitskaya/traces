
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traces/auth/authentication_bloc.dart';
import 'package:traces/auth/authentication_event.dart';
import 'package:traces/constants.dart';
import 'package:traces/screens/settings/bloc/settings_bloc.dart';
import 'package:traces/screens/settings/repository/firebase_appSettings_repository.dart';
import 'package:traces/shared/shared.dart';
import '../colorsPalette.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _theme;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsBloc>(
      create: (context) => 
        SettingsBloc(settingsRepository: FirebaseAppSettingsRepository())
          ..add(GetUserSettings()),
      child: BlocBuilder<SettingsBloc, SettingsState>(        
        builder: (context, state){
          if(state is SuccessSettingsState){         
            _theme = state.userTheme;
            return _homeMenu(_theme, context);
          }
          return loadingWidget(ColorsPalette.pureApple);
        }
      )
    );
  }
}

Widget _homeMenu(String _theme, BuildContext context) => new Scaffold(
      appBar: AppBar(
        title: Text('Traces', style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.lynxWhite, fontSize: 40.0))),
        /*actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app, color: ColorsPalette.lynxWhite),
            onPressed: (){
              BlocProvider.of<AuthenticationBloc>(context).add(
                LoggedOut()
              );
            },
          )
        ],*/
      ),
      body: Center(
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(width: 10, color: ColorsPalette.mainColor),
                color: ColorsPalette.backColor
            ),
            padding: EdgeInsets.all(10),
            child: Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _menuTile(FontAwesomeIcons.route, _theme, '1-trips.png', 'Trips', context, tripsRoute),
                    _menuTile(FontAwesomeIcons.plane, _theme, '4-flights.png', 'Flights', context, flightsRoute),
                    _menuTile(FontAwesomeIcons.passport, _theme, '7-visas.png', 'Visas', context, visasRoute),
                  ],
                ),
                Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _menuTile(FontAwesomeIcons.globeEurope, _theme, '2-map.png', 'Map', context, mapRoute),
                    _menuTile(FontAwesomeIcons.dollarSign, _theme, '5-expenses.png', 'Expenses', context, expensesRoute),
                    _menuTile(FontAwesomeIcons.user, _theme, '8-profile.png', 'Profile', context, profileRoute),
                  ],
                ),
                Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _menuTile(FontAwesomeIcons.clipboard, _theme, '3-notes.png', 'Notes', context, notesRoute),
                    _menuTile(FontAwesomeIcons.hotel, _theme, '6-hotels.png', 'Hotels', context, hotelsRoute),
                    _menuTile(FontAwesomeIcons.cog, _theme, '9-settings.png', 'Settings', context, settingsRoute)
                  ],
                )
              ],
            )            
          )
      )
    );

Column _menuTile(IconData icon, String theme, String iconName, String title, BuildContext context, String routeName) => Column(
  children: <Widget>[
    TextButton(
      onPressed: () {
        Navigator.pushNamed(context, routeName); 
      },
      style: ButtonStyle(padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(10.0))),
      child: Column(        
        children: theme == 'calmGreenTheme' || theme == 'brightBlueTheme' ?  
          <Widget>[
            Image(image: AssetImage('assets/$theme/$iconName'), height: 65.0, width: 65.0,),
            Text(title, style: TextStyle(color: ColorsPalette.iconTitle, fontSize: 20.0))            
          ]
        : <Widget>[ 
            FaIcon(icon, color: ColorsPalette.iconColor, size: 50.0),            
            Text(title, style: TextStyle(color: ColorsPalette.iconTitle, fontSize: 20.0))
        ],
      ),
    ),
  ]
);