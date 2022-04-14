import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:traces/constants/color_constants.dart';
import 'package:traces/screens/notes/screens/note_page.dart';

class NotesImageView extends StatelessWidget{
  final Uint8List image;

  NotesImageView(this.image);

  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: ColorsPalette.white),
            onPressed: (){
              Navigator.pop(context);
            },
          ),          
          elevation: 0,
          backgroundColor: ColorsPalette.black,
      ),
      backgroundColor: ColorsPalette.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [        
          Image.memory(image,
            fit: BoxFit.cover,
              //height: double.infinity,
              //width: double.infinity,
              alignment: Alignment.center,
            )
      ],
    ));
  }
}