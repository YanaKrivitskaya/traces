import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../../../utils/api/customException.dart';
import '../../../../utils/misc/state_types.dart';
import '../../../../utils/services/shared_preferencies_service.dart';
import '../../../profile/model/group_model.dart';
import '../../../profile/repository/api_profile_repository.dart';
import '../../model/visa.model.dart';
import '../../model/visa_settings.model.dart';
import '../../repository/api_visas_repository.dart';

part 'visa_details_event.dart';
part 'visa_details_state.dart';

class VisaDetailsBloc extends Bloc<VisaDetailsEvent, VisaDetailsState> {
  final ApiVisasRepository visasRepository;
  final ApiProfileRepository profileRepository;
  SharedPreferencesService sharedPrefsService = SharedPreferencesService();
  
  VisaDetailsBloc(): 
    profileRepository = new ApiProfileRepository(),
    visasRepository = new ApiVisasRepository(),
    super(VisaDetailsState.empty()){
      on<GetVisaDetails>(_onGetVisaDetails);
      on<NewVisaMode>(_onNewVisaMode);
      on<SaveVisaClicked>(_onSaveVisaClicked);
      on<VisaSubmitted>(_onVisaSubmitted);
      on<DateFromChanged>(_onDateFromChanged);
      on<DateToChanged>(_onDateToChanged);
      on<EditVisaClicked>(_onEditVisaClicked);
      on<DeleteVisaClicked>(_onDeleteVisaClicked);
      on<TabUpdatedClicked>(_onTabUpdatedClicked);
    } 

  void _onGetVisaDetails(GetVisaDetails event, Emitter<VisaDetailsState> emit) async{
    var currentState = state;
    emit(VisaDetailsState.loading());
    
    try{
      Visa? visa = await visasRepository.getVisaById(event.visaId);      

      emit(VisaDetailsState.success(visa: visa));      
    }on CustomException catch(e){
      if(currentState.visa != null) {
        emit(VisaDetailsState.success(visa: currentState.visa));
        emit(state.update(errorMessage: e));
      } else{
        emit(VisaDetailsState.failure(error: e));
      }      
    }
  } 

  void _onDeleteVisaClicked(DeleteVisaClicked event, Emitter<VisaDetailsState> emit) async{
    try{
      await visasRepository.deleteVisa(event.visaId!);
    }on CustomException catch(e){
      emit(state.update(errorMessage: e));
    }
  } 

  void _onNewVisaMode(NewVisaMode event, Emitter<VisaDetailsState> emit) async{
    emit(VisaDetailsState.loading());

    try{
      List<Group> accountGroups = await profileRepository.getGroups();
      var familyGroup = accountGroups.firstWhere((g) => g.name == "Family");

      Group family = await profileRepository.getGroupUsers(familyGroup.id!);

      Visa visa = new Visa(      
        startDate: DateTime.now(),
        endDate: DateTime.now()
      );

      emit(VisaDetailsState.editing(
        visa: visa,
        members: family,
        autovalidate: false)); 
    }on CustomException catch(e){
      emit(VisaDetailsState.failure(error: e));
    }
  }

  void _onEditVisaClicked(EditVisaClicked event, Emitter<VisaDetailsState> emit) async{
    var currentState = state;
    emit(VisaDetailsState.loading());

    try{
      Visa? visa = await visasRepository.getVisaById(event.visaId);

      List<Group> accountGroups = await profileRepository.getGroups();
      var familyGroup = accountGroups.firstWhere((g) => g.name == "Family");

      Group family = await profileRepository.getGroupUsers(familyGroup.id!);

      emit(VisaDetailsState.editing(
        visa: visa,        
        members: family,
        autovalidate: false));
    }on CustomException catch(e){
      if(currentState.visa != null) {
        emit(VisaDetailsState.editing(
          visa: currentState.visa,        
          members: currentState.familyGroup,
          autovalidate: false));
        emit(state.update(errorMessage: e));
      } else{
        emit(VisaDetailsState.failure(error: e));
      }   
    }   
  }  

  void _onDateFromChanged(DateFromChanged event, Emitter<VisaDetailsState> emit) async{
    Visa updVisa = state.visa!;
    updVisa = updVisa.copyWith(startDate: event.dateFrom);

    emit(state.update(visa: updVisa));
  } 

  void _onDateToChanged(DateToChanged event, Emitter<VisaDetailsState> emit) async{
     Visa updVisa = state.visa!;
    updVisa = updVisa.copyWith(endDate: event.dateTo);

    emit(state.update(visa: updVisa));
  } 

  void _onVisaSubmitted(VisaSubmitted event, Emitter<VisaDetailsState> emit) async{
    String errorMessage = "";

    if (!event.isFormValid) {
      errorMessage = 'Required fields should not be empty';
    }

    //validate dates
    if (event.visa!.endDate!.difference(event.visa!.startDate!).inDays < 1) {
      errorMessage += "\nEnd date should be greater than Start date";
    }

    if (errorMessage.isNotEmpty) {
      emit(state.update(errorMessage: CustomException(Error.BadRequest, errorMessage)));
    } else {
      add(SaveVisaClicked(event.visa));
    }
  }

  void _onSaveVisaClicked(SaveVisaClicked event, Emitter<VisaDetailsState> emit) async{
    emit(state.copyWith(status: StateStatus.Loading, mode: StateMode.Edit));

    var visa = event.visa;

    try{
      if (visa?.id != null) {
        visa = await visasRepository.updateVisa(visa!, visa.user!.userId!);
      } else {
        visa = await visasRepository.createVisa(visa!, visa.user!.userId!);          
      }

      emit(VisaDetailsState.success(
        visa: visa,        
        members: state.familyGroup));
    }on CustomException catch(e){
      /*if(state.visa != null) emit(state.update(errorMessage: e));
      else */emit(VisaDetailsState.failure(error: e, visa: state.visa, members: state.familyGroup));
    }
  } 

  void _onTabUpdatedClicked(TabUpdatedClicked event, Emitter<VisaDetailsState> emit) async{
    await sharedPrefsService.writeInt(key: "visaTab", value: event.index);
    
    emit(state.update());
  }
}
