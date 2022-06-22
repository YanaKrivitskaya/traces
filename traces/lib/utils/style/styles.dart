import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

final double fullWidth = 100.w;
final double fullheight = 100.h;

//ANCHOR Font Size
final double headerFontSize = 25.sp; // View headers
final double smallHeaderFontSize = 20.sp; // View headers
final double accentFontSize = 16.sp; // Form headers
final double fontSize = 14.sp; // Form fields
final double fontSizesm = 12.sp;

//ANCHOR Padding
final double buttonPadding = 7.w; // Button padding
final double viewPadding = 4.w;
final double borderPadding = 3.w; // Border padding
final double formBottomPadding = 4.h;
final double formTopPadding = 20.h;
final double imageCoverPadding = 2.5.h;

//ANCHOR Width
final double formWidth60 = 60.w;
final double formWidth70 = 70.w;
final double viewWidth80 = 80.w;
final double tripItemWidth35 = 35.w;

// ANCHOR Height 
final double loginFormHeight = 60.h; 
final double tripItemHeight = 10.h; 

//ANCHOR Sizer
final double sizerHeightsm = 1.h;
final double sizerHeight = 1.5.h;
final double sizerHeightlg = 2.h;

//ANCHOR Images&Icons
final double homeIconSize = 12.5.w;
final double homeBigIconSize = 16.w;
final double noTripsIconSize = 50.w;
final double iconSize = 10.w;



TextStyle patrickStyle({Color? color, double? fontSize}) => 
GoogleFonts.patrickHand(
  textStyle: TextStyle(
            color: color ?? Colors.black, fontSize: fontSize));

TextStyle quicksandStyle({Color? color, double? fontSize, FontWeight? weight, TextDecoration? decoration}) => 
GoogleFonts.quicksand(
  textStyle: TextStyle(
    color: color ?? Colors.black, 
    fontSize: fontSize, 
    fontWeight: weight ?? FontWeight.normal, 
    decoration: decoration ?? null));