import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../constants/color_constants.dart';
import '../model/visa_tab.dart';


class TabSelector extends StatelessWidget {

  final VisaTab activeTab;
  final Function(VisaTab) onTabSelected;

  TabSelector({
    Key? key,
    required this.activeTab,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      //key:
      currentIndex: VisaTab.values.indexOf(activeTab),
      onTap: (index) => onTabSelected(VisaTab.values[index]),
      items: VisaTab.values.map((tab) {
        return BottomNavigationBarItem(
          label: tab == VisaTab.AllVisas ? "All" : tab == VisaTab.ActiveVisas ? "Active" : "Expired",
          icon: getTabIcon(tab)
        );
      }).toList()
    );
  }

  bool isCurrentTabActive(VisaTab tab){
    return VisaTab.values.indexOf(activeTab) == VisaTab.values.indexOf(tab);
  }

  FaIcon getTabIcon(VisaTab tab){
    var icon = tab == VisaTab.AllVisas ? FontAwesomeIcons.random : tab == VisaTab.ActiveVisas ? FontAwesomeIcons.check : FontAwesomeIcons.times;
    return FaIcon(icon, color: isCurrentTabActive(tab) ? ColorsPalette.algalFuel : ColorsPalette.mazarineBlue);
  }
}
