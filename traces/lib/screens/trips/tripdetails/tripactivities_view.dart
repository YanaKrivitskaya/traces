import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:traces/constants/color_constants.dart';
import 'package:traces/constants/route_constants.dart';
import 'package:traces/screens/trips/model/activity.model.dart';
import 'package:traces/screens/trips/model/trip.model.dart';
import 'package:traces/screens/trips/model/trip_arguments.model.dart';
import 'package:traces/screens/trips/tripdetails/bloc/tripdetails_bloc.dart';
import 'package:traces/utils/services/shared_preferencies_service.dart';
import 'package:traces/utils/style/styles.dart';
import 'package:traces/widgets/widgets.dart';

class ActivitiesView extends StatefulWidget{
  final List<Activity> activities;
  final Trip trip; 

  ActivitiesView({required this.trip, required this.activities});

  State<ActivitiesView> createState() => _ActivitiesStateView();

}

class _ActivitiesStateView extends State<ActivitiesView> with TickerProviderStateMixin{

  late TabController tabController;

  final List<Tab> viewTabs = <Tab>[
    Tab(text: 'ALL'),
    Tab(text: 'PLANNED'),    
    Tab(text: 'COMPLETED')    
  ];

  final SharedPreferencesService sharedPrefsService = SharedPreferencesService();
  final String viewOptionKey = "activitiesViewOption";
  var viewOption;  

  List<Activity> activities = List<Activity>.empty(growable: true);

   @override
  void initState() {
    super.initState();
    tabController = TabController(length: viewTabs.length, vsync: this);
    tabController.addListener(handleTabSelection);
  }

   void handleTabSelection() {
    if(tabController.index != tabController.previousIndex){
      context.read<TripDetailsBloc>().add(ActivityTabUpdated(tabController.index, viewOptionKey));
    }    
  }

  @override
  void dispose() {
    tabController.dispose();
    sharedPrefsService.remove(key: viewOptionKey);
    super.dispose();
  }  

  @override
  Widget build(BuildContext context) {

    widget.activities.sort((a, b) {
      var aDate = a.date ?? a.updatedDate ?? a.createdDate ?? DateTime.now();
      var bDate = b.date ?? b.updatedDate ?? b.createdDate ?? DateTime.now();
      return aDate.compareTo(bDate);
    });

    int? tabValue = sharedPrefsService.readInt(key: viewOptionKey);
      tabController.index = tabValue ?? 0;
        activities = tabValue == 1 ? widget.activities.where((a) => a.isPlanned??false).toList() 
          : tabValue == 2 ? widget.activities.where((a) => a.isCompleted??false).toList() : widget.activities;
           
    return BlocListener<TripDetailsBloc, TripDetailsState>(
      listener: (context, state){
        
      },
      child: BlocBuilder<TripDetailsBloc, TripDetailsState>(
        builder: (context, state){
          return SingleChildScrollView(
            child: Column(children: [
              TabBar(
                isScrollable: true,              
                controller: tabController,
                indicatorColor: Theme.of(context).colorScheme.outline,
                tabs: viewTabs
              ), 
              activities.length > 0 && state is TripDetailsSuccessState ? Container(
                padding: new EdgeInsets.all(borderPadding),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: activities.length,              
                  itemBuilder: (context, position){
                    final activity = activities[position];
                    return _activityCard(activity, context);                  
                  }
                )
              ) :
              activities.length == 0 && state is TripDetailsSuccessState ? Container(
                padding: new EdgeInsets.all(viewPadding),
                child: Center(
                  child: Container(child: Center(child: Text("No activities", style: quicksandStyle(fontSize: fontSize)))),
                )
              ) : loadingWidget(ColorsPalette.amMint)
            ])
          );
        }
      )

    );    
  }

  _activityCard(Activity activity, BuildContext context) {
    var isCompleted = activity.isCompleted != null && activity.isCompleted!;
    return Container(
      margin: EdgeInsets.only(bottom: borderPadding),
      child: ListTile(      
        leading: Icon(isCompleted ? Icons.check : Icons.access_time, 
          color: isCompleted ? ColorsPalette.juicyGreen : ColorsPalette.juicyOrangeLight),
        title: Text('${activity.name}', style: quicksandStyle(fontSize: fontSize, weight: FontWeight.bold)),
        subtitle: activity.date != null ? Text('${DateFormat.yMMMd().format(activity.date!)}',
                style: quicksandStyle(color: ColorsPalette.black, fontSize: fontSizesm)) : SizedBox(height:0),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: ColorsPalette.lynxWhite, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        onTap: (){
          ActivityViewArguments args = new ActivityViewArguments(activityId: activity.id!, trip: widget.trip);

          Navigator.of(context).pushNamed(activityViewRoute, arguments: args).then((value) {
            //context.read<TripDetailsBloc>().add(ActivityTabUpdated(tabController.index, viewOptionKey));
            context.read<TripDetailsBloc>().add(UpdateActivities(widget.trip.id!, 
              tab: tabController.index, tabKey: viewOptionKey));
          });
        },
      ),      
    );
  }  
}

