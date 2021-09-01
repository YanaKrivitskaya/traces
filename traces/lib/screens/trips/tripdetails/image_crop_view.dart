import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:traces/constants/color_constants.dart';
import 'package:traces/screens/trips/tripdetails/bloc/tripdetails_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/widgets/widgets.dart';


class ImageCropView extends StatefulWidget {
  final File image;
 // final ImageCallback? callback;

  const ImageCropView(this.image/*, this.callback*/);

  @override
  _ImageCropViewState createState() => _ImageCropViewState();
}

class _ImageCropViewState extends State<ImageCropView> {
  File? imageFile;

  @override
  void initState() {
    super.initState();
    imageFile = widget.image;
    if (imageFile != null) _cropImage();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TripDetailsBloc, TripDetailsState>(
      builder: (context, state){        
        return Container();
      }
    );
  }

Future<Null> _cropImage() async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile!.path,
        compressQuality: 50,
        aspectRatio: CropAspectRatio(ratioX: 16, ratioY: 9),
        androidUiSettings: AndroidUiSettings(            
            toolbarTitle: 'Crop Image',
            toolbarColor: ColorsPalette.juicyGreen,
            hideBottomControls: false,
            toolbarWidgetColor: ColorsPalette.white,
            backgroundColor: ColorsPalette.white,
            initAspectRatio: CropAspectRatioPreset.ratio16x9,            
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));

    if (croppedFile != null) {
      //imageFile = croppedFile;
      //context.read<TripDetailsBloc>().add(GetImage(imageFile));
      // widget.callback!(croppedFile);
      Navigator.pop(context, croppedFile);
    }else{
      Navigator.pop(context, null);
    }

  }
}