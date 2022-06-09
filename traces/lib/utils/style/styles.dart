import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

final double headerFontSize = 25.sp;
final double fontSize = 14.sp;
final double accentFontSize = 16.sp;

TextStyle patrickStyle({Color? color, double? fontSize}) => 
GoogleFonts.patrickHand(
  textStyle: TextStyle(
            color: color ?? Colors.black, fontSize: fontSize));

TextStyle quicksandStyle({Color? color, double? fontSize, FontWeight? weight, TextDecoration? decoration}) => 
GoogleFonts.quicksand(
  textStyle: TextStyle(
            color: color ?? Colors.black, fontSize: fontSize, fontWeight: weight ?? FontWeight.normal, decoration: decoration ?? null));