import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:traces/utils/style/styles.dart';
import 'package:traces/widgets/error_widgets.dart';

import '../../constants/color_constants.dart';
import '../../constants/route_constants.dart';
import '../../utils/misc/state_types.dart';
import '../../widgets/widgets.dart';
import 'bloc/visa/visa_bloc.dart';
import 'helpers.dart';
import 'model/visa.model.dart';
import 'model/visa_tab.dart';

class VisasView extends StatefulWidget {
  final VisaTab activeTab;

  VisasView({Key? key, required this.activeTab}) : super(key: key);

  @override
  _VisasViewState createState() => _VisasViewState();
}

class _VisasViewState extends State<VisasView> {
  List<Visa> visas = <Visa>[];

  @override
  Widget build(BuildContext context) {
    return BlocListener<VisaBloc, VisaState>(
      listener: (context, state) {
        if(state.status == StateStatus.Error && state.allVisas != null){
            ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                backgroundColor: ColorsPalette.redPigment,
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 250,
                      child: Text(
                        state.errorMessage.toString(),
                        style: quicksandStyle(color: ColorsPalette.lynxWhite),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                      ),
                    ),
                    Icon(Icons.error, color: ColorsPalette.lynxWhite)
                  ],
                ),
              ));
          }
      },

      child: BlocBuilder<VisaBloc, VisaState>(
        bloc: BlocProvider.of(context),
        builder: (context, state) {
          if(state.status == StateStatus.Error && state.allVisas == null){
            return errorWidget(context, error: state.errorMessage!);
          }
          if (state.status == StateStatus.Loading)
            return loadingWidget(ColorsPalette.algalFuel);

          if (state.status == StateStatus.Success || state.allVisas != null) {
            widget.activeTab == VisaTab.ActiveVisas
              ? this.visas = state.allVisas!.where((visa) => isVisaActive(visa)).toList()
                : widget.activeTab == VisaTab.ExpiredVisas
              ? this.visas = state.allVisas!.where((visa) => !isVisaActive(visa)).toList()
              : this.visas = state.allVisas!.toList();

              this.visas = _sortVisas(visas);

              return RefreshIndicator(      
                onRefresh: () async => context.read<VisaBloc>().add(GetAllVisas()),
                child:  Container(
                  padding: EdgeInsets.all(5.0),
                  child: SingleChildScrollView(
                    child: Column(children: [
                      this.visas.length > 0 ? Container(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: this.visas.length,
                          itemBuilder: (context, position) {
                            final visa = this.visas[position];
                            return Card(child: InkWell(
                              onTap: () {
                                Navigator.pushReplacementNamed(context, visaDetailsRoute, arguments: visa.id).then((value) => 
                                  context.read<VisaBloc>().add(GetAllVisas()));
                              },
                              child: Container(padding: EdgeInsets.all(10.0),
                                child: Column(children: <Widget>[
                                  Row( mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                                    avatar(visa.user!.name, 30.0, ColorsPalette.algalFuel, 25.0, null),
                                    _visaDetails(visa)
                                  ])]))),
                            );
                        }))
                        : Center(child: Container(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Text("No items here", style: TextStyle(fontSize: 18.0))))
                    ]))));
            }
            return loadingWidget(ColorsPalette.algalFuel);
          }),
    );
    
  }

  Widget _visaDetails(Visa visa) => new Container(
        padding: EdgeInsets.only(left: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(visa.country! + ' - ' + visa.type!,
                style: TextStyle(
                    fontSize: 15.0,
                    color: ColorsPalette.mazarineBlue,
                    fontWeight: FontWeight.bold)),
            Text(
                '${DateFormat.yMMMd().format(visa.startDate!)} - ${DateFormat.yMMMd().format(visa.endDate!)}',
                style: TextStyle(fontSize: 15.0)),
            Text('${visaDuration(visa)} / ${visa.durationOfStay} days',
                style: TextStyle(fontSize: 15.0)),
            isActiveLabel(visa)
          ],
        ),
      );

  List<Visa> _sortVisas(List<Visa> visas) {
    visas.sort((a, b) {
      return b.startDate!.millisecondsSinceEpoch
          .compareTo(a.startDate!.millisecondsSinceEpoch);
    });
    return visas;
  }
}
