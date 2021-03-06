import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/screens/trips/bloc/trips_bloc.dart';

import '../../constants/color_constants.dart';
import '../../constants/route_constants.dart';
import 'trips_view.dart';

class TripsPage extends StatelessWidget{
  TripsPage();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TripsBloc, TripsState>(
      builder: (context, state){
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            centerTitle: true,
            title: Text('Trips', style: GoogleFonts.quicksand(textStyle: 
              TextStyle(color: ColorsPalette.meditSea, fontSize: 30.0))),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: ColorsPalette.meditSea),
              onPressed: (){
                Navigator.pop(context);
              },
            ),                       
            elevation: 0,
            backgroundColor: ColorsPalette.white,
            //backgroundColor: ColorsPalette.freshBlue,
          ),
          body: TripsView(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
            Navigator.pushNamed(context, tripStartPlanningRoute);
          },
            tooltip: 'Add new Trip',
            backgroundColor: ColorsPalette.juicyYellow,
            child: Icon(Icons.add, color: ColorsPalette.white),
          ),      
        ); 
      }
    );
  }  
}