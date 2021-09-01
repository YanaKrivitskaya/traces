
import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:traces/constants/route_constants.dart';
import 'package:traces/utils/services/shared_preferencies_service.dart';

import '../../../constants/color_constants.dart';
import '../../../utils/style/styles.dart';
import '../../../widgets/widgets.dart';
import '../../profile/model/group_user_model.dart';
import '../model/trip.model.dart';
import '../widgets/trip_delete_alert.dart';
import 'bloc/tripdetails_bloc.dart';
import 'tripMembers/bloc/tripmembers_bloc.dart';
import 'tripMembers/tripMembers_dialog.dart';

import 'package:image_picker/image_picker.dart';

Widget headerCoverWidget(Trip trip, List<GroupUser> familyMembers, BuildContext context, SharedPreferencesService sharedPrefsService, String key) => new Stack(
  alignment: AlignmentDirectional.bottomCenter,
  children: [
    _coverImage(trip.coverImage),
    //back button
    Positioned(top: 35, left: 10,
      child: InkWell(
        onTap: (){
          sharedPrefsService.remove(key: key);
          Navigator.pop(context);
          },
        child:Icon(Icons.arrow_back, color: ColorsPalette.white)
      ),
    ),
    Positioned(top: 20, right: 10,
      child: _popupMenu(trip, context)
    ),
    Positioned(bottom: 0,
      child: _tripInfoCard(trip, familyMembers, context)
    )
  ],
);

Widget _coverImage(Uint8List? imageUrl) => new Container(
    margin: EdgeInsets.only(bottom: 20.0),
    child: imageUrl != null ? 
      /*CachedNetworkImage(
        placeholder: (context, url) => _defaultImage(),
        imageUrl: imageUrl,
        colorBlendMode: BlendMode.dstATop,
        color: Colors.black.withOpacity(0.8),
      ) */Image.memory(imageUrl)
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

Widget _popupMenu(Trip trip, BuildContext context) => PopupMenuButton<int>( 
  icon: Icon(Icons.more_vert, color: ColorsPalette.white,),
  itemBuilder: (context) => [
    PopupMenuItem(
      value: 1,
      child: Text("Change Cover",style: TextStyle(color: ColorsPalette.blueHorizon))),
    PopupMenuItem(
      value: 2,
      child: Text("Delete",style: TextStyle(color: ColorsPalette.meditSea)))],
  onSelected: (value) async{
    if(value == 1){
      _showSelectionDialog(context, trip.id!);
    }
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

Widget _tripInfoCard(Trip trip, List<GroupUser> familyMembers, BuildContext context) => new Container( margin: EdgeInsets.all(10),
  child: Material(
    elevation: 10.0,
    borderRadius: BorderRadius.all(Radius.circular(5)),
    color:  ColorsPalette.white,
    child: Container(
      margin: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width * 0.7,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start ,children: [     
          Container(width: MediaQuery.of(context).size.width * 0.5,child: Text(trip.name!, style: quicksandStyle(fontSize: 18.0, weight: FontWeight.bold)),),                        
          
          Text('${DateFormat.yMMMd().format(trip.startDate!)} - ${DateFormat.yMMMd().format(trip.endDate!)}', style: quicksandStyle(fontSize: 15.0))                                    
        ],),
        InkWell( child: _tripMembers(trip.users, familyMembers),
          onTap: (){ showDialog(
            barrierDismissible: false, 
            context: context, 
            builder: (_) =>
              BlocProvider<TripMembersBloc>(
                create: (context) => TripMembersBloc()..add(GetMembers(trip.id)),
                  child: TripMembersDialog(
                    trip: trip,
                    callback: (val) =>
                      val == 'Update' ? context.read<TripDetailsBloc>().add(GetTripDetails(trip.id!)) : '',
                  )));
          })
      ])
    )),
);

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

  Future selectOrTakePhoto(ImageSource imageSource, BuildContext context, int tripId) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: imageSource);

    if(pickedFile != null){
      Navigator.pushNamed(context, imageCropRoute, arguments: File(pickedFile.path)).then((imageFile) {
        if(imageFile != null){
          context.read<TripDetailsBloc>().add(GetImage(imageFile as File));
        } 
        
        //context.read<TripDetailsBloc>().add(GetTripDetails(tripId));
      });
    }

    /*setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        Navigator.pushNamed(context, routeEdit, arguments: _image);
      } else
        print('No photo was selected or taken');
    });*/
  }

  Future _showSelectionDialog(BuildContext context, int tripId) async {
    await showDialog(
      context: context,
      builder: (_) => new SimpleDialog(
        title: Text('Select photo'),
        children: <Widget>[
          SimpleDialogOption(
            child: Text('From gallery'),
            onPressed: () {
              selectOrTakePhoto(ImageSource.gallery, context, tripId);
              Navigator.pop(context);
            },
          ),
          SimpleDialogOption(
            child: Text('Take a photo'),
            onPressed: () {
              selectOrTakePhoto(ImageSource.camera, context, tripId);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }