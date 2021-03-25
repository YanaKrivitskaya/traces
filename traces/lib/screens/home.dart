
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traces/auth/authentication_bloc.dart';
import 'package:traces/auth/authentication_event.dart';
import 'package:traces/constants.dart';
import '../colorsPalette.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  final String _theme;
  HomePage({Key key, String theme}) : 
    _theme = theme, 
    super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Traces', style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.lynxWhite, fontSize: 40.0))),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: (){
              BlocProvider.of<AuthenticationBloc>(context).add(
                LoggedOut()
              );
            },
          )
        ],
      ),
      body: Center(
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(width: 10, color: ColorsPalette.mainColor),
                color: ColorsPalette.backColor
            ),
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                   _menuTile(FontAwesomeIcons.route, widget._theme, '1-trips.png', 'Trips', context, tripsRoute),
                   _menuTile(FontAwesomeIcons.globeEurope, widget._theme, '2-map.png', 'Map', context, mapRoute),
                   _menuTile(FontAwesomeIcons.clipboard, widget._theme, '3-notes.png', 'Notes', context, notesRoute)                  
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _menuTile(FontAwesomeIcons.plane, widget._theme, '4-flights.png', 'Flights', context, flightsRoute),
                    _menuTile(FontAwesomeIcons.dollarSign, widget._theme, '5-expenses.png', 'Expenses', context, expensesRoute),
                    _menuTile(FontAwesomeIcons.hotel, widget._theme, '6-hotels.png', 'Hotels', context, hotelsRoute)                    
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _menuTile(FontAwesomeIcons.passport, widget._theme, '7-visas.png', 'Visas', context, visasRoute),
                    _menuTile(FontAwesomeIcons.user, widget._theme, '8-profile.png', 'Profile', context, profileRoute),
                    _menuTile(FontAwesomeIcons.cog, widget._theme, '9-settings.png', 'Settings', context, settingsRoute)
                  ],
                ),
              ],
            ),
          )
      )
    );
  }
}

//Plain Orange theme
Column _plainMenuTile(IconData icon, String title, BuildContext context, String routeName, Color iconColor) =>Column(
    children: <Widget>[
      TextButton(
        onPressed: () {
          Navigator.pushNamed(context, routeName);
        },
        style: ButtonStyle(padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(10.0))),          
        child: Column(
          children: <Widget>[
            FaIcon(icon, color: iconColor, size: 50.0),            
            Text(title, style: TextStyle(color: ColorsPalette.iconTitle, fontSize: 20.0))
          ],
        ),
      ),
    ]
);

Column _menuTile(IconData icon, String theme, String iconName, String title, BuildContext context, String routeName) => Column(
  children: <Widget>[
    TextButton(
      onPressed: () {
        Navigator.pushNamed(context, routeName); 
      },
      style: ButtonStyle(padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(10.0))),
      child: Column(        
        children: theme == 'Plain Orange' ?  
          <Widget>[
            FaIcon(icon, color: ColorsPalette.iconColor, size: 50.0),            
            Text(title, style: TextStyle(color: ColorsPalette.iconTitle, fontSize: 20.0))
          ]
        : <Widget>[ 
          Image(image: AssetImage('assets/${theme}/${iconName}'), height: 65.0, width: 65.0,),
          Text(title, style: TextStyle(color: ColorsPalette.iconTitle, fontSize: 20.0))
        ],
      ),
    ),
  ]
);