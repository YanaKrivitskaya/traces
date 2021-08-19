import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    Tab(text: 'Overview'),
    Tab(text: 'Notes'),
    Tab(text: 'Itinerary'),
    Tab(text: 'Actions'),
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
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BubbleTabIndicator(
                      indicatorHeight: 35.0,
                      indicatorColor: ColorsPalette.iconColor,
                      tabBarIndicatorSize: TabBarIndicatorSize.tab                              
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,                    
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

      /*Widget _timelineDays(Trip trip){
        return Container(child: ListView.builder(
          shrinkWrap: true,         
          itemCount: trip.days!.length,
          itemBuilder: (context, position){
            final day = trip.days![position];     
            return TimelineTile(
              alignment: TimelineAlign.manual,
              lineXY: 0.1,
              isFirst: position == 0,
              isLast: position == trip.days!.length,
              indicatorStyle: const IndicatorStyle(
                width: 20,
                color: Color(0xFF27AA69),
                padding: EdgeInsets.all(6),
              ),
              endChild: Card(child: Text('${day.name} - ${DateFormat.yMMMd().format(day.date!)}'),),
              beforeLineStyle: const LineStyle(
                color: Color(0xFF27AA69),
              ),
            );
          }
        )
        );
      }*/
}



