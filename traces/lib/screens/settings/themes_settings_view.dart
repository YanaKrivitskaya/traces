import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../auth/authentication_bloc.dart';
import '../../colorsPalette.dart';
import '../../shared/shared.dart';
import 'bloc/settings_bloc.dart';

class ThemeSettingsView extends StatefulWidget{

  @override
  State<ThemeSettingsView> createState() => _ThemeSettingsViewState();

}

class _ThemeSettingsViewState extends State<ThemeSettingsView>{

  AuthenticationBloc _authBloc;
  int _currentIndex=0;
  String _userTheme;

  List<String> _themes;

   @override
  void initState() {
    super.initState();   

    _authBloc = BlocProvider.of<AuthenticationBloc>(context);
  }

  @override
  void dispose(){
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      bloc: BlocProvider.of(context),
      builder: (context, state){
        if(state is SuccessSettingsState){         
          _userTheme = state.userTheme;

          _themes = state.settings.themes;
         
          _currentIndex = _userTheme == null ? 0 : 
            state.settings.themes.indexOf(state.selectedTheme ?? state.userTheme);          
        }
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
            padding: EdgeInsets.only(top: 20.0),
            child: Column(children: [
              CarouselSlider(
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height*0.7,
                    initialPage: _currentIndex,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) {
                      var theme = state.settings.themes[index];
                      context.read<SettingsBloc>().add(ThemeSelected(theme)); 
                    },
                  ),
                  items: _themes.map((item) => Container(   
                    padding: EdgeInsets.symmetric(horizontal: 5.0),                                     
                    child: Center(
                      child: item == _userTheme ? Badge(
                        badgeContent: Icon(Icons.check, color: ColorsPalette.lynxWhite),
                        badgeColor: ColorsPalette.pureApple,
                        child: Image.asset('assets/$item.jpg', fit: BoxFit.cover)
                      ) : Image.asset('assets/$item.jpg', fit: BoxFit.cover)
                    ),
                  )).toList()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _themes.map((img) {
                  int index = _themes.indexOf(img);
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
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
                var theme = state.settings.themes[_currentIndex];
                context.read<SettingsBloc>().add(SubmitTheme(theme));                
              },
              child: Text('Select theme'),
            )
            ],)  ,
          ) : loadingWidget(ColorsPalette.picoVoid)
        );
      }
    );
  }

}