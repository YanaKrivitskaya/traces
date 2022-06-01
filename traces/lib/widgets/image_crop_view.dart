import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:traces/constants/color_constants.dart';
import 'package:traces/screens/trips/tripdetails/bloc/tripdetails_bloc.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

class ImageCropArguments {
  final File file;
  final int compress;
  ImageCropArguments({
    required this.file,
    required this.compress,
  });
}

class ImageCropView extends StatefulWidget {
  final File image;
  final int compress;

  const ImageCropView(this.image, this.compress);

  @override
  _ImageCropViewState createState() => _ImageCropViewState();
}

class _ImageCropViewState extends State<ImageCropView> {
  File? imageFile;

  @override
  void initState() {
    super.initState();
    imageFile = widget.image;
    if (imageFile != null) _cropImage(widget.compress);
  }

  @override
  Widget build(BuildContext context) {    
    return Container();
  }

Future<Null> _cropImage(int compress) async {

    File compressedFile = await FlutterNativeImage.compressImage(imageFile!.path,
    quality: compress < 100 ? compress : 100);
  
    CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: compressedFile.path,       
        aspectRatio: CropAspectRatio(ratioX: 16, ratioY: 9),        
        uiSettings: [
          AndroidUiSettings(            
            toolbarTitle: 'Crop Image',
            toolbarColor: ColorsPalette.juicyYellow,
            hideBottomControls: false,
            toolbarWidgetColor: ColorsPalette.white,
            backgroundColor: ColorsPalette.white,
            initAspectRatio: CropAspectRatioPreset.ratio16x9,            
            lockAspectRatio: true),
          IOSUiSettings(
            title: 'Cropper',
          )]);

    if (croppedFile != null) {     
      Navigator.pop(context, croppedFile);
    }else{
      Navigator.pop(context, null);
    }

  }
}