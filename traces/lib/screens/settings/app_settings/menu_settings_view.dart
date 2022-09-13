import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/screens/settings/app_settings/bloc/settings_bloc.dart';
import 'package:traces/screens/settings/model/app_menu.dart';
import 'package:traces/utils/style/styles.dart';
import 'package:traces/widgets/widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:badges/badges.dart';

import '../../../constants/color_constants.dart';

class MenuSettingsView extends StatefulWidget{

  @override
  State<MenuSettingsView> createState() => _MenuSettingsViewState();
}

class _MenuSettingsViewState extends State<MenuSettingsView>{
  int _currentIndex=0;
  
  AppMenu? _userMenu;
  
  @override
  Widget build(BuildContext context) {
    
    return BlocListener<AppSettingsBloc, AppSettingsState>(
      listener: (context, state) {
        if(state is SuccessSettingsState){          
          
          _userMenu = state.userMenu;         

          if(_userMenu == null){
            _userMenu = AppMenues[0];
          }

          _currentIndex = AppMenues.indexOf(state.selectedMenu ?? _userMenu!); 
        }
      },
      child: BlocBuilder<AppSettingsBloc, AppSettingsState>(
      bloc: BlocProvider.of(context),
      builder: (context, state){
        return new Scaffold(
          appBar: AppBar(
            //centerTitle: true,
            title: Text('Main menu', style: quicksandStyle(fontSize: headerFontSize, color: ColorsPalette.white)),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: ColorsPalette.white),
              onPressed: (){
                Navigator.pop(context);
              },
            ),              
          ),
          body: state is SuccessSettingsState ? Container(
            padding: EdgeInsets.only(top: 20.0),
            child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              CarouselSlider(
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height*0.75,
                    initialPage: _currentIndex,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) {
                      var menu = AppMenues[index];
                      context.read<AppSettingsBloc>().add(MenuSelected(menu)); 
                    },
                  ),
                  items: AppMenues.map((item) => Container(   
                    padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),                                     
                    child: Center(
                      child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [                        
                        item == _userMenu ? Badge(
                          badgeContent: Icon(Icons.check, color: ColorsPalette.lynxWhite),
                          badgeColor: ColorsPalette.pureApple,
                          child: Image.asset(item.path, fit: BoxFit.cover)
                        ) : Image.asset(item.path, fit: BoxFit.cover),                        
                      ],)
                    ),
                  )).toList()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: AppMenues.map((img) {
                  int index = AppMenues.indexOf(img);
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == index
                        ? ColorsPalette.picoVoid
                        : ColorsPalette.blueGrey,
                    ),
                  );
                }).toList(),
              ),
              ElevatedButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.only(left: 25.0, right: 25.0)),
                backgroundColor: MaterialStateProperty.all<Color>(ColorsPalette.picoVoid),
                foregroundColor: MaterialStateProperty.all<Color>(ColorsPalette.lynxWhite)
              ),
              onPressed: () {
                var menu = AppMenues[_currentIndex];
                context.read<AppSettingsBloc>().add(SubmitMenu(menu));                
              },
              child: Text('Select menu'),
            )
            ],)
          ) : loadingWidget(ColorsPalette.juicyBlue),
        );
      }
    )
    );
  }

}