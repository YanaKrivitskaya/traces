import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:traces/screens/trips/bloc/trips_bloc.dart';
import 'package:traces/shared/shared.dart';
import 'package:traces/shared/styles.dart';
import '../../../colorsPalette.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/trip.dart';
import 'bloc/tripdetails_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TripDetailsView extends StatefulWidget{
  final String tripId;  

  TripDetailsView({this.tripId});

  @override
  _TripDetailsViewViewState createState() => _TripDetailsViewViewState();
}

class _TripDetailsViewViewState extends State<TripDetailsView>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      body: BlocListener<TripDetailsBloc, TripDetailsState>(
        listener: (context, state){

        },
        child: BlocBuilder<TripDetailsBloc, TripDetailsState>(
          builder: (context, state){
            if(state is TripDetailsSuccessState){
              return Container(              
              child: Stack(
                alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    _coverImage(state.trip.coverImageUrl),
                    Positioned(top: 25, left: 10,
                      child: InkWell(
                        onTap: (){Navigator.pop(context);},
                        child:Icon(Icons.arrow_back, color: ColorsPalette.white)
                      ),
                    ),
                    Positioned(top: 25, right: 10,
                      child: InkWell(
                        onTap: (){},
                        child:Icon(Icons.more_vert, color: ColorsPalette.white)
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
                              width: MediaQuery.of(context).size.width * 0.7,
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Column(crossAxisAlignment: CrossAxisAlignment.start ,children: [                                
                                    Text(state.trip.name, style: quicksandStyle(fontSize: 18.0, weight: FontWeight.bold)),
                                    Text('${DateFormat.yMMMd().format(state.trip.startDate)} - ${DateFormat.yMMMd().format(state.trip.endDate)}', style: quicksandStyle(fontSize: 15.0))                                    
                                  ],),
                                  _tripMembers(state.trip.tripMembers)
                                ],),
                              ),
                              ),                            
                            )
                            ),
                          ],
                        ),);                        
            }
            return loadingWidget(ColorsPalette.meditSea);
            
          }
        ),
      )
    );
  }

  Widget _coverImage(String imageUrl) => new Container(
    margin: EdgeInsets.only(bottom: 20.0),
    child: imageUrl != null ? 
      CachedNetworkImage(
        placeholder: (context, url) => _defaultImage(),
        imageUrl: imageUrl,
        colorBlendMode: BlendMode.dstATop,
        color: Colors.black.withOpacity(0.8),
      ) 
      : _defaultImage(),
    decoration: BoxDecoration(
      color: const Color(0xFF4B6584),
    )
  );

  Widget _defaultImage() {
    final String defaultCover = 'assets/sunset.jpg';
    return Image.asset(
          defaultCover,
          colorBlendMode: BlendMode.dstATop,
          color: Colors.black.withOpacity(0.8),
        );
  }

  Widget _tripMembers(List<String> tripMembers){   

    if (tripMembers != null && tripMembers.length > 0){
      return Container(        
        child: Stack(children: [
          _tripMemberAvatar(tripMembers.first),
          tripMembers.length > 1 ? 
          Positioned(top: 0, right: 10,
            child:_tripMemberAvatar(tripMembers.last)                                        )
        : Container()
        ],),
      );
    } return Container();
  }

  Widget _tripMemberAvatar(String name) => Container(
    margin: EdgeInsets.only(left: 10.0),
    decoration: new BoxDecoration(
      shape: BoxShape.circle,
      border: new Border.all(
        color: ColorsPalette.blueHorizon,
        width: 0.5,
      ),
    ),
    child:  CircleAvatar(
      backgroundColor: ColorsPalette.lynxWhite,
      child: Text(name, style: TextStyle(color: ColorsPalette.meditSea, fontSize: 10.0, fontWeight: FontWeight.w300),),
      radius: 15.0
    ),
  );

}

