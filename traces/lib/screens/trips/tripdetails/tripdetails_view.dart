import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:traces/screens/trips/tripdetails/route_view.dart';

import '../../../constants/color_constants.dart';
import '../../../utils/style/styles.dart';
import '../../../widgets/widgets.dart';
import 'bloc/tripdetails_bloc.dart';
import 'header_appbar_widget.dart';
import 'header_cover_widget.dart';
import 'overview_view.dart';

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
    return Scaffold(
      body: BlocListener<TripDetailsBloc, TripDetailsState>(
        listener: (context, state){},
        child: BlocBuilder<TripDetailsBloc, TripDetailsState>(
          builder: (context, state){
            if(state is TripDetailsSuccessState){
              return Column(children: [
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
              ]);
              //return ;
            }
            return loadingWidget(ColorsPalette.meditSea);            
          }
        ),
      )
    );
  }
      
}



