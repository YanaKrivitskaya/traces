import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/shared/styles.dart';

import '../../colorsPalette.dart';
import '../../shared/shared.dart';
import 'bloc/trips_bloc.dart';

class TripsView extends StatefulWidget{
  TripsView();
  State<TripsView> createState() => _TripsStateView();
}

class _TripsStateView extends State<TripsView>{

  @override
  Widget build(BuildContext context) {
    return BlocListener<TripsBloc, TripsState>(
      listener: (context, state){},
      child: BlocBuilder<TripsBloc, TripsState>(
        bloc: BlocProvider.of(context),
        builder: (context, state){
          if(state is TripsSuccessState){
            if(state.allTrips.length > 0){
              return Container(
                child: Center(
                  child: Text(state.allTrips.length.toString(), 
                    style: TextStyle(fontSize: 23.0))
                )
              );
            }else{
              return Container(
                child: Center(
                  child: Text('No trips', style: 
                  quicksandStyle(color: ColorsPalette.magentaPurple, fontSize: 30.0))
                )
              );
            }
          }
          return loadingWidget(ColorsPalette.juicyBlue);
        }
      )
    );    
  }

}