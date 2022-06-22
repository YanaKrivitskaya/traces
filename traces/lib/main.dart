// Import the firebase_core plugin
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traces/utils/services/shared_preferencies_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'auth/auth_bloc/bloc.dart';
import 'auth/login_signup/loginSignup_page.dart';
import 'auth/simple_bloc_delegate.dart';
import 'config/router.dart';
import 'constants/color_constants.dart';
import 'screens/home.dart';
import 'screens/welcome.dart';
import 'utils/services/api_service.dart';
import 'package:sizer/sizer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); //is required in Flutter v1.9.4+ before using any plugins if the code is executed before runApp.  
  await ApiService.init();
  await SharedPreferencesService.init();
  await dotenv.load(fileName: ".env");
   BlocOverrides.runZoned(
    () {},
    blocObserver: SimpleBlocDelegate()
  );  
  
  runApp(
    BlocProvider(
      create: (context) => AuthenticationBloc()
        ..add(AppStarted()),
      child: TracesApp()
    )
  );
}

final globalScaffoldMessenger = GlobalKey<ScaffoldMessengerState>();

class TracesApp extends StatelessWidget{
 
  TracesApp({Key? key}):super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);    

    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          scaffoldMessengerKey: globalScaffoldMessenger,
          debugShowCheckedModeBanner: false,
          title: 'Traces',
          theme: ThemeData(
              primaryColor: ColorsPalette.mainColor,
              scaffoldBackgroundColor: ColorsPalette.white,              
              textTheme: GoogleFonts.quicksandTextTheme(Theme.of(context).textTheme), 
              colorScheme: ColorScheme.fromSwatch().copyWith(
                secondary: ColorsPalette.juicyOrange,
                outline: ColorsPalette.juicyYellow
              ),              
          ),
          home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state){
              if(state is Uninitialized){
                return WelcomePage();
              }
              if (state is Unauthenticated) {
                return LoginSignupPage();
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
    );
  }
}

