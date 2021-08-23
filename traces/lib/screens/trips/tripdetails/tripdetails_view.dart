import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/constants/route_constants.dart';
import 'package:traces/screens/trips/model/trip.model.dart';

import 'package:traces/screens/trips/tripdetails/route_view.dart';

import '../../../constants/color_constants.dart';
import '../../../utils/style/styles.dart';
import '../../../widgets/widgets.dart';
import 'bloc/tripdetails_bloc.dart';
import 'header_appbar_widget.dart';
import 'header_cover_widget.dart';
import 'overview_view.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';


class TripDetailsView extends StatefulWidget{
  final int? tripId;  

  TripDetailsView({this.tripId});

  @override
  _TripDetailsViewViewState createState() => _TripDetailsViewViewState();
}

class _TripDetailsViewViewState extends State<TripDetailsView> with TickerProviderStateMixin{
  late TabController tabController;

  //String tripTabKey = "tripTab"; used in sharedPrefs

  final List<Tab> detailsTabs = <Tab>[
    Tab(text: 'Overview', icon: Icon(Icons.home)),
    Tab(text: 'Route', icon: Icon(Icons.map)),
    Tab(text: 'Notes', icon: Icon(Icons.description)),
    Tab(text: 'Expenses', icon: Icon(Icons.attach_money)),
    Tab(text: 'Activities', icon: Icon(Icons.assignment_turned_in)),
  ];

  var isDialOpen = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: detailsTabs.length, vsync: this);
    tabController.addListener(handleTabSelection);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void handleTabSelection() {
    if(tabController.index != tabController.previousIndex){
      context.read<TripDetailsBloc>().add(TabUpdated(tabController.index));
    }    
  }

  @override
  Widget build(BuildContext context) {     

    return BlocListener<TripDetailsBloc, TripDetailsState>(
        listener: (context, state){},
        child: BlocBuilder<TripDetailsBloc, TripDetailsState>(
          builder: (context, state){            
            return Scaffold(       
              floatingActionButton: _floatingButton(state.trip != null ? state.trip : null),       
              body: (state is TripDetailsSuccessState) ? 
                  Column(children: [
                  state.activeTab == 0 ? 
                  headerCoverWidget(state.trip, state.familyMembers, context) 
                  :
                  headerAppbarWidget(state.trip.name!, context),                
                  Column(children: [
                    Container(child: TabBar(                   
                      unselectedLabelStyle: quicksandStyle(fontSize: 0.0),
                      /*labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,  */
                      isScrollable: true,              
                      controller: tabController,
                      tabs: detailsTabs,
                    )),
                    Container(
                      height: state.activeTab == 0 ? MediaQuery.of(context).size.height * 0.5 : MediaQuery.of(context).size.height * 0.8,
                      child: TabBarView(
                        physics: AlwaysScrollableScrollPhysics(),
                        controller: tabController,
                        children: [
                          /*BlocProvider(
                            builder: (context) => BlocA(),
                            child: TabA(),
                          ),*/
                          tripDetailsOverview(state.trip),
                          RouteView(trip: state.trip),
                          //Container(child: Center(child: Text("Coming soon!", style: quicksandStyle(fontSize: 18.0)))),
                          Container(child: Center(child: Text("Coming soon!", style: quicksandStyle(fontSize: 18.0)))),
                          Container(child: Center(child: Text("Coming soon!", style: quicksandStyle(fontSize: 18.0)))),
                          Container(child: Center(child: Text("Coming soon!", style: quicksandStyle(fontSize: 18.0)))),
                          /*BlocProvider(
                            builder: (context) => BlocB(),
                            child: TabB(),
                          ),*/
                        ],
                      ))
                  ],),                
                ]) : loadingWidget(ColorsPalette.meditSea)             
            );         
          }
        ),
      );    
  }

  Widget _floatingButton(Trip? trip) => SpeedDial(
          foregroundColor: ColorsPalette.lynxWhite,
          icon: Icons.add,
          activeIcon: Icons.close,
          spacing: 3,
          openCloseDial: isDialOpen,
          childPadding: EdgeInsets.all(5),
          spaceBetweenChildren: 4,
          renderOverlay: true,          
          overlayOpacity: 0.3,         
          tooltip: 'Add event',          
          elevation: 8.0,          
          animationSpeed: 200,          
          children: [
            SpeedDialChild(
              child: Icon(Icons.description),
              backgroundColor: ColorsPalette.juicyYellow,
              foregroundColor: ColorsPalette.lynxWhite,
              label: 'Note',
              onTap: () {},
            ),
            SpeedDialChild(
              child: Icon(Icons.train),
              backgroundColor: ColorsPalette.juicyOrange,
              foregroundColor: ColorsPalette.lynxWhite,
              label: 'Ticket',
              onTap: () {
                Navigator.pushNamed(context, ticketCreateRoute, arguments: trip); 
              },
            ),
            SpeedDialChild(
              child: Icon(Icons.hotel),
              backgroundColor: ColorsPalette.juicyDarkBlue,
              foregroundColor: Colors.white,
              label: 'Booking',
              visible: true,
              onTap: () {}
            ),
            SpeedDialChild(
              child: Icon(Icons.attach_money),
              backgroundColor: ColorsPalette.juicyGreen,
              foregroundColor: Colors.white,
              label: 'Expense',
              visible: true,
              onTap: () {}
            ),            
            SpeedDialChild(
              child: Icon(Icons.assignment_turned_in),
              backgroundColor: ColorsPalette.juicyBlue,
              foregroundColor: Colors.white,
              label: 'Activity',
              visible: true,
              onTap: () {}
            ),
          ],
        );
}



