import 'package:flutter/material.dart';
import 'package:traces/constants/color_constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

typedef void StringCallback(String val);

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return this.year == other.year && this.month == other.month
           && this.day == other.day;
  }
}

Widget transportIcon(String? transport, Color color) => new Container(
    child: transport == 'Train' ? FaIcon(FontAwesomeIcons.train, color: color)
        : transport == 'Plane' ? FaIcon(FontAwesomeIcons.plane, color: color)
        : transport =='Car/Bus' ? FaIcon(FontAwesomeIcons.car, color: color)
        : transport =='Bus' ? FaIcon(FontAwesomeIcons.bus, color: color)
        : transport == 'Ship' ? FaIcon(FontAwesomeIcons.ship, color: color)
        : transport == 'On foot' ? FaIcon(FontAwesomeIcons.walking, color: color)
        : Container()
);

Widget loadingWidget(Color color) => new Center(
  child: CircularProgressIndicator(
      valueColor: new AlwaysStoppedAnimation<Color>(color)
  ),
);

Widget avatar(String username, double? radius, Color fontColor, double fontSize) => new CircleAvatar(
      backgroundColor: ColorsPalette.lynxWhite,
      child: Text(
        getAvatarName(username),
        style: TextStyle(
            color: fontColor,
            fontSize: fontSize,
            fontWeight: FontWeight.w300),
      ),
      radius: radius);

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

