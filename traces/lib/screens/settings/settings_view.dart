
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/widgets/widgets.dart';

import '../../constants/color_constants.dart';
import '../../constants/route_constants.dart';
import 'bloc/settings_bloc.dart';
import 'model/appSettings_entity.dart';

class SettingsView extends StatefulWidget{

  SettingsView();
  State<SettingsView> createState() => _SettingsStateView();
}

class _SettingsStateView extends State<SettingsView>{

  AppSettings _settings;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      bloc: BlocProvider.of(context),
      builder: (context, state){
        if(state is SuccessSettingsState){
          _settings = state.settings;
        }

        if(_settings != null){
          return Container(         
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