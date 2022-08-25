import 'dart:io';

import 'package:flutter/material.dart';
import 'package:traces/constants/color_constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:traces/screens/trips/model/expense.model.dart';

typedef void StringCallback(String val);

typedef void ExpenseCallback(Expense? val);

typedef void ImageCallback(File? val);

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return this.year == other.year && this.month == other.month
           && this.day == other.day;
  }
}

int daysBetween(DateTime from, DateTime to) {
     from = DateTime(from.year, from.month, from.day);
     to = DateTime(to.year, to.month, to.day);
   return (to.difference(from).inHours / 24).round();
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

Widget avatar(String username, double radius, Color fontColor, double fontSize, Color? backColor) => new CircleAvatar(
      backgroundColor: fontColor,
      child: CircleAvatar(
        backgroundColor: backColor ?? ColorsPalette.lynxWhite,
        child: Text(
          getAvatarName(username),
          style: TextStyle(
              color: fontColor,
              fontSize: fontSize,            
              fontWeight: FontWeight.w300),
        ),
        radius: radius),
      radius: radius + radius * 0.05 );

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

