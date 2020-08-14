import 'package:flutter/material.dart';
import 'package:traces/colorsPalette.dart';
import 'package:traces/screens/visas/model/visa_tab.dart';

class TabSelector extends StatelessWidget {

  final VisaTab activeTab;
  final Function(VisaTab) onTabSelected;

  TabSelector({
    Key key,
    @required this.activeTab,
    @required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      //key:
      currentIndex: VisaTab.values.indexOf(activeTab),
      onTap: (index) => onTabSelected(VisaTab.values[index]),
      items: VisaTab.values.map((tab) {
        return BottomNavigationBarItem(
          title: Text(tab == VisaTab.AllVisas ? "All" : tab == VisaTab.ActiveVisas ? "Active" : "Expired"),
          icon: getTabIcon(tab)
        );
      }).toList()
    );
  }

  bool isCurrentTabActive(VisaTab tab){
    return VisaTab.values.indexOf(activeTab) == VisaTab.values.indexOf(tab);
  }

  Icon getTabIcon(VisaTab tab){
    var icon = tab == VisaTab.AllVisas ? Icons.credit_card : tab == VisaTab.ActiveVisas ? Icons.check : Icons.close;
    return Icon(icon, color: isCurrentTabActive(tab) ? ColorsPalette.algalFuel : ColorsPalette.mazarineBlue);
  }
}
