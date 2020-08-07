part of 'visa_tab_bloc.dart';

@immutable
abstract class VisaTabEvent extends Equatable {
  const VisaTabEvent();
}

class TabUpdated extends VisaTabEvent{
  final VisaTab tab;

  const TabUpdated(this.tab);

  @override
  List<Object> get props => [tab];

  @override
  String toString() => 'UpdateTab { tab: $tab }';

}
