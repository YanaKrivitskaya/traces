import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/constants/route_constants.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:traces/screens/trips/model/trip.model.dart';
import 'package:traces/utils/style/styles.dart';
import 'package:traces/widgets/widgets.dart';

import '../../constants/color_constants.dart';
import '../../utils/services/shared_preferencies_service.dart';
import 'bloc/trips_bloc.dart';
//import 'package:timelines/timelines.dart';

class TripsView extends StatefulWidget{
  TripsView();
  State<TripsView> createState() => _TripsStateView();
}

class _TripsStateView extends State<TripsView>{
  List<Trip> trips = List.empty();

  final SharedPreferencesService sharedPrefsService = SharedPreferencesService();
  final String viewOptionKey = "tripViewOption";
  var viewOption;  

  @override
  Widget build(BuildContext context) {
    return BlocListener<TripsBloc, TripsState>(
      listener: (context, state){
        if(state is TripsSuccessState && state.allTrips !=null && state.allTrips!.length > 0){
          trips = _sortTrips(state.allTrips!);
          viewOption = sharedPrefsService.readInt(key: viewOptionKey);
        }
      },
      child: BlocBuilder<TripsBloc, TripsState>(
        bloc: BlocProvider.of(context),
        builder: (context, state){
          if(state is TripsLoadingState){
            return loadingWidget(ColorsPalette.juicyBlue);
          }
          if(state is TripsSuccessState){
            if(state.allTrips !=null && state.allTrips!.length > 0){              
              return Container(
                padding: EdgeInsets.only(bottom: 15.0),
                child: SingleChildScrollView(
                child: Column(children: [
                  ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: trips.length,
                  itemBuilder: (context, position){
                    final trip = trips[position];                    
                    return  Container(
                      margin: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width * 0.8,
                      //height: MediaQuery.of(context).size.height * 0.3,
                      child: InkWell(
                        child: viewOption == 2 ? _compactTripsViewItem(trip) : _comfyTripsListItem(trip),
                        onTap: (){
                          Navigator.pushNamed(context, tripDetailsRoute, arguments: trip.id).then((value) => {
                            context.read<TripsBloc>().add(GetAllTrips())
                          });
                        }
                      )
                    );},
                )]),
              ),
              );              
            }else{
              return Center(
                child: Center(
                  child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
                    Image(image: AssetImage('assets/signpost.png'), height: 200.0, width: 200.0,),
                    SizedBox(height: 15.0),
                    Text("You don't have any trips yet", style: 
                  quicksandStyle(color: ColorsPalette.magentaPurple, fontSize: 20.0))
                  ]                  
                ))
              );
            }
          }
          return loadingWidget(ColorsPalette.juicyBlue);
        }
      )
    );    
  }

  Widget _comfyTripsListItem(Trip trip) => Container(child: Stack(
    alignment: AlignmentDirectional.bottomCenter,
    children: [
      Container(
        padding: EdgeInsets.only(bottom: 20.0),
        child: trip.coverImage != null ? /*CachedNetworkImage(
          placeholder: (context, url) => Image.asset("assets/sunset.jpg"),
          //placeholder: (context, url) => loadingWidget(ColorsPalette.meditSea),
          imageUrl: trip.coverImage!,)*/ Image.memory(trip.coverImage!) : Image.asset("assets/sunset.jpg")                            
        ),
      Positioned(
        bottom: 0,
          child: Container(
            margin: EdgeInsets.all(10),
            child: Material(
              elevation: 10.0,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color:  ColorsPalette.white,
              child: Container(
                margin: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width * 0.6,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start ,children: [                                
                  Text(trip.name!, style: quicksandStyle(fontSize: 18.0, weight: FontWeight.bold)),
                  Text('${DateFormat.yMMMd().format(trip.startDate!)} - ${DateFormat.yMMMd().format(trip.endDate!)}',
                  style: quicksandStyle(fontSize: 15.0)),
                ],)
              )
            )
          )
      )
    ]
  ));

  Widget _compactTripsViewItem(Trip trip) => Container(
    height: MediaQuery.of(context).size.height * 0.1,
    child: Row(children: [
      Container(
        child: trip.coverImage != null ? /*CachedNetworkImage(
          placeholder: (context, url) => Image.asset("assets/sunset.jpg"),
          //placeholder: (context, url) => loadingWidget(ColorsPalette.meditSea),
          imageUrl: trip.coverImage!,)*/ Image.memory(trip.coverImage!) : Image.asset("assets/sunset.jpg")                            
      ),
      Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start ,children: [                                
          Text(trip.name!, style: quicksandStyle(fontSize: 18.0, weight: FontWeight.bold)),
          Text('${DateFormat.yMMMd().format(trip.startDate!)} - ${DateFormat.yMMMd().format(trip.endDate!)}',
          style: quicksandStyle(fontSize: 15.0)),
        ],),
      ),
      
      
    ]),
  );

}

List<Trip> _sortTrips(List<Trip> trips) {
    trips.sort((a, b) {
      return b.startDate!.millisecondsSinceEpoch
          .compareTo(a.startDate!.millisecondsSinceEpoch);
    });
    return trips;
  }