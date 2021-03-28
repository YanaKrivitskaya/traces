
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/auth/authentication_bloc.dart';
import 'package:traces/auth/authentication_state.dart';
import 'package:traces/colorsPalette.dart';
import 'package:traces/screens/settings/bloc/settings_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traces/shared/shared.dart';

class ThemeSettingsView extends StatefulWidget{

  @override
  State<ThemeSettingsView> createState() => _ThemeSettingsViewState();

}

class _ThemeSettingsViewState extends State<ThemeSettingsView>{

  AuthenticationBloc _authBloc;

   @override
  void initState() {
    super.initState();   

    _authBloc = BlocProvider.of<AuthenticationBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      cubit: BlocProvider.of(context),
      builder: (context, state){
        return new Scaffold(
          appBar: AppBar(
            title: Text('Themes', style: GoogleFonts.quicksand(textStyle: TextStyle(
              color: ColorsPalette.white, fontSize: 30.0))),
            leading: IconButton(
              icon: FaIcon(FontAwesomeIcons.arrowLeft, color: ColorsPalette.lynxWhite),
              onPressed: () => Navigator.of(context).pop(),
            )            
          ),
          body: state.settings != null ? Container(
            child: Wrap(children: [
              ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: state.settings.themes.length,
                itemBuilder: (context, position) {
                final theme = state.settings.themes[position];
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Image(
                      image: AssetImage('assets/${theme == 'brightBlue' ? 'brightBlueTheme.png' : 'calmGreenTheme.png'}'),
                      height: 150,
                      //width: 50,
                      fit:BoxFit.fitHeight
                    ),
                  );
                })        
            ],),
          ) : loadingWidget(ColorsPalette.picoVoid)
        );
      }
    );
  }

}