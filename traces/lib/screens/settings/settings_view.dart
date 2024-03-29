
import 'package:flutter/material.dart';
import '../../constants/color_constants.dart';
import '../../constants/route_constants.dart';

class SettingsView extends StatelessWidget{

  SettingsView();

  @override
  Widget build(BuildContext context) {
    return Container(         
      child: SingleChildScrollView(
        child: Column(children: [
          Card(
            child: InkWell(
              onTap: (){
                Navigator.pushNamed(context, themeSettingsRoute);
              },
              child: ListTile(                    
                title: Text('Themes', style: TextStyle(fontSize: 18.0, color: ColorsPalette.black),)
              ),
            ),
          ),
          Card(
            child: InkWell(
              onTap: (){
                Navigator.pushNamed(context, menuSettingsRoute);
              },
              child: ListTile(                    
                title: Text('Menu', style: TextStyle(fontSize: 18.0, color: ColorsPalette.black),)
              ),
            ),
          ),
          Card(
            child: InkWell(
              onTap: (){
                Navigator.pushNamed(context, categoriesRoute);
              },
              child: ListTile(                    
                title: Text('Categories', style: TextStyle(fontSize: 18.0, color: ColorsPalette.black),)
              ),
            ),
          )
        ],),
      )
    );
  }
}