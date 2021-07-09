import 'package:flutter/material.dart';
import 'package:traces/constants/color_constants.dart';
import 'package:traces/utils/api/customException.dart';
import 'package:traces/utils/style/styles.dart';

Widget errorWidget(BuildContext context, {double? iconSize, Color? color, required CustomException error, double? fontSize}) => Container(
  child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    error is FetchDataException ?
      Icon(Icons.error_outline, size: iconSize ?? 50.0, color: color ?? ColorsPalette.meditSea)
    : error is ConnectionException ?
      Icon(Icons.wifi_off, size: iconSize ?? 50.0, color: color ?? ColorsPalette.meditSea)
    : error is BadRequestException ?
      Icon(Icons.report_problem_outlined, size: iconSize ?? 50.0, color: color ?? ColorsPalette.meditSea)
    : error is UnauthorizedException ?
      Icon(Icons.report_problem_outlined, size: iconSize ?? 50.0, color: color ?? ColorsPalette.meditSea)
    : error is ForbiddenException ?
      Icon(Icons.report_problem_outlined, size: iconSize ?? 50.0, color: color ?? ColorsPalette.meditSea)
    : Icon(Icons.report_problem_outlined, size: iconSize ?? 50.0, color: color ?? ColorsPalette.meditSea),
    Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
      Container(padding: EdgeInsets.symmetric(horizontal: 10.0), 
        width:  MediaQuery.of(context).size.width * 0.9,
        child:  Text(
          error.toString(), 
          style: quicksandStyle(fontSize: fontSize ?? 20.0),
          overflow: TextOverflow.ellipsis,
          maxLines: 5
      )),
     
    ],)
    
  ],)),
);