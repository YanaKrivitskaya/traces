import 'package:flutter/material.dart';
import 'package:traces/colorsPalette.dart';
import 'package:traces/screens/visas/bloc/visa/visa_bloc.dart';
import 'package:traces/screens/visas/model/visa.dart';
import 'package:traces/screens/visas/model/visa_tab.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/shared/shared.dart';
import 'package:intl/intl.dart';

class VisasView extends StatefulWidget {
  final VisaTab activeTab;

  VisasView({Key key, @required this.activeTab}) : super(key: key);

  @override
  _VisasViewState createState() => _VisasViewState();
}

class _VisasViewState extends State<VisasView> {

  List<Visa> visas = new List<Visa>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<VisaBloc, VisaState>(
      listener: (context, state) {},
      child: BlocBuilder<VisaBloc, VisaState>(
        cubit: BlocProvider.of(context),
        builder: (context, state){
          if(state.isLoading) return loadingWidget(ColorsPalette.algalFuel);

          if(state.isSuccess){
            widget.activeTab == VisaTab.ActiveVisas
                ? this.visas = state.allVisas.where((visa) => isVisaActive(visa)).toList()
                : widget.activeTab == VisaTab.ExpiredVisas
                ? this.visas = state.allVisas.where((visa) => !isVisaActive(visa)).toList()
                : this.visas = state.allVisas.toList();

            return Container (padding: EdgeInsets.all(5.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [this.visas != null && this.visas.length > 0
                    ? Container(child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: this.visas.length,
                      itemBuilder: (context, position){
                        final visa = this.visas[position];
                        return Card(
                          child: Container(padding: EdgeInsets.all(10.0),
                            child: Column(children: <Widget>[
                              Row(mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  _avatar(visa.owner),
                                  _visaDetails(visa)
                                ],
                              )],
                            )
                          )
                        );
                      }))
                    : Center(child: Container(padding: EdgeInsets.only(top: 20.0),child: Text("No items here", style: TextStyle(fontSize: 18.0))))
                  ])));
          }
          return loadingWidget(ColorsPalette.algalFuel);
        }
      ),
    );
  }

  Widget _avatar(String username) => new CircleAvatar(
      backgroundColor: ColorsPalette.lynxWhite,
      child: Text(getAvatarName(username), style: TextStyle(color: ColorsPalette.algalFuel, fontSize: 25.0, fontWeight: FontWeight.w300),),
      radius: 30.0
  );

  Widget _visaDetails(Visa visa) => new Container(
    padding: EdgeInsets.only(left: 20.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(visa.countryOfIssue + ' - ' + visa.type, style: TextStyle(fontSize: 15.0, color: ColorsPalette.mazarineBlue, fontWeight: FontWeight.bold)),
        Text(visaDuration(visa), style: TextStyle(fontSize: 15.0)),
        Text('${DateFormat.yMMMd().format(visa.startDate)} - ${DateFormat.yMMMd().format(visa.endDate)}', style: TextStyle(fontSize: 15.0)),
        Text(isVisaActive(visa) ? 'Active' : 'Expired', style: TextStyle(color: isVisaActive(visa) ? ColorsPalette.algalFuel : ColorsPalette.carminePink, fontSize: 15.0, fontWeight: FontWeight.bold))
      ],
    ),
  );

  bool isVisaActive(Visa visa){
    var currentDate = DateTime.now();
    if(visa.endDate.difference(currentDate).inDays > 1) return true;
    return false;
  }

  String visaDuration(Visa visa){
    var visaDays = visa.endDate.difference(visa.startDate).inDays;
    if(visaDays > 30) return (visaDays / 30).toStringAsFixed(1) + " months";
    else return visaDays.toString() + " days";
  }


}