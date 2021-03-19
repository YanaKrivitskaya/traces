
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traces/auth/authentication_bloc.dart';
import 'package:traces/auth/authentication_event.dart';
import 'package:traces/constants.dart';
import '../colorsPalette.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
                    /*Column(
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.pushNamed(context, tripsRoute);
                          },
                          padding: EdgeInsets.all(10.0),
                          child: Column( // Replace with a Row for horizontal icon + text
                            children: <Widget>[
                              Image(image: AssetImage('assets/016-mountain.png'), height: 65.0, width: 65.0,),
                              Text("Trips", style: TextStyle(color: ColorsPalette.iconTitle, fontSize: 20.0))
                            ],
                          ),
                        ),
                      ]
                  ),
                  Column(
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.pushNamed(context, mapRoute);
                          },
                          padding: EdgeInsets.all(10.0),
                          child: Column( // Replace with a Row for horizontal icon + text
                            children: <Widget>[
                              Image(image: AssetImage('assets/015-navigation.png'), height: 65.0, width: 65.0,),
                              Text("Map", style: TextStyle(color: ColorsPalette.iconTitle, fontSize: 20.0))
                            ],
                          ),
                        ),
                      ]
                  ),
                  Column(
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.pushNamed(context, notesRoute);
                          },
                          padding: EdgeInsets.all(10.0),
                          child: Column( // Replace with a Row for horizontal icon + text
                            children: <Widget>[
                              Image(image: AssetImage('assets/011-postcard.png'), height: 65.0, width: 65.0,),
                              Text("Notes", style: TextStyle(color: ColorsPalette.iconTitle, fontSize: 20.0))
                            ],
                          ),
                        ),
                      ]
                  ),*/
                    _menuTile(FontAwesomeIcons.route, "Trips", context, tripsRoute, ColorsPalette.iconColor),
                    _menuTile(FontAwesomeIcons.globeEurope, "Map", context, mapRoute, ColorsPalette.iconColor),
                    _menuTile(FontAwesomeIcons.clipboard, "Notes", context, notesRoute, ColorsPalette.iconColor)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _menuTile(FontAwesomeIcons.plane, "Flights", context, flightsRoute, ColorsPalette.iconColor),
                    /*Column(
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.pushNamed(context, flightsRoute);
                          },
                          padding: EdgeInsets.all(10.0),
                          child: Column( // Replace with a Row for horizontal icon + text
                            children: <Widget>[
                              Image(image: AssetImage('assets/036-plane.png'), height: 65.0, width: 65.0,),
                              Text("Flights", style: TextStyle(color: ColorsPalette.iconTitle, fontSize: 20.0))
                            ],
                          ),
                        ),
                      ]
                  ),
                    Column(
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.pushNamed(context, expensesRoute);
                          },
                          padding: EdgeInsets.all(10.0),
                          child: Column( // Replace with a Row for horizontal icon + text
                            children: <Widget>[
                              Image(image: AssetImage('assets/029-credit-card.png'), height: 65.0, width: 65.0,),
                              Text("Expenses", style: TextStyle(color: ColorsPalette.iconTitle, fontSize: 20.0))
                            ],
                          ),
                        ),
                      ]
                  ),
                  Column(
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.pushNamed(context, hotelsRoute);
                          },
                          padding: EdgeInsets.all(10.0),
                          child: Column( // Replace with a Row for horizontal icon + text
                            children: <Widget>[
                              Image(image: AssetImage('assets/020-hotel.png'), height: 65.0, width: 65.0,),
                              Text("Hotels", style: TextStyle(color: ColorsPalette.iconTitle, fontSize: 20.0))
                            ],
                          ),
                        ),
                      ]
                  ),*/
                    _menuTile(FontAwesomeIcons.dollarSign, "Expenses", context, expensesRoute, ColorsPalette.iconColor),
                    _menuTile(FontAwesomeIcons.hotel, "Hotels", context, hotelsRoute, ColorsPalette.iconColor)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    /*Column(
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.pushNamed(context, visasRoute);
                          },
                          padding: EdgeInsets.all(10.0),
                          child: Column( // Replace with a Row for horizontal icon + text
                            children: <Widget>[
                              Image(image: AssetImage('assets/014-passport.png'), height: 65.0, width: 65.0,),
                              Text("Visas", style: TextStyle(color: ColorsPalette.iconTitle, fontSize: 20.0))
                            ],
                          ),
                        ),
                      ]
                  ),
                    Column(
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.pushNamed(context, profileRoute);
                          },
                          padding: EdgeInsets.all(10.0),
                          child: Column( // Replace with a Row for horizontal icon + text
                            children: <Widget>[
                              Image(image: AssetImage('assets/002-trekking.png'), height: 65.0, width: 65.0,),
                              Text("Profile", style: TextStyle(color: ColorsPalette.iconTitle, fontSize: 20.0))
                            ],
                          ),
                        ),
                      ]
                  ),
                  Column(
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.pushNamed(context, settingsRoute);
                          },
                          padding: EdgeInsets.all(10.0),
                          child: Column( // Replace with a Row for horizontal icon + text
                            children: <Widget>[
                              Image(image: AssetImage('assets/021-signpost.png'), height: 65.0, width: 65.0,),
                              Text("Settings", style: TextStyle(color: ColorsPalette.iconTitle, fontSize: 20.0))
                            ],
                          ),
                        ),
                      ]
                  ),*/
                    _menuTile(FontAwesomeIcons.passport, "Visas", context, visasRoute, ColorsPalette.iconColor),
                    _menuTile(FontAwesomeIcons.user, "Profile", context, profileRoute, ColorsPalette.iconColor),
                    _menuTile(FontAwesomeIcons.cog, "Settings", context, settingsRoute, ColorsPalette.iconColor)

                  ],
                ),
              ],
            ),
          )
      )
    );
  }
}

Column _menuTile(IconData icon, String title, BuildContext context, String routeName, Color iconColor) =>Column(
    children: <Widget>[
      TextButton(
        onPressed: () {
          Navigator.pushNamed(
              context,
              routeName,
              //arguments:
          );
        },
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(10.0))     
        ),          
        child: Column( // Replace with a Row for horizontal icon + text
          children: <Widget>[
            FaIcon(icon, color: iconColor, size: 50.0),
            /*LinearGradientMask(
              child: FaIcon(
                icon,
                size: 50,
                color: Colors.white,
              ),
            ),*/
            //Icon(icon, color: color, size: 60.0),
            Text(title, style: TextStyle(color: ColorsPalette.iconTitle, fontSize: 20.0))
          ],
        ),
      ),
    ]
);