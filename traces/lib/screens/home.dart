
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traces/auth/auth_bloc/bloc.dart';
import 'package:traces/screens/profile/bloc/profile/bloc.dart';
import 'package:traces/screens/settings/model/app_theme.dart';
import 'package:traces/screens/settings/themes/bloc/settings_bloc.dart';
import 'package:traces/utils/misc/state_types.dart';
import 'package:traces/utils/style/styles.dart';

import '../auth/auth_bloc/authentication_bloc.dart';
import '../constants/color_constants.dart';
import '../constants/route_constants.dart';
import '../widgets/widgets.dart';

class HomePage extends StatefulWidget {

  var newUI = true;
  
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AppTheme? _theme; 

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeSettingsBloc>(
          create: (BuildContext context) => ThemeSettingsBloc()..add(GetAppSettings()),
        ),
        BlocProvider<ProfileBloc>(
          create: (BuildContext context) => ProfileBloc()..add(GetProfile()),
        )
      ],
      child: BlocBuilder<ThemeSettingsBloc, ThemeSettingsState>(
        builder: (context, state){
          if(state is SuccessSettingsState){         
            _theme = state.userTheme;
            return BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state){
                if(state.status == StateStatus.Success){                  
                  return widget.newUI ? _homeMenuNewUI(_theme, context, state) : _homeMenu(_theme, context);
                }
                return loadingWidget(ColorsPalette.pureApple);
              }
            );
          }
          return loadingWidget(ColorsPalette.pureApple);
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

Widget _homeMenuNewUI(AppTheme? _theme, BuildContext context, ProfileState state) => new Scaffold( 
  appBar: AppBar(
    elevation: 0,    
    title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      /*avatar(getAvatarName(state.profile!.name), 20.0, ColorsPalette.juicyBlue, fontSize, ColorsPalette.white),
      SizedBox(width: sizerWidthmd),*/
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
        child: avatar(getAvatarName(state.profile!.name), 19.0, ColorsPalette.juicyBlue, fontSize, ColorsPalette.white),
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
            avatar(getAvatarName(state.profile!.name), 25.0, ColorsPalette.juicyBlue, fontSize, ColorsPalette.white),            
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            /*avatar(getAvatarName(state.profile!.name), 20.0, ColorsPalette.juicyBlue, fontSize, ColorsPalette.white),
            SizedBox(width: sizerWidthmd),*/
            Text('Hello, ', style:quicksandStyle(fontSize: accentFontSize, color: ColorsPalette.white)), 
            InkWell(
              child: Text('${state.profile?.name}!', style:quicksandStyle(color: ColorsPalette.white, fontSize: accentFontSize, weight: FontWeight.bold)),
              onTap: (){
                Navigator.pushNamed(context, profileRoute).then((value) => 
                BlocProvider.of<ProfileBloc>(context)..add(GetProfile())
          ); 
              },
            )
                  
          ])
          ],)
        ),
        _menuTileNewUI(Icons.home, "Home", context, homeRoute),
        _menuTileNewUI(Icons.map, "Trips", context, tripsRoute),
        _menuTileNewUI(Icons.description, "Notes", context, notesRoute),
        _menuTileNewUI(Icons.branding_watermark, "Visas", context, visasRoute),
        _menuTileNewUI(Icons.account_circle, "Profile", context, profileRoute),
        _menuTileNewUI(Icons.settings, "Settings", context, settingsRoute),
      ],
    ),
  ),
);

Widget _menuTileNewUI(IconData icon, String title, BuildContext context, String routeName) => ListTile(
  leading: Icon(icon, color: ColorsPalette.juicyDarkBlue),
  title: Text(title),
  onTap: (){
    Navigator.pushNamed(context, routeName).then((value) => 
      BlocProvider.of<ProfileBloc>(context)..add(GetProfile())
    ); 
  },
);