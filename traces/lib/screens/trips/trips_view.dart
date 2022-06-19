import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/constants/route_constants.dart';
import 'package:intl/intl.dart';
import 'package:traces/screens/trips/model/trip.model.dart';
import 'package:traces/utils/style/styles.dart';
import 'package:traces/widgets/widgets.dart';

import '../../constants/color_constants.dart';
import '../../utils/services/shared_preferencies_service.dart';
import 'bloc/trips_bloc.dart';
//import 'package:timelines/timelines.dart';

class TripsView extends StatefulWidget{
  TripsView();
  State<TripsView> createState() => _TripsStateView();
}

class _TripsStateView extends State<TripsView> with TickerProviderStateMixin{
  List<Trip> trips = List.empty();

  late TabController tabController;

  String tripTabKey = "tripViewTab";
 
  final List<Tab> viewTabs = <Tab>[
    Tab(text: 'ALL'),
    Tab(text: 'UPCOMING'),
    Tab(text: 'PAST')    
  ];

  final SharedPreferencesService sharedPrefsService = SharedPreferencesService();
  final String viewOptionKey = "tripViewOption";
  var viewOption;  

   @override
  void initState() {
    super.initState();
    tabController = TabController(length: viewTabs.length, vsync: this);
    tabController.addListener(handleTabSelection);
  }

   void handleTabSelection() {
    if(tabController.index != tabController.previousIndex){
      context.read<TripsBloc>().add(TabUpdated(tabController.index));
    }    
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TripsBloc, TripsState>(
      listener: (context, state){
        if(state is TripsSuccessState && state.allTrips !=null && state.allTrips!.length > 0){
          trips = _sortTrips(state.allTrips!, state.activeTab);
          viewOption = sharedPrefsService.readInt(key: viewOptionKey);
        }
      },
      child: BlocBuilder<TripsBloc, TripsState>(
        bloc: BlocProvider.of(context),
        builder: (context, state){
          if(state is TripsLoadingState){
            return loadingWidget(ColorsPalette.juicyBlue);
          }
          if(state is TripsSuccessState){
            if(state.allTrips !=null && state.allTrips!.length > 0){              
              return Container(
                padding: EdgeInsets.only(bottom: viewPadding),
                child: SingleChildScrollView(
                child: Column(children: [
                  TabBar(
                    isScrollable: true,              
                    controller: tabController,
                    indicatorColor: Theme.of(context).colorScheme.secondary,
                    tabs: viewTabs
                  ),                  
                  ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: trips.length,
                  itemBuilder: (context, position){
                    final trip = trips[position];                    
                    return  Container(
                      margin: EdgeInsets.all(borderPadding),
                      width: viewWidth,
                      //height: MediaQuery.of(context).size.height * 0.3,
                      child: InkWell(
                        child: viewOption == 2 ? _compactTripsViewItem(trip) : _comfyTripsListItem(trip),
                        onTap: (){
                          Navigator.pushNamed(context, tripDetailsRoute, arguments: trip.id).then((value) => {
                            context.read<TripsBloc>().add(GetAllTrips())
                          });
                        }
                      )
                    );},
                )]),
              ),
              );              
            }else{
              return Center(
                child: Center(
                  child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
                    Image(image: AssetImage('assets/signpost.png'), height: noTripsIconSize, width: noTripsIconSize,),
                    SizedBox(height: sizerHeightlg),
                    Text("You don't have any trips", style: 
                  quicksandStyle(color: ColorsPalette.juicyBlue, fontSize: accentFontSize))
                  ]                  
                ))
              );
            }
          }
          return loadingWidget(ColorsPalette.juicyBlue);
        }
      )
    );    
  }

  Widget _comfyTripsListItem(Trip trip) => Container(child: Stack(
    alignment: AlignmentDirectional.bottomCenter,
    children: [
      Container(
        padding: EdgeInsets.only(bottom: imageCoverPadding),
        child: trip.coverImage != null ? Image.memory(trip.coverImage!) : Image.asset("assets/sunset.jpg")                            
        ),
      Positioned(
        bottom: 0,
          child: Container(
            margin: EdgeInsets.all(sizerHeight),
            child: Material(
              elevation: 10.0,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color:  ColorsPalette.white,
              child: Container(
                margin: EdgeInsets.all(sizerHeight),
                width: MediaQuery.of(context).size.width * 0.6,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start ,children: [                                
                  Text(trip.name!, style: quicksandStyle(fontSize: fontSize, weight: FontWeight.bold)),
                  Text(trip.endDate!.isAfter(trip.startDate!) ? 
                    '${DateFormat.yMMMd().format(trip.startDate!)} - ${DateFormat.yMMMd().format(trip.endDate!)}' 
                    : '${DateFormat.yMMMd().format(trip.startDate!)}',  
                    style: quicksandStyle(fontSize: fontSizesm)),
                ],)
              )
            )
          )
      )
    ]
  ));

  Widget _compactTripsViewItem(Trip trip) => Container(
    height: tripItemHeight,
    child: Row(children: [
      Container(
        width: tripItemWidth,
        child: trip.coverImage != null ? Image.memory(trip.coverImage!) : Image.asset("assets/sunset.jpg")                            
      ),
      Expanded(child: Container(
        margin: EdgeInsets.symmetric(horizontal: borderPadding),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start ,children: [                                
          Text(trip.name!, style: quicksandStyle(fontSize: fontSize, weight: FontWeight.bold)),
          Text(trip.endDate!.isAfter(trip.startDate!) ? 
            '${DateFormat.yMMMd().format(trip.startDate!)} - ${DateFormat.yMMMd().format(trip.endDate!)}' 
            : '${DateFormat.yMMMd().format(trip.startDate!)}',  
             style: quicksandStyle(fontSize: fontSizesm)),
        ],),
      )),
      
      
    ]),
  );

}

List<Trip> _sortTrips(List<Trip> trips, int tab) {
    trips.sort((a, b) {
      return b.startDate!.millisecondsSinceEpoch
          .compareTo(a.startDate!.millisecondsSinceEpoch);
    });

    switch(tab){      
      case 1: return trips.where((t) => t.endDate!.isAfter(DateTime.now())).toList();
      case 2: return trips.where((t) => t.endDate!.isBefore(DateTime.now())).toList();
      default: return trips;
    }
   
  }