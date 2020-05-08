
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traces/auth/authentication_bloc.dart';
import 'package:traces/auth/authentication_event.dart';
import 'package:traces/constants.dart';
import '../colorsPalette.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Traces', style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.grayLight, fontSize: 40.0))),
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
                    _menuTile(Icons.card_travel, "Trips", context, tripsRoute),
                    _menuTile(Icons.explore, "Map", context, mapRoute),
                    _menuTile(/Icons.description, "Notes", context, notesRoute)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _menuTile(Icons.flight, "Flights", context, flightsRoute),
                    _menuTile(Icons.attach_money, "Expenses", context, expensesRoute),
                    _menuTile(Icons.home, "Hotels", context, hotelsRoute)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _menuTile(Icons.call_to_action, "Visas", context, visasRoute),
                    _menuTile(Icons.perm_identity, "Profile", context, profileRoute),
                    _menuTile(Icons.settings, "Settings", context, settingsRoute)
                  ],
                ),
              ],
            ),
          )
      )
    );
  }
}

Column _menuTile(IconData icon, String title, BuildContext context, String routeName) =>Column(
    children: <Widget>[
      FlatButton(
        onPressed: () {
          Navigator.pushNamed(
              context,
              routeName,
              //arguments:
          );
        },
        padding: EdgeInsets.all(10.0),
        child: Column( // Replace with a Row for horizontal icon + text
          children: <Widget>[
            Icon(icon, color: ColorsPalette.iconColor, size: 60.0),
            //Icon(icon, color: color, size: 60.0),
            Text(title, style: TextStyle(color: ColorsPalette.iconTitle, fontSize: 20.0))
          ],
        ),
      ),
    ]
);