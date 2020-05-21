import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../colorsPalette.dart';

import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:geolocator/geolocator.dart';

class MapPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return new _MapPageState();
  }
}

class _MapPageState extends State<MapPage>{

  final CameraPosition _kInitialPosition;
  //final CameraTargetBounds _cameraTargetBounds;
  static double defaultZoom = 12.0;

  CameraPosition _position;
  MapboxMapController mapController;
  bool _isMoving = false;
  bool _compassEnabled = true;
  MinMaxZoomPreference _minMaxZoomPreference =
  const MinMaxZoomPreference(1.0, 18.0);

  String _styleString = "mapbox://styles/yani8k/ck5hvc5ew0gqa1io94ihaagg0";
  bool _rotateGesturesEnabled = true;
  bool _scrollGesturesEnabled = true;
  bool _tiltGesturesEnabled = false;
  bool _zoomGesturesEnabled = true;
  bool _myLocationEnabled = false;
  MyLocationTrackingMode _myLocationTrackingMode = MyLocationTrackingMode.None;

  _MapPageState._(
      this._kInitialPosition, this._position/*, this._cameraTargetBounds*/);

  static CameraPosition _getCameraPosition()  {
    final latLng = LatLng(38.736946, -9.142685);
    return CameraPosition(
      target: latLng,
      zoom: defaultZoom,
    );
  }

  factory _MapPageState() {
    CameraPosition cameraPosition = _getCameraPosition();

    /*final cityBounds = LatLngBounds(
      southwest: LatLng(38.672152, -9.182957),
      northeast: LatLng(38.761567, -9.094659),
    );*/


    return _MapPageState._(
        cameraPosition, cameraPosition/*, CameraTargetBounds(cityBounds)*/);
  }

  void _onMapChanged() {
    setState(() {
      _extractMapInfo();
    });
  }

  void _extractMapInfo() {
    _position = mapController.cameraPosition;
    _isMoving = mapController.isCameraMoving;
  }

  @override
  void dispose() {
    if (mapController != null) {
      mapController.removeListener(_onMapChanged);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /*return Container(
      child: _buildMapBox(context),
    );*/
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Map',
            style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.lynxWhite, fontSize: 40.0))
        ),
        centerTitle: true,
        backgroundColor: ColorsPalette.boyzone,
      ),
      body: Center(
        child: _buildMapBox(context),
      ),
    );
  }

  MapboxMap _buildMapBox(BuildContext context) {
    return MapboxMap(
        onMapCreated: onMapCreated,
        initialCameraPosition: this._kInitialPosition,
        trackCameraPosition: true,
        compassEnabled: _compassEnabled,
        //cameraTargetBounds: _cameraTargetBounds,
        minMaxZoomPreference: _minMaxZoomPreference,
        styleString: _styleString,
        rotateGesturesEnabled: _rotateGesturesEnabled,
        scrollGesturesEnabled: _scrollGesturesEnabled,
        tiltGesturesEnabled: _tiltGesturesEnabled,
        zoomGesturesEnabled: _zoomGesturesEnabled,
        myLocationEnabled: _myLocationEnabled,
        myLocationTrackingMode: _myLocationTrackingMode,
        onCameraTrackingDismissed: () {
          this.setState(() {
            _myLocationTrackingMode = MyLocationTrackingMode.None;
          });
        });
  }

  void onMapCreated(MapboxMapController controller) {
    mapController = controller;
    mapController.addListener(_onMapChanged);
    _extractMapInfo();
    setState(() {});
  }

  /*@override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Map',
          style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.grayLight, fontSize: 40.0))
        ),
        centerTitle: true,
        backgroundColor: ColorsPalette.boyzone,
      ),
      body: Center(

      ),
    );
  }*/
}