import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/shared/styles.dart';
import 'package:intl/intl.dart';
//import 'package:cached_network_image/cached_network_image.dart';

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
              return SingleChildScrollView(
                child: Container(child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: state.allTrips.length,
                  itemBuilder: (context, position){
                    final trip = state.allTrips[position];
                    print(trip.coverImageUrl);
                    return  Container(
                      margin: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width * 0.8,
                      //height: MediaQuery.of(context).size.height * 0.3,
                      child: Container(child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Container(
                            padding: EdgeInsets.only(bottom: 20.0),
                            /*child: CachedNetworkImage(
                              placeholder: (context, url) => loadingWidget(ColorsPalette.meditSea),
                              imageUrl: 'https://picsum.photos/250?image=9',
                            ),*/
                            child: Image.network(                              
                              trip.coverImageUrl,                              
                              fit: BoxFit.cover,
                              loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
                                if (loadingProgress == null) return child;
                                  return loadingWidget(ColorsPalette.meditSea);
                                },
                              ),
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
                                Text(trip.name, style: quicksandStyle(fontSize: 18.0, weight: FontWeight.bold)),
                                Text('${DateFormat.yMMMd().format(trip.startDate)} - ${DateFormat.yMMMd().format(trip.endDate)}',
                                  style: quicksandStyle(fontSize: 15.0)),
                              ],),
                            ),
                            ),                            
                          )
                          ),                         
                        ],
                      ))                                     
                    );                    
                  },
                )),
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

}