import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:traces/screens/profile/model/member.dart';
import 'package:traces/screens/trips/tripdetails/tripMembers/bloc/tripmembers_bloc.dart';
import 'package:traces/screens/trips/tripdetails/tripMembers/tripMembers_dialog.dart';
import 'package:traces/shared/shared.dart';
import 'package:traces/shared/styles.dart';
import '../../../colorsPalette.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                                  InkWell(
                                    child: _tripMembers(state.trip.tripMembers, state.familyMembers),
                                    onTap: (){
                                      showDialog(
                                        barrierDismissible: false, context: context, builder: (_) =>
                                        BlocProvider<TripMembersBloc>(
                                          create: (context) => TripMembersBloc()
                                            ..add(GetMembers(state.trip.id)),
                                          child: TripMembersDialog(trip: state.trip)
                                        ),                                        
                                      );
                                    },
                                  )                                  
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

  Widget _tripMembers(List<String> tripMembers, List<Member> familyMembers){   

    if (tripMembers != null && tripMembers.length > 0){
      return Container(        
        child: Stack(children: [
          _tripMemberAvatar(tripMembers.first, familyMembers),
          tripMembers.length > 1 ? 
          Positioned(top: 0, right: 10,
            child:_tripMemberAvatar(tripMembers.last, familyMembers)                                        )
        : Container()
        ],),
      );
    } return Container();
  }

  Widget _tripMemberAvatar(String memberId, List<Member> familyMembers) => Container(
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
      child: Text(getAvatarName(familyMembers.firstWhere((m) => m.id == memberId).name), 
        style: TextStyle(color: ColorsPalette.meditSea, fontSize: 10.0, fontWeight: FontWeight.w300),),
      radius: 15.0
    ),
  );

}

