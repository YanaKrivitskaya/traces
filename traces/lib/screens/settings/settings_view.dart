
import 'package:flutter/material.dart';
import 'package:traces/colorsPalette.dart';
import 'package:traces/constants.dart';
import 'package:traces/screens/settings/bloc/settings_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/screens/settings/model/appSettings_entity.dart';
import 'package:traces/shared/shared.dart';

class SettingsView extends StatefulWidget{

  SettingsView();
  State<SettingsView> createState() => _SettingsStateView();
}

class _SettingsStateView extends State<SettingsView>{

  AppSettings _settings;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      cubit: BlocProvider.of(context),
      builder: (context, state){
        if(state is SuccessSettingsState){
          _settings = state.settings;
        }

        if(_settings != null){
          return Container(
          //padding: EdgeInsets.all(5.0),
          child: SingleChildScrollView(
            child: Column(children: [
              _settings.themes != null 
                ? Card(
                  child: InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, themeSettingsRoute);
                    },
                    child: ListTile(                    
                      title: Text('Themes', style: TextStyle(fontSize: 18.0, color: ColorsPalette.picoVoid),)
                    ),
                  ),
                )
                : Container()
            ],),
          )
        );
        }
        return loadingWidget(ColorsPalette.picoVoid);
      }
    );
  }

}