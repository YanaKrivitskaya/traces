import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/color_constants.dart';
import '../../constants/route_constants.dart';
import 'bloc/visa_tab/visa_tab_bloc.dart';
import 'model/visa_tab.dart';
import 'visas_view.dart';
import 'widgets/tab_selector.dart';

class VisasPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VisaTabBloc, VisaTab>(builder: (context, activeTab) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Visas',
              style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.lynxWhite, fontSize: 25.0))),
          backgroundColor: ColorsPalette.mazarineBlue,
          leading: IconButton(
            icon: FaIcon(FontAwesomeIcons.chevronLeft, color: ColorsPalette.lynxWhite),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: VisasView(activeTab: activeTab),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, visaEditRoute, arguments: 0);
          },
          tooltip: 'Add New Visa',
          backgroundColor: ColorsPalette.algalFuel,
          child: Icon(Icons.add, color: ColorsPalette.lynxWhite),
        ),
        bottomNavigationBar: TabSelector(
          activeTab: activeTab,
          onTabSelected: (tab) =>
              BlocProvider.of<VisaTabBloc>(context).add(TabUpdated(tab)),
        ),
      );
    });
  }
}
