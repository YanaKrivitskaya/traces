import 'package:flutter/material.dart';
import 'package:traces/colorsPalette.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traces/screens/visas/bloc/visa_details/visa_details_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/screens/visas/model/entryExit.dart';
import 'package:traces/screens/visas/model/visa.dart';
import 'package:traces/screens/visas/shared.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VisaDetailsView extends StatefulWidget {
  VisaDetailsView({Key key}) : super(key: key);

  @override
  _VisaDetailsViewState createState() => _VisaDetailsViewState();
}

class _VisaDetailsViewState extends State<VisaDetailsView> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
          title: Text('Visa Details', style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.lynxWhite, fontSize: 25.0))),
          backgroundColor: ColorsPalette.mazarineBlue,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          )
      ),

      body: BlocListener<VisaDetailsBloc, VisaDetailsState>(
          listener: (context, state){
            if(state.isFailure){
              Scaffold.of(context)..hideCurrentSnackBar()..showSnackBar(
                SnackBar(
                  backgroundColor: ColorsPalette.redPigment,
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 250,
                        child: Text(
                          state.errorMessage, style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.lynxWhite)),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                        ),
                      ),
                      Icon(Icons.error)],
                  ),
                ),
              );
            }
            if(state.isLoading && state.isEditing){
              Scaffold.of(context)..hideCurrentSnackBar()..showSnackBar(
                SnackBar(
                  backgroundColor: ColorsPalette.algalFuel,
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(ColorsPalette.lynxWhite),),
                        height: 30.0,
                        width: 30.0,
                      ),
                    ],
                  ),
                ),
              );
            }
          },
          child: BlocBuilder<VisaDetailsBloc, VisaDetailsState>(builder: (context, state){
            if (state.isLoading) {
              return Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(ColorsPalette.algalFuel)));
            }
            if(state.isSuccess || state.isFailure){
              return Container(
                  padding: EdgeInsets.all(5.0),
                  child: _detailsForm(state.visa, state.entryExits)
              );
            }else{
              return Center(child: CircularProgressIndicator());
            }
          })
      ),
      backgroundColor: Colors.white,
    );
  }

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
                                            _transportIcon(entryExit.entryTransport)
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
                                            _transportIcon(entryExit.exitTransport)
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
                              }),
                              entryExits.last.hasExit ? Container(child: Align( child: OutlineButton(
                                  child: Text('Add', style: TextStyle(color: ColorsPalette.mazarineBlue),)
                              ), alignment: Alignment.centerLeft)) : Container()
                        ],
                          )
                          : Container(child: Align(child: Text("No entries"), alignment: Alignment.centerLeft)),
                      Align(
                          //alignment: Alignment.centerLeft,child: AddFamilyButton()
                      ),
                    ],
                  ),)
              )
            ],),
          )
      )
  );

  Widget _transportIcon(String transport) => new Container(
      child: transport == 'Train' ? FaIcon(FontAwesomeIcons.train, color: ColorsPalette.mazarineBlue)
          : transport == 'Plane' ? FaIcon(FontAwesomeIcons.plane, color: ColorsPalette.mazarineBlue)
          : transport =='Car' ? FaIcon(FontAwesomeIcons.car, color: ColorsPalette.mazarineBlue)
          : transport == 'Ship' ? FaIcon(FontAwesomeIcons.ship, color: ColorsPalette.mazarineBlue)
          : transport == 'On foot' ? FaIcon(FontAwesomeIcons.walking, color: ColorsPalette.mazarineBlue)
          : Container()
  );

}