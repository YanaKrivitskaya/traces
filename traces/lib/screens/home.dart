
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traces/auth/auth_bloc/bloc.dart';
import 'package:traces/screens/settings/model/app_theme.dart';
import 'package:traces/screens/settings/themes/bloc/settings_bloc.dart';
import 'package:traces/utils/style/styles.dart';

import '../auth/auth_bloc/authentication_bloc.dart';
import '../constants/color_constants.dart';
import '../constants/route_constants.dart';
import '../widgets/widgets.dart';

class HomePage extends StatefulWidget {
  
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AppTheme? _theme;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeSettingsBloc>(
      create: (context) => 
        ThemeSettingsBloc()
          ..add(GetAppSettings()),
      child: BlocBuilder<ThemeSettingsBloc, ThemeSettingsState>(        
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

Widget _homeMenu(AppTheme? _theme, BuildContext context) => new Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('Traces', style:quicksandStyle(color: ColorsPalette.lynxWhite, fontSize: headerFontSize)),
        backgroundColor: ColorsPalette.juicyGreen,
        actions: <Widget>[
          /*IconButton(
            icon: Icon(Icons.exit_to_app, color: ColorsPalette.lynxWhite),
            onPressed: (){
              BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
            },
          )*/
        ]
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