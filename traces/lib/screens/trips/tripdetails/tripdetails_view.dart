import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:traces/screens/profile/model/group_user_model.dart';
import 'package:traces/screens/trips/model/trip.model.dart';
import 'package:traces/screens/trips/tripdetails/tripMembers/bloc/tripmembers_bloc.dart';
import 'package:traces/screens/trips/tripdetails/tripMembers/tripMembers_dialog.dart';
import 'package:traces/screens/trips/widgets/trip_delete_alert.dart';
import 'package:traces/utils/style/styles.dart';
import 'package:traces/widgets/widgets.dart';
import '../../../constants/color_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/tripdetails_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:timeline_tile/timeline_tile.dart';


class TripDetailsView extends StatefulWidget{
  final int? tripId;  

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
              return Column(children: [
                Stack(
                alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    _coverImage(state.trip.coverImage),
                    Positioned(top: 25, left: 10,
                      child: InkWell(
                        onTap: (){Navigator.pop(context);},
                        child:Icon(Icons.arrow_back, color: ColorsPalette.white)
                      ),
                    ),
                    Positioned(top: 25, right: 10,
                      child: _popupMenu(state.trip)
                    ),
                    Positioned(bottom: 0,
                      child: Container( margin: EdgeInsets.all(10),
                        child: Material(
                          elevation: 10.0,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color:  ColorsPalette.white,
                            child: Container(
                              margin: EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width * 0.7,
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Column(crossAxisAlignment: CrossAxisAlignment.start ,children: [                                
                                    Text(state.trip.name!, style: quicksandStyle(fontSize: 18.0, weight: FontWeight.bold)),
                                    Text('${DateFormat.yMMMd().format(state.trip.startDate!)} - ${DateFormat.yMMMd().format(state.trip.endDate!)}', style: quicksandStyle(fontSize: 15.0))                                    
                                  ],),
                                  InkWell(
                                    child: _tripMembers(state.trip.users, state.familyMembers),
                                    onTap: (){
                                      showDialog(
                                        barrierDismissible: false, context: context, builder: (_) =>
                                        BlocProvider<TripMembersBloc>(
                                          create: (context) => TripMembersBloc()
                                            ..add(GetMembers(state.trip.id)),
                                          child: TripMembersDialog(
                                            trip: state.trip,
                                            callback: (val) =>
                                              val == 'Update' ? context.read<TripDetailsBloc>().add(GetTripDetails(widget.tripId!)) : '',
                                          )));
                                  })
                                ])
                              )),
                    )),
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Container(                    
                      padding: EdgeInsets.all(10.0),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Description:', style: quicksandStyle(fontSize: 18.0, weight: FontWeight.bold)),
                        Text('${state.trip.description}', style: quicksandStyle(fontSize: 15.0),),
                      ],)
                    )
                  ],)                  
                  /*Expanded(
                    child: Padding(padding: EdgeInsets.only(bottom: 40.0), child: 
                      _timelineDays(state.trip)
                    )
                  ),*/
              ]);
              //return ;
            }
            return loadingWidget(ColorsPalette.meditSea);            
          }
        ),
      )
    );
  }

  Widget _coverImage(String? imageUrl) => new Container(
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

  Widget _tripMembers(List<GroupUser>? tripMembers, List<GroupUser> familyMembers){   

    if (tripMembers != null && tripMembers.length > 0){
      return Container(        
        child: Stack(children: [
          _tripMemberAvatar(tripMembers.first.userId!, familyMembers),
          tripMembers.length > 1 ? 
          Positioned(top: 0, right: 10,
            child:_tripMemberAvatar(tripMembers.last.userId!, familyMembers)                                        )
        : Container()
        ],),
      );
    } return Container();
  }

  Widget _tripMemberAvatar(int memberId, List<GroupUser> familyMembers) => Container(
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
      child:Text(getAvatarName(familyMembers.firstWhere((m) => m.userId == memberId).name), 
        style: TextStyle(color: ColorsPalette.meditSea, fontSize: 10.0, fontWeight: FontWeight.w300)),
      radius: 15.0
    ),
  );

  Widget _popupMenu(Trip trip) => PopupMenuButton<int>(
    itemBuilder: (context) => [
      PopupMenuItem(
        value: 1,
        child: Text("Change Cover",style: TextStyle(color: ColorsPalette.blueHorizon))),
      PopupMenuItem(
        value: 2,
        child: Text("Delete",style: TextStyle(color: ColorsPalette.meditSea)))],
    onSelected: (value) async{
      if(value == 2){
        showDialog<String>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (_) => BlocProvider.value(
            value: context.read<TripDetailsBloc>(),
            child: TripDeleteAlert(
              trip: trip,
              callback: (val) =>
                val == 'Delete' ? Navigator.of(context).pop() : '',
            ),
          ));
      }},); 

      Widget _timelineDays(Trip trip){
        return Container(child: ListView.builder(
          shrinkWrap: true,         
          itemCount: trip.days!.length,
          itemBuilder: (context, position){
            final day = trip.days![position];     
            return TimelineTile(
              alignment: TimelineAlign.manual,
              lineXY: 0.1,
              isFirst: position == 0,
              isLast: position == trip.days!.length,
              indicatorStyle: const IndicatorStyle(
                width: 20,
                color: Color(0xFF27AA69),
                padding: EdgeInsets.all(6),
              ),
              endChild: Card(child: Text('${day.name} - ${DateFormat.yMMMd().format(day.date!)}'),),
              beforeLineStyle: const LineStyle(
                color: Color(0xFF27AA69),
              ),
            );
          }
        )
        );
      }
}



