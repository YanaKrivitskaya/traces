import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:traces/screens/visas/model/visa_tab.dart';

part 'visa_tab_event.dart';

part '__visa_tab_state.dart';

class VisaTabBloc extends Bloc<VisaTabEvent, VisaTab> {
  VisaTabBloc() : super(VisaTab.AllVisas);

  @override
  Stream<VisaTab> mapEventToState(VisaTabEvent event) async* {
    if (event is TabUpdated) {
      yield event.tab;
    }
  }
}
