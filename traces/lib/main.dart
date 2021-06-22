import 'package:bloc/bloc.dart';
// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'auth/auth_bloc/bloc.dart';
import 'auth/login_signup/loginSignup_page.dart';
import 'auth/simple_bloc_delegate.dart';
import 'config/router.dart';
import 'constants/color_constants.dart';
import 'screens/home.dart';
import 'screens/welcome.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); //is required in Flutter v1.9.4+ before using any plugins if the code is executed before runApp.
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocDelegate();
  
  runApp(
    BlocProvider(
      create: (context) => AuthenticationBloc()
        ..add(AppStarted()),
      child: TracesApp(/*userRepository: userRepository*/)
    )
  );
}

class TracesApp extends StatelessWidget{
 
  TracesApp({Key? key}/*, @required FirebaseUserRepository userRepository}*/)
    /*:assert(userRepository != null),
    _userRepository = userRepository,*/
    :super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Traces',
      theme: ThemeData(
          primaryColor: ColorsPalette.mainColor,
          accentColor: ColorsPalette.iconColor,
          scaffoldBackgroundColor: ColorsPalette.white,
          //textTheme: GoogleFonts.patrickHandTextTheme(Theme.of(context).textTheme)
          textTheme: GoogleFonts.quicksandTextTheme(Theme.of(context).textTheme),
          //buttonTheme: ButtonThemeData(colorScheme: ColorScheme(primary: ColorsPalette.meditSea))
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state){
          if(state is Uninitialized){
            return WelcomePage();
          }
          if (state is Unauthenticated) {
            return LoginSignupPage(/*userRepository: _userRepository*/);
          }
          if(state is Authenticated){
            return HomePage();
          }
          return Container();
        },
      ),
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

