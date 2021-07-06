import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../../../utils/misc/state_types.dart';
import '../../../profile/model/group_model.dart';
import '../../../profile/repository/api_profile_repository.dart';
import '../../model/entryExit.dart';
import '../../model/user_countries.dart';
import '../../model/visa.model.dart';
import '../../model/visa_settings.model.dart';
import '../../repository/api_visas_repository.dart';

part 'visa_details_event.dart';
part 'visa_details_state.dart';

class VisaDetailsBloc extends Bloc<VisaDetailsEvent, VisaDetailsState> {
  final ApiVisasRepository visasRepository;
  final ApiProfileRepository profileRepository;
  
  VisaDetailsBloc(): 
    profileRepository = new ApiProfileRepository(),
    visasRepository = new ApiVisasRepository(),
    super(VisaDetailsState.empty());

  @override
  Stream<VisaDetailsState> mapEventToState(VisaDetailsEvent event) async* {
    if (event is GetVisaDetails) {
      yield* _mapGetVisaDetailsToState(event);
    } else if (event is NewVisaMode) {
      yield* _mapNewVisaModeToState(event);
    } else if (event is SaveVisaClicked) {
      yield* _mapSaveVisaClickedToState(event.visa!);
    } else if (event is VisaSubmitted) {
      yield* _mapVisaSubmittedToState(event);
    } else if (event is DateFromChanged) {
      yield* _mapDateFromChangedToState(event);
    } else if (event is DateToChanged) {
      yield* _mapDateToChangedToState(event);
    } else if (event is EditVisaClicked) {
      yield* _mapEditVisaModeToState(event);
    } else if (event is DeleteVisaClicked) {
      yield* _mapDeleteVisaEventToState(event);
    } else if (event is TabUpdatedClicked) {
      yield* _mapTabUpdatedToState(event);
    }
  }
  
  Stream<VisaDetailsState> _mapGetVisaDetailsToState(
      GetVisaDetails event) async* {
    yield VisaDetailsState.loading();

    Visa? visa = await visasRepository.getVisaById(event.visaId);

    yield VisaDetailsState.success(
        visa: visa,
        entryExits: null,  
        settings: null);   
  }

  Stream<VisaDetailsState> _mapDeleteVisaEventToState(
      DeleteVisaClicked event) async* {
    await visasRepository.deleteVisa(event.visaId!);
  }

  Stream<VisaDetailsState> _mapNewVisaModeToState(NewVisaMode event) async* {
    yield VisaDetailsState.loading();
    
    List<Group> accountGroups = await profileRepository.getGroups();
    var familyGroup = accountGroups.firstWhere((g) => g.name == "Family");

    Group family = await profileRepository.getGroupUsers(familyGroup.id!);

    Visa visa = new Visa(      
      startDate: DateTime.now(),
      endDate: DateTime.now()
    );

    yield VisaDetailsState.editing(
      visa: visa,
      members: family,
      autovalidate: false);   

  }

  Stream<VisaDetailsState> _mapEditVisaModeToState(
      EditVisaClicked event) async* {
    yield VisaDetailsState.loading();

    Visa? visa = await visasRepository.getVisaById(event.visaId);

    List<Group> accountGroups = await profileRepository.getGroups();
    var familyGroup = accountGroups.firstWhere((g) => g.name == "Family");

    Group family = await profileRepository.getGroupUsers(familyGroup.id!);

    yield VisaDetailsState.editing(
      visa: visa,        
      members: family,
      autovalidate: false);   
  }

  Stream<VisaDetailsState> _mapDateFromChangedToState(
      DateFromChanged event) async* {
    Visa updVisa = state.visa!;
    updVisa = updVisa.copyWith(startDate: event.dateFrom);

    yield state.update(visa: updVisa);
  }

  Stream<VisaDetailsState> _mapDateToChangedToState(
      DateToChanged event) async* {
    Visa updVisa = state.visa!;
    updVisa = updVisa.copyWith(endDate: event.dateTo);

    yield state.update(visa: updVisa);
  }

  Stream<VisaDetailsState> _mapVisaSubmittedToState(
      VisaSubmitted event) async* {
    String errorMessage = "";

    if (!event.isFormValid) {
      errorMessage = 'Required fields should not be empty';
    }

    //validate dates
    if (event.visa!.endDate!.difference(event.visa!.startDate!).inDays < 1) {
      errorMessage += "\nEnd date should be greater than Start date";
    }

    if (errorMessage.isNotEmpty) {
      yield VisaDetailsState.failure(
          visa: event.visa,          
          members: state.familyGroup,
          autovalidate: true,
          error: errorMessage);
    } else {
      add(SaveVisaClicked(event.visa));
    }
  }

  Stream<VisaDetailsState> _mapSaveVisaClickedToState(Visa visa) async* {
    yield state.copyWith(status: StateStatus.Loading, mode: StateMode.Edit);

    if (visa.id != null) {
      visa = await visasRepository.updateVisa(visa, visa.user!.userId!);
    } else {
      visa = await visasRepository.createVisa(visa, visa.user!.userId!);          
    }

    yield VisaDetailsState.success(
        visa: visa,        
        members: state.familyGroup);    
  }

  Stream<VisaDetailsState> _mapTabUpdatedToState(
      TabUpdatedClicked event) async* {
    
    yield state.update(activeTab: event.index);
  }
}
