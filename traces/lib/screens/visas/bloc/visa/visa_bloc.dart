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
        super(VisaState.empty()){
          on<GetAllVisas>(_onGetAllVisas);
        }

  void _onGetAllVisas(GetAllVisas event, Emitter<VisaState> emit) async{
    emit(VisaState.loading());

    try{
      var visas = await visasRepository.getVisas();
      return emit(VisaState.success(allVisas: visas));
    } on CustomException catch(e){
      return emit(VisaState.failure(error: e));
    } 
  }  
}
