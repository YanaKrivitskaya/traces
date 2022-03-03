import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../model/visa_tab.dart';

part 'visa_tab_event.dart';

class VisaTabBloc extends Bloc<VisaTabEvent, VisaTab> {
  VisaTabBloc() : super(VisaTab.AllVisas){
    on<VisaTabEvent>((event, emit) => {
      if (event is TabUpdated) {
        emit(event.tab)
      }
    });
  }
}
