import 'package:flutter/material.dart';

class VisasView extends StatefulWidget {
  VisasView({Key key}) : super(key: key);

  @override
  _VisasViewState createState() => _VisasViewState();
}

class _VisasViewState extends State<VisasView> with SingleTickerProviderStateMixin{

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Container(
        child: SingleChildScrollView(
          child: Container(

          ),
        ),
      )
    );
  }
}