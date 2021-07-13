import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:traces/utils/api/customException.dart';

import '../../../../utils/misc/state_types.dart';
import '../../model/visa.model.dart';
import '../../repository/api_visas_repository.dart';

part 'visa_event.dart';
part 'visa_state.dart';

class VisaBloc extends Bloc<VisaEvent, VisaState> {
  final ApiVisasRepository visasRepository; 

  VisaBloc(): 
        visasRepository = new ApiVisasRepository(),
        super(VisaState.empty());

  @override
  Stream<VisaState> mapEventToState(VisaEvent event) async* {
    if (event is GetAllVisas) {
      yield* _mapGetVisasToState(event);
    }
  }

  Stream<VisaState> _mapGetVisasToState(GetAllVisas event) async* {
    yield VisaState.loading();

    try{
      var visas = await visasRepository.getVisas();
      yield VisaState.success(allVisas: visas);
    } on CustomException catch(e){
      yield VisaState.failure(error: e);
    }

   

   
  }
}
