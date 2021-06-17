import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../constants/color_constants.dart';
import '../../constants/route_constants.dart';
import '../../shared/state_types.dart';
import 'bloc/entry_exit/entry_exit_bloc.dart';
import 'bloc/visa_details/visa_details_bloc.dart';
import 'widgets/entryExit_delete_alert.dart';
import 'entry_exit_details_view.dart';
import 'helpers.dart';
import 'model/entryExit.dart';
import 'model/visa.dart';
import 'repository/firebase_visas_repository.dart';
import 'widgets/visa_delete_alert.dart';

class VisaDetailsView extends StatefulWidget {

  VisaDetailsView({Key key}) : super(key: key);

  @override
  _VisaDetailsViewState createState() => _VisaDetailsViewState();
}

class _VisaDetailsViewState extends State<VisaDetailsView> with SingleTickerProviderStateMixin {
  SlidableController slidableController; 

  TabController tabController;

  final List<Tab> detailsTabs = <Tab>[
    Tab(text: 'Details'),
    Tab(text: 'Entries'),
  ];

  void initState() { 
    slidableController = SlidableController(); 
    tabController = TabController(length: detailsTabs.length, vsync: this);
    
    tabController.addListener(handleTabSelection);
    super.initState(); 
  } 

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }


  // for Slidable animation
  void handleSlideIsOpenChanged(bool isOpen) { }
  void handleSlideAnimationChanged(Animation<double> slideAnimation) { }

  void handleTabSelection() {    
    if(tabController.index != tabController.previousIndex){
      context.read<VisaDetailsBloc>().add(TabUpdatedClicked(tabController.index));
    }    
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<VisaDetailsBloc, VisaDetailsState>(
        listener: (context, state) {
          tabController.index = state.activeTab;
        },
        child: BlocBuilder<VisaDetailsBloc, VisaDetailsState>(
          builder: (context, state) {
            return new Scaffold(
                appBar: AppBar(
                  bottom: TabBar(
                    controller: tabController,                    
                    tabs: detailsTabs,
                    indicatorColor: ColorsPalette.algalFuel,
                    labelColor: ColorsPalette.lynxWhite,
                ),
                title: Text('Visa Details',
                    style: GoogleFonts.quicksand(
                    textStyle: TextStyle(color: ColorsPalette.lynxWhite, fontSize: 25.0))),
                backgroundColor: ColorsPalette.mazarineBlue,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: ColorsPalette.lynxWhite),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                actions: [_editAction(state), _deleteAction(state)],
              ),
              backgroundColor: Colors.white,
              floatingActionButton: state.activeTab == 1 && (state.entryExits.length > 0 && state.entryExits.last.hasExit) 
                  ? FloatingActionButton(
                onPressed: () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (_) => BlocProvider<EntryExitBloc>(
                        create: (context) =>
                            EntryExitBloc(visasRepository: new FirebaseVisasRepository())
                              ..add(GetEntryDetails(null, state.visa)),
                        child: EntryExitDetailsView()),
                  );
                },
                tooltip: 'Add entry',
                backgroundColor: ColorsPalette.algalFuel,
                child: Icon(Icons.add, color: ColorsPalette.lynxWhite),
              ): null,
              body: (state.status == StateStatus.Success || state.status == StateStatus.Error) 
              ? TabBarView(
                controller: tabController,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5.0),
                      child: _details(state.visa, state.entryExits)
                    ),
                    Container(
                      padding: EdgeInsets.all(5.0),
                      child: _entries(state.visa, _sortEntries(state.entryExits))
                    )
                  ],
                )
              : Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(ColorsPalette.algalFuel)))
              );          
        }));
  }

  Widget _editAction(VisaDetailsState state) => new IconButton(
        icon: FaIcon(FontAwesomeIcons.edit, color: ColorsPalette.lynxWhite),
        onPressed: () {
          Navigator.popAndPushNamed(context, visaEditRoute,
              arguments: state.visa.id);
        },
      );

  Widget _deleteAction(VisaDetailsState state) => new IconButton(
        icon: FaIcon(FontAwesomeIcons.trashAlt, color: ColorsPalette.lynxWhite),
        onPressed: () {
          showDialog<String>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (_) => BlocProvider.value(
                    value: context.read<VisaDetailsBloc>(),
                    child: VisaDeleteAlert(
                      visa: state.visa,
                      callback: (val) =>
                          val == 'Delete' ? Navigator.of(context).pop() : '',
                    ),
                  ));
        },
      );

  Widget _details(Visa visa, List<EntryExit> entryExits) => new Container(
    color: ColorsPalette.white, padding: EdgeInsets.all(15.0),
    child: SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          isActiveLabel(visa),
          Divider(color: ColorsPalette.mazarineBlue, thickness: 1.0),
          Text(visa.owner, style: TextStyle(
            color: ColorsPalette.mazarineBlue,
            fontSize: 15.0,
            fontWeight: FontWeight.bold),
          ),
          Text(visa.countryOfIssue + ' - ' + visa.type, style: TextStyle(
            fontSize: 15.0,
            color: ColorsPalette.mazarineBlue,
            fontWeight: FontWeight.bold)),
          Text(visa.numberOfEntries, style: TextStyle(fontSize: 15.0)),
          Text('${DateFormat.yMMMd().format(visa.startDate)} - ${DateFormat.yMMMd().format(visa.endDate)}',
            style: TextStyle(fontSize: 15.0)),
          Text('${visaDuration(visa)} / ${visa.durationOfStay} days',
            style: TextStyle(fontSize: 15.0)),
          Text('Days used: ${daysUsed(visa, entryExits)}',
            style: TextStyle(fontSize: 15.0)),
          Text('Days left: ${daysLeft(visa, entryExits)}',
            style: TextStyle(fontSize: 15.0))
        ],
      ),
    ));      

  Widget _entries(Visa visa, List<EntryExit> entryExits) => new Container(
    color: ColorsPalette.white, padding: EdgeInsets.all(15.0),
    child: SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Entry', style: TextStyle(color: ColorsPalette.mazarineBlue, fontSize: 18.0, fontWeight: FontWeight.bold)),
              Text('Exit', style: TextStyle(color: ColorsPalette.mazarineBlue, fontSize: 18.0, fontWeight: FontWeight.bold)),
              Text('Stay', style: TextStyle(color: ColorsPalette.mazarineBlue, fontSize: 18.0, fontWeight: FontWeight.bold))
          ]),
          Divider(color: ColorsPalette.mazarineBlue,thickness: 1.0),
          Column(children: <Widget>[
            entryExits.length > 0 ? Container(child:
              ListView.builder(shrinkWrap: true, physics: NeverScrollableScrollPhysics(),
                itemCount: entryExits.length,
                itemBuilder: (builderContext, position) {
                  final entryExit = entryExits[position];
                  return Column(children: [
                    Slidable(key: Key(entryExit.id),
                      controller: slidableController,
                      direction: Axis.horizontal,                      
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.25,
                      child: VerticalListItem(entryExits[position], visa),
                        secondaryActions: <Widget>[
                          IconSlideAction(
                            color: ColorsPalette.carminePink, 
                            icon: FontAwesomeIcons.trashAlt, 
                            onTap: () => showDialog<String>(
                              context: context,
                              barrierDismissible: false, // user must tap button!
                              builder: (_) => BlocProvider<EntryExitBloc>(                                   
                                    create: (context) => EntryExitBloc(visasRepository:new FirebaseVisasRepository()),
                                    child: EntryExitDeleteAlert(
                                      visa: visa,
                                      entryExit: entryExit                                      
                                    ),
                                  )), 
                          ), 
                        ], 
                      ),
                        Divider(color: ColorsPalette.mazarineBlue)
                      ]);                      
                    }))
                    : Column(children: [Container(child: Align(
                      child: Text("No entries"),
                      alignment: Alignment.centerLeft))])
                    ],
                  )
              /*Container(height: MediaQuery.of(context).size.height * 0.4,
              child: SingleChildScrollView(child: ,
                ))*/
            ]
          )
        )
      );

}

class VerticalListItem extends StatelessWidget {
  VerticalListItem(this.item, this.visa);
  final EntryExit item;
  final Visa visa;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
        Slidable.of(context)?.renderingMode == SlidableRenderingMode.none
          ? Slidable.of(context)?.open()
          : Slidable.of(context)?.close(),
      child: Container(padding: EdgeInsets.only(top: 10.0),
        child: Column(children: [
          InkWell(child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               //entry
              Column(children: [Container(width: MediaQuery.of(context).size.width * 0.3,
                child: Column(children: [
                  Text('${DateFormat.yMMMd().format(item.entryDate)}'),
                  Text('${item.entryCountry}, ${item.entryCity}'),
                  transportIcon(item.entryTransport)],
                crossAxisAlignment:CrossAxisAlignment.start))]),
              //exit
              item.hasExit ? Column(children: [ Container(width: MediaQuery.of(context).size.width *0.3,
                child: Column(children: [
                  Text('${DateFormat.yMMMd().format(item.exitDate)}'),
                  Text('${item.exitCountry}, ${item.exitCity}'),
                  transportIcon(item.exitTransport)],
                crossAxisAlignment: CrossAxisAlignment.start))])
              : Container(),
              //duration
              Column(children: [Container(padding: EdgeInsets.only(right: 10.0), child: Column(children: [
                Row(children: [
                  Text(item.duration.toString() + " days"),
                  item.duration > visa.durationOfStay ?
                  IconButton(icon: FaIcon(FontAwesomeIcons.exclamationCircle, color: ColorsPalette.carminePink), 
                    tooltip: 'Trip duration is more than visa duration', onPressed: () {},) : Container()
                ])],
                crossAxisAlignment: CrossAxisAlignment.end))])]),
              onTap: () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (_) => BlocProvider<EntryExitBloc>(
                    create: (context) => EntryExitBloc(visasRepository: new FirebaseVisasRepository())
                      ..add(GetEntryDetails(item, visa)),
                    child: EntryExitDetailsView()));
              })]))
    );
  }
}

List<EntryExit> _sortEntries(List<EntryExit> entries) {
    entries.sort((a, b) {
      return b.entryDate.millisecondsSinceEpoch
          .compareTo(a.entryDate.millisecondsSinceEpoch);
    });
    return entries;
  }
