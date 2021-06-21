import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

TextStyle patrickStyle({Color? color, double? fontSize}) => 
GoogleFonts.patrickHand(
  textStyle: TextStyle(
            color: color ?? Colors.black, fontSize: fontSize));

TextStyle quicksandStyle({Color? color, double? fontSize, FontWeight? weight}) => 
GoogleFonts.quicksand(
  textStyle: TextStyle(
            color: color ?? Colors.black, fontSize: fontSize, fontWeight: weight ?? FontWeight.normal));