import 'package:flutter/material.dart';
import 'package:traces/colorsPalette.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traces/constants.dart';
import 'package:traces/screens/visas/add_entry_button.dart';
import 'package:traces/screens/visas/bloc/visa_details/visa_details_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/screens/visas/model/entryExit.dart';
import 'package:traces/screens/visas/model/visa.dart';
import 'package:traces/screens/visas/shared.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:traces/screens/visas/visa_delete_alert.dart';
import 'package:traces/shared/state_types.dart';

class VisaDetailsView extends StatefulWidget {
  VisaDetailsView({Key key}) : super(key: key);

  @override
  _VisaDetailsViewState createState() => _VisaDetailsViewState();
}

class _VisaDetailsViewState extends State<VisaDetailsView> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<VisaDetailsBloc, VisaDetailsState>(
          listener: (context, state){

          },
          child: BlocBuilder<VisaDetailsBloc, VisaDetailsState>(builder: (context, state){
            return new Scaffold(
              appBar: AppBar(
                  title: Text('Visa Details', style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.lynxWhite, fontSize: 25.0))),
                  backgroundColor: ColorsPalette.mazarineBlue,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  actions: [
                    _editAction(state),
                    _deleteAction(state)
                  ],
              ),
              backgroundColor: Colors.white,
              body: (state.status == StateStatus.Success || state.status == StateStatus.Error)
                      ? Container(
                        padding: EdgeInsets.all(5.0),
                        child: _detailsForm(state.visa, state.entryExits)
                      )
                      : Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(ColorsPalette.algalFuel)))
            );
          })
      );
  }
  Widget _editAction(VisaDetailsState state) => new IconButton(
    icon: FaIcon(FontAwesomeIcons.edit),
    onPressed: () {
      Navigator.popAndPushNamed(context, visaEditRoute, arguments: state.visa.id);
    },
  );

  Widget _deleteAction(VisaDetailsState state) => new IconButton(
    icon: FaIcon(FontAwesomeIcons.trashAlt),
    onPressed: () {
      showDialog<String>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (_) =>
            BlocProvider.value(
              value: context.bloc<VisaDetailsBloc>(),
              child: VisaDeleteAlert(
                visa: state.visa, callback: (val) => val == 'Delete' ? Navigator.of(context).pop() : '',
              ),
            )
      );
    },
  );

  Widget _detailsForm(Visa visa, List<EntryExit> entryExits) => new Container(
      color: ColorsPalette.white,
      padding: EdgeInsets.all(15.0),
      child: SingleChildScrollView(
          child: Container(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
              isActiveLabel(visa),
              Divider(color: ColorsPalette.algalFuel),
              Text(visa.owner, style: TextStyle(color: ColorsPalette.mazarineBlue, fontSize: 15.0, fontWeight: FontWeight.bold),),
              Text(visa.countryOfIssue + ' - ' + visa.type, style: TextStyle(fontSize: 15.0, color: ColorsPalette.mazarineBlue, fontWeight: FontWeight.bold)),
              Text(visa.numberOfEntries, style: TextStyle(fontSize: 15.0)),
              Text('${DateFormat.yMMMd().format(visa.startDate)} - ${DateFormat.yMMMd().format(visa.endDate)}', style: TextStyle(fontSize: 15.0)),
              Text('${visaDuration(visa)} / ${visa.durationOfStay} days', style: TextStyle(fontSize: 15.0)),
              Text('${daysLeft(visa, entryExits)} days left', style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
              Divider(color: ColorsPalette.mazarineBlue, thickness: 1.0,),
              //Text('Entries/Exits', style: TextStyle(color: ColorsPalette.mazarineBlue, fontSize: 18.0, fontWeight: FontWeight.bold),),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Entry', style: TextStyle(color: ColorsPalette.mazarineBlue, fontSize: 18.0, fontWeight: FontWeight.bold),),
                Text('Exit', style: TextStyle(color: ColorsPalette.mazarineBlue, fontSize: 18.0, fontWeight: FontWeight.bold)),
                Text('Stay', style: TextStyle(color: ColorsPalette.mazarineBlue, fontSize: 18.0, fontWeight: FontWeight.bold),)
              ],),
              Divider(color: ColorsPalette.mazarineBlue, thickness: 1.0,),
              Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: SingleChildScrollView(child: Column(
                    children: <Widget>[
                      entryExits.length > 0 ? Column(
                        children: [
                          ListView.builder(
                          shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: entryExits.length,
                              itemBuilder: (context, position){
                                final entryExit = entryExits[position];
                                return Container(
                                  padding: EdgeInsets.only(top: 10.0),
                                  child: Column(children: [
                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                      //entry
                                      Column(
                                        children: [Container(
                                          width: MediaQuery.of(context).size.width * 0.3,
                                          child: Column(children: [
                                            Text('${DateFormat.yMMMd().format(entryExit.entryDate)}'),
                                            Text('${entryExit.entryCountry}, ${entryExit.entryCity}'),
                                            transportIcon(entryExit.entryTransport)
                                          ], crossAxisAlignment: CrossAxisAlignment.start),
                                        )],
                                      ),
                                      //exit
                                      entryExit.hasExit ? Column(
                                        children: [Container(
                                          width: MediaQuery.of(context).size.width * 0.3,
                                          child: Column(children: [
                                            Text('${DateFormat.yMMMd().format(entryExit.exitDate)}'),
                                            Text('${entryExit.exitCountry}, ${entryExit.exitCity}'),
                                            transportIcon(entryExit.exitTransport)
                                          ], crossAxisAlignment: CrossAxisAlignment.start),
                                        )],
                                      ) : Container(
                                          child: OutlineButton(
                                              child: Text('Add', style: TextStyle(color: ColorsPalette.mazarineBlue),)
                                          )
                                      ),
                                      Column(
                                        children: [Container(
                                          child: Column(children: [
                                            Text(tripDuration(entryExit.entryDate, entryExit.exitDate))
                                          ], crossAxisAlignment: CrossAxisAlignment.end),
                                        )],
                                      )
                                    ],),
                                    Divider(color: ColorsPalette.mazarineBlue),
                                  ],),
                                );
                              })
                        ])
                        :  Column(
                        children: [
                          Container(child: Align(child: Text("No entries"), alignment: Alignment.centerLeft)),
                          (entryExits.isNotEmpty && entryExits.last.hasExit) || entryExits.isEmpty ? Container(
                              child: Align( child: AddEntryButton(visa: visa,), alignment: Alignment.centerLeft))
                              : Container(),
                        ],
                      )
                    ],
                  ),)
              )
            ],),
          )
      )
  );

}