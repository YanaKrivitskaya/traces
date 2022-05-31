import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traces/screens/settings/model/app_theme.dart';
import 'package:traces/screens/settings/themes/bloc/settings_bloc.dart';
import 'package:traces/widgets/widgets.dart';

import '../../../constants/color_constants.dart';

class ThemeSettingsView extends StatefulWidget{

  @override
  State<ThemeSettingsView> createState() => _ThemeSettingsViewState();

}

class _ThemeSettingsViewState extends State<ThemeSettingsView>{

  int _currentIndex=0;
  AppTheme? _userTheme;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ThemeSettingsBloc, ThemeSettingsState>(
      listener: (context, state) {
        if(state is SuccessSettingsState){         
          _userTheme = state.userTheme;         

          if(_userTheme == null){
            _userTheme = AppThemes[0];
          }
         
          _currentIndex = AppThemes.indexOf(state.selectedTheme ?? _userTheme!);          
        }
      },
      child: BlocBuilder<ThemeSettingsBloc, ThemeSettingsState>(
      bloc: BlocProvider.of(context),
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
          body: state is SuccessSettingsState ?  Container(
            padding: EdgeInsets.only(top: 20.0),
            child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              CarouselSlider(
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height*0.75,
                    initialPage: _currentIndex,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) {
                      var theme = AppThemes[index];
                      context.read<ThemeSettingsBloc>().add(ThemeSelected(theme)); 
                    },
                  ),
                  items: AppThemes.map((item) => Container(   
                    padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),                                     
                    child: Center(
                      child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [                        
                        item == _userTheme ? Badge(
                          badgeContent: Icon(Icons.check, color: ColorsPalette.lynxWhite),
                          badgeColor: ColorsPalette.pureApple,
                          child: Image.asset(item.path, fit: BoxFit.cover)
                        ) : Image.asset(item.path, fit: BoxFit.cover),
                        (item.author != null && _currentIndex == AppThemes.indexOf(item)) ? Text("designed by ${item.author} from Flaticon") : Container()
                      ],)
                    ),
                  )).toList()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:AppThemes.map((img) {
                  int index = AppThemes.indexOf(img);
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
                var theme = AppThemes[_currentIndex];
                context.read<ThemeSettingsBloc>().add(SubmitTheme(theme));                
              },
              child: Text('Select theme'),
            )
            ],)  ,
          ) : loadingWidget(ColorsPalette.picoVoid)
        );
      }
    ),
    );    
  }

}