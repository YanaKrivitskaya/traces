import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/screens/trips/bloc/trips_bloc.dart';
import 'package:traces/screens/trips/widgets/update_trip_view_dialog.dart';

import '../../constants/color_constants.dart';
import '../../constants/route_constants.dart';
import '../../utils/services/shared_preferencies_service.dart';
import 'trip_view_options/bloc/tripviewoptions_bloc.dart';
import 'trips_view.dart';

class TripsPage extends StatelessWidget{
  TripsPage();

  final SharedPreferencesService sharedPrefsService = SharedPreferencesService();
  final String viewOptionKey = "tripViewOption";  

  @override
  Widget build(BuildContext context) {
    var viewOption = sharedPrefsService.readInt(key: viewOptionKey);

    return BlocBuilder<TripsBloc, TripsState>(
      builder: (context, state){
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            centerTitle: true,
            title: Text('Trips', style: GoogleFonts.quicksand(textStyle: 
              TextStyle(fontSize: 30.0, color: ColorsPalette.black))),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: ColorsPalette.black),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.menu, color: ColorsPalette.black),
                onPressed: (){
                  showDialog(barrierDismissible: false, context: context,builder: (_) =>
                  BlocProvider<TripViewOptionsBloc>(
                    create: (context) => TripViewOptionsBloc()..add(ViewOptionUpdated(viewOption ?? 1)),
                      child:  UpdateTripViewDialog(),
                    )
                  ).then((value) {
                    viewOption = sharedPrefsService.readInt(key: viewOptionKey);
                    context.read<TripsBloc>().add(UpdateTripsList((state as TripsSuccessState).allTrips ?? []));
                  });
                },
              )
            ],
            elevation: 0,
            backgroundColor: ColorsPalette.white,
            //backgroundColor: ColorsPalette.freshBlue,
          ),
          body: TripsView(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
            Navigator.pushNamed(context, tripStartPlanningRoute).then((value) => context.read<TripsBloc>().add(GetAllTrips()));
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