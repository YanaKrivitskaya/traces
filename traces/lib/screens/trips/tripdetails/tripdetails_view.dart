import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:traces/shared/shared.dart';
import 'package:traces/shared/styles.dart';
import '../../../colorsPalette.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/trip.dart';
import 'bloc/tripdetails_bloc.dart';

class TripDetailsView extends StatefulWidget{
  final String tripId;

  TripDetailsView({this.tripId});

  @override
  _TripDetailsViewViewState createState() => _TripDetailsViewViewState();
}

class _TripDetailsViewViewState extends State<TripDetailsView>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        centerTitle: true,
        /*title: Text('Tr',
          style: quicksandStyle(fontSize: 30.0)),*/
        backgroundColor: ColorsPalette.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorsPalette.meditSea),
          onPressed: ()=> Navigator.pop(context)
      )),*/
      body: BlocListener<TripDetailsBloc, TripDetailsState>(
        listener: (context, state){

        },
        child: BlocBuilder<TripDetailsBloc, TripDetailsState>(
          builder: (context, state){
            return Container(              
              child: Stack(
                alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      child: Image.asset(
                        "assets/sunset.jpg",
                        colorBlendMode: BlendMode.dstATop,
                        color: Colors.black.withOpacity(0.8),
                        ),
                      /*child: Image.asset(
                        "assets/white.jpg",
                        colorBlendMode: BlendMode.dstATop,
                        color: Colors.black.withOpacity(0.9),
                        ),*/
                      decoration: BoxDecoration(
                        color: const Color(0xFF4B6584),
                        ),
                    ),
                    Positioned(top: 25, left: 10,
                      child: InkWell(
                        onTap: (){Navigator.pop(context);},
                        child:Icon(Icons.arrow_back, color: ColorsPalette.white)
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Material(
                          elevation: 10.0,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color:  ColorsPalette.white,
                            child: Container(
                              margin: EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width * 0.7,
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Column(crossAxisAlignment: CrossAxisAlignment.start ,children: [                                
                                    Text('Summer trip', style: quicksandStyle(fontSize: 18.0, weight: FontWeight.bold)),
                                    Text('Apr 23 2021 - Apr 30 2021', style: quicksandStyle(fontSize: 15.0))
                                    /*Text('${DateFormat.yMMMd().format(trip.startDate)} - ${DateFormat.yMMMd().format(trip.endDate)}',
                                      style: quicksandStyle(fontSize: 15.0)),*/
                                  ],),
                                  Column(children: [
                                    Stack(
                                      children: [
                                        Container(
                                          decoration: new BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: new Border.all(
                                              color: ColorsPalette.blueHorizon,
                                              width: 1.0,
                                            ),
                                          ),
                                          child:  CircleAvatar(
                                            backgroundColor: ColorsPalette.lynxWhite,
                                            child: Text("YK", style: TextStyle(color: ColorsPalette.meditSea, fontSize: 10.0, fontWeight: FontWeight.w300),),
                                            radius: 15.0
                                          ),
                                        ),
                                        
                                       Positioned(top: 0, right: 10,
                                        child: CircleAvatar(
                                          backgroundColor: ColorsPalette.lynxWhite,
                                          child: Text("SP", style: TextStyle(color: ColorsPalette.meditSea, fontSize: 10.0, fontWeight: FontWeight.w300),),
                                          radius: 15.0,
                                          
                                      )
                                      ),
                                      ],
                                    )                                                                       
                                  ],)
                                ],),
                              ),
                              ),                            
                            )
                            ),
                          ],
                        ),);
            //return loadingWidget(ColorsPalette.meditSea);
          }
        ),
      )
    );
  }

}

