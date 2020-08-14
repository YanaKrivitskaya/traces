import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/colorsPalette.dart';
import 'package:traces/constants.dart';
import 'package:traces/screens/visas/bloc/visa_tab/visa_tab_bloc.dart';
import 'package:traces/screens/visas/model/visa_tab.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traces/screens/visas/visas_view.dart';
import 'package:traces/screens/visas/widgets/tab_selector.dart';

class VisasPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VisaTabBloc, VisaTab>(
      builder: (context, activeTab){
        return Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text('Visas', style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.lynxWhite, fontSize: 25.0))),
            backgroundColor: ColorsPalette.mazarineBlue,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.of(context).pop(),
            ),

          ),
          body: VisasView(activeTab: activeTab),
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              Navigator.pushNamed(context, visaDetailsRoute, arguments: '');
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
      }
    );
  }
}
