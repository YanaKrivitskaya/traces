import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../colorsPalette.dart';
import '../../constants.dart';
import '../../shared/shared.dart';
import '../../shared/state_types.dart';
import 'bloc/visa/visa_bloc.dart';
import 'helpers.dart';
import 'model/visa.dart';
import 'model/visa_tab.dart';

class VisasView extends StatefulWidget {
  final VisaTab activeTab;

  VisasView({Key key, @required this.activeTab}) : super(key: key);

  @override
  _VisasViewState createState() => _VisasViewState();
}

class _VisasViewState extends State<VisasView> {
  List<Visa> visas = <Visa>[];

  @override
  Widget build(BuildContext context) {
    return BlocListener<VisaBloc, VisaState>(
      listener: (context, state) {},
      child: BlocBuilder<VisaBloc, VisaState>(
          cubit: BlocProvider.of(context),
          builder: (context, state) {
            if (state.status == StateStatus.Loading)
              return loadingWidget(ColorsPalette.algalFuel);

            if (state.status == StateStatus.Success) {
              widget.activeTab == VisaTab.ActiveVisas
                  ? this.visas = state.allVisas
                      .where((visa) => isVisaActive(visa))
                      .toList()
                  : widget.activeTab == VisaTab.ExpiredVisas
                      ? this.visas = state.allVisas
                          .where((visa) => !isVisaActive(visa))
                          .toList()
                      : this.visas = state.allVisas.toList();

              this.visas = _sortVisas(visas);

              return Container(
                  padding: EdgeInsets.all(5.0),
                  child: SingleChildScrollView(
                      child: Column(children: [
                    this.visas != null && this.visas.length > 0
                        ? Container(
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: this.visas.length,
                                itemBuilder: (context, position) {
                                  final visa = this.visas[position];
                                  return Card(
                                    child: InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(context, visaDetailsRoute, arguments: visa.id);
                                        },
                                        child: Container(
                                            padding: EdgeInsets.all(10.0),
                                            child: Column(
                                              children: <Widget>[
                                                Row( mainAxisAlignment: MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    _avatar(visa.owner),
                                                    _visaDetails(visa)
                                                  ],
                                                )
                                              ],
                                            ))),
                                  );
                                }))
                        : Center(
                            child: Container(
                                padding: EdgeInsets.only(top: 20.0),
                                child: Text("No items here",
                                    style: TextStyle(fontSize: 18.0))))
                  ])));
            }
            return loadingWidget(ColorsPalette.algalFuel);
          }),
    );
  }

  Widget _avatar(String username) => new CircleAvatar(
      backgroundColor: ColorsPalette.lynxWhite,
      child: Text(
        getAvatarName(username),
        style: TextStyle(
            color: ColorsPalette.algalFuel,
            fontSize: 25.0,
            fontWeight: FontWeight.w300),
      ),
      radius: 30.0);

  Widget _visaDetails(Visa visa) => new Container(
        padding: EdgeInsets.only(left: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(visa.countryOfIssue + ' - ' + visa.type,
                style: TextStyle(
                    fontSize: 15.0,
                    color: ColorsPalette.mazarineBlue,
                    fontWeight: FontWeight.bold)),
            Text(
                '${DateFormat.yMMMd().format(visa.startDate)} - ${DateFormat.yMMMd().format(visa.endDate)}',
                style: TextStyle(fontSize: 15.0)),
            Text('${visaDuration(visa)} / ${visa.durationOfStay} days',
                style: TextStyle(fontSize: 15.0)),
            isActiveLabel(visa)
          ],
        ),
      );

  List<Visa> _sortVisas(List<Visa> visas) {
    visas.sort((a, b) {
      return b.startDate.millisecondsSinceEpoch
          .compareTo(a.startDate.millisecondsSinceEpoch);
    });
    return visas;
  }
}
