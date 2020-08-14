import 'package:flutter/material.dart';
import 'package:traces/colorsPalette.dart';

typedef void StringCallback(String val);

Widget loadingWidget(Color color) => new Center(
  child: CircularProgressIndicator(
      valueColor: new AlwaysStoppedAnimation<Color>(color)
  ),
);

String getAvatarName(String profileName){
  if(profileName.length <= 3) return profileName.toUpperCase();
  if(profileName.contains(' ')){
    List<String> nameParts = profileName.split(' ');
    String avatarName = '';
    nameParts.forEach((n) {
      avatarName += n.substring(0, 1);
    });
    if(avatarName.length > 3) return avatarName.substring(0, 3);
    return avatarName;
  }else{
    return profileName.substring(0, 1);
  }
}