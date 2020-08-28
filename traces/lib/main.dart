import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traces/auth/simple_bloc_delegate.dart';
import 'package:traces/colorsPalette.dart';
import 'package:traces/router.dart';
import 'package:traces/screens/home.dart';
import 'package:traces/screens/welcome.dart';
import 'package:traces/auth/bloc.dart';
import 'package:traces/auth/userRepository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/shared/shared.dart';
import 'loginSignup/loginSignup_page.dart';
import 'package:flutter/services.dart';
// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); //is required in Flutter v1.9.4+ before using any plugins if the code is executed before runApp.
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocDelegate();
  final UserRepository userRepository = UserRepository();

  // Create the initilization Future outside of `build`:
  /*Future<FirebaseApp> _initialization = Firebase.initializeApp();

  FutureBuilder(
    // Initialize FlutterFire:
    future: _initialization,
    builder: ()
  );*/

  runApp(
    BlocProvider(
      create: (context) => AuthenticationBloc(userRepository: userRepository)
        ..add(AppStarted()),
      child: TracesApp(userRepository: userRepository)
    )
  );
}

class TracesApp extends StatelessWidget{
  // Create the initilization Future outside of `build`:
  //Future<FirebaseApp> _initialization = Firebase.initializeApp();

  final UserRepository _userRepository;

  TracesApp({Key key, @required UserRepository userRepository})
    :assert(userRepository != null),
    _userRepository = userRepository,
    super(key: key);

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
          textTheme: GoogleFonts.quicksandTextTheme(Theme.of(context).textTheme)
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state){
          if(state is Uninitialized){
            return WelcomePage();
          }
          if (state is Unauthenticated) {
            return LoginSignupPage(userRepository: _userRepository);
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

