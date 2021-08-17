import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/constants/route_constants.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:traces/utils/style/styles.dart';
import 'package:traces/widgets/widgets.dart';

import '../../constants/color_constants.dart';
import 'bloc/trips_bloc.dart';
//import 'package:timelines/timelines.dart';

class TripsView extends StatefulWidget{
  TripsView();
  State<TripsView> createState() => _TripsStateView();
}

class _TripsStateView extends State<TripsView>{

  @override
  Widget build(BuildContext context) {
    return BlocListener<TripsBloc, TripsState>(
      listener: (context, state){
        
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
                  itemCount: state.allTrips!.length,
                  itemBuilder: (context, position){
                    final trip = state.allTrips![position];                    
                    return  Container(
                      margin: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width * 0.8,
                      //height: MediaQuery.of(context).size.height * 0.3,
                      child: InkWell(
                        child: Container(child: Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: [
                            Container(
                              padding: EdgeInsets.only(bottom: 20.0),
                              child: trip.coverImage != null ? CachedNetworkImage(
                                placeholder: (context, url) => Image.asset("assets/sunset.jpg"),
                                //placeholder: (context, url) => loadingWidget(ColorsPalette.meditSea),
                                imageUrl: trip.coverImage!,
                              ) : Image.asset("assets/sunset.jpg")                            
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
                                ],),
                              ),
                              ),
                            )
                            ),
                          ],
                        )),
                        onTap: (){
                          Navigator.pushNamed(context, tripDetailsRoute, arguments: trip.id).then((value) => {
                            context.read<TripsBloc>().add(GetAllTrips())
                          });
                        },
                      )
                    );},
                )]),
              ),
              );
              /*Column(children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: Timeline.tileBuilder(
                    theme: TimelineThemeData(
                      direction: Axis.horizontal,
                      connectorTheme: ConnectorThemeData(                        
                        thickness: 3.0,
                      ),
                    ),
                    builder: TimelineTileBuilder.fromStyle(
                      itemExtentBuilder: (_, __) =>
              MediaQuery.of(context).size.width / 5,                      
                      indicatorStyle: IndicatorStyle.outlined,
                      contentsAlign: ContentsAlign.basic,
                      contentsBuilder: (context, index) => Text('2021'),                      
                      itemCount: 5,
                    ),
                  ),),                
                
                
              ],);*/ 
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

}