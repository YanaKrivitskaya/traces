import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/auth/authentication_bloc.dart';
import 'package:traces/auth/authentication_state.dart';
import 'package:traces/colorsPalette.dart';
import 'package:traces/screens/settings/bloc/settings_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traces/shared/shared.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ThemeSettingsView extends StatefulWidget{

  ThemeSettingsView():super();

  @override
  State<ThemeSettingsView> createState() => _ThemeSettingsViewState();

}

class _ThemeSettingsViewState extends State<ThemeSettingsView>{

  AuthenticationBloc _authBloc;
  int _currentIndex=0;

  List<String> imgList = <String>[];

  /*final List<String> imgList = [
    'assets/brightBlueTheme.jpg',
    'assets/calmGreenTheme.jpg',
    'assets/plainOrangeTheme.jpg'
  ];*/

   @override
  void initState() {
    super.initState();   

    _authBloc = BlocProvider.of<AuthenticationBloc>(context);
  }

  @override
  void dispose(){
    _authBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      cubit: BlocProvider.of(context),
      builder: (context, state){
        if(state is SuccessSettingsState){
          imgList = _createImgList(state.settings.themes);
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
                    aspectRatio: 2.0,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                  items: imgList.map((item) => Container(                                        
                    child: Center(                      
                      child: Image.asset(item, fit: BoxFit.cover)
                    ),
                  )).toList()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: imgList.map((url) {
                  int index = imgList.indexOf(url);
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
            ],)  ,
          ) : loadingWidget(ColorsPalette.picoVoid)
        );
      }
    );
  }

  List<String> _createImgList(List<String> themes){
    List<String> imgList = <String>[];
    themes.forEach((theme) {
      imgList.add('assets/$theme.jpg');
    });
    return imgList;
  }

}