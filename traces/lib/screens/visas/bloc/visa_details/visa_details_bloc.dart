import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:traces/screens/profile/repository/profile_repository.dart';
import 'package:traces/screens/visas/model/entryExit.dart';
import 'package:traces/screens/visas/model/settings.dart';
import 'package:traces/screens/visas/model/user_countries.dart';
import 'package:traces/screens/visas/model/visa.dart';
import 'package:traces/screens/visas/repository/visas_repository.dart';
import 'package:traces/shared/state_types.dart';

part 'visa_details_event.dart';
part 'visa_details_state.dart';

class VisaDetailsBloc extends Bloc<VisaDetailsEvent, VisaDetailsState> {
  final VisasRepository _visasRepository;
  final ProfileRepository _profileRepository;
  StreamSubscription _visasSubscription;

  VisaDetailsBloc({@required VisasRepository visasRepository, @required ProfileRepository profileRepository})
      : assert(visasRepository != null),
        _visasRepository = visasRepository,
        _profileRepository = profileRepository, super(VisaDetailsState.empty());


  @override
  VisaDetailsState get initialState => VisaDetailsState.empty();

  @override
  Stream<VisaDetailsState> mapEventToState(VisaDetailsEvent event) async* {
    if(event is GetVisaDetails){
      yield* _mapGetVisaDetailsToState(event);
    }else if(event is NewVisaMode){
      yield* _mapNewVisaModeToState(event);
    }else if(event is SaveVisaClicked){
      yield* _mapSaveVisaClickedToState(event.visa);
    }else if(event is VisaSubmitted){
      yield* _mapVisaSubmittedToState(event);
    }else if(event is UpdateVisaDetails){
      yield* _mapUpdateVisaDetailsListToState(event);
    }else if(event is DateFromChanged){
      yield* _mapDateFromChangedToState(event);
    }else if(event is DateToChanged){
      yield* _mapDateToChangedToState(event);
    }else if(event is EditVisaClicked){
      yield* _mapEditVisaModeToState(event);
    }else if(event is DeleteVisaClicked){
      yield* _mapDeleteVisaEventToState(event);
    }
  }

  Stream<VisaDetailsState> _mapUpdateVisaDetailsListToState(UpdateVisaDetails event) async* {
    yield VisaDetailsState.success(visa: event.visa, entryExits: event.entryExists, settings: event.settings);
  }

  Stream<VisaDetailsState> _mapGetVisaDetailsToState(GetVisaDetails event) async*{
    Visa visa = await _visasRepository.getVisaById(event.visaId);

    yield VisaDetailsState.loading();

    VisaSettings settings = await _visasRepository.settings();

    _visasSubscription?.cancel();

    _visasSubscription = _visasRepository.entryExits(visa.id).listen(
          (entryExits) => add(UpdateVisaDetails(visa, entryExits, settings)),
    );
  }

  Stream<VisaDetailsState> _mapDeleteVisaEventToState(DeleteVisaClicked event) async*{
    await _visasRepository.deleteVisa(event.visaId);
  }

  Stream<VisaDetailsState> _mapNewVisaModeToState(NewVisaMode event) async*{
    yield VisaDetailsState.loading();

    UserCountries userCountries = await _visasRepository.userCountries();
    VisaSettings settings = await _visasRepository.settings();
    var userProfile = await _profileRepository.getCurrentProfile();
    List<String> members = userProfile.familyMembers;

    if(members.length == 0){
      members.add(userProfile.displayName);
    }

    yield VisaDetailsState.editing(visa: null, settings: settings, userCountries: userCountries, members: members, autovalidate: false);
  }

  Stream<VisaDetailsState> _mapEditVisaModeToState(EditVisaClicked event) async*{
    yield VisaDetailsState.loading();

    UserCountries userCountries = await _visasRepository.userCountries();
    VisaSettings settings = await _visasRepository.settings();
    var userProfile = await _profileRepository.getCurrentProfile();
    List<String> members = userProfile.familyMembers;

    if(members.length == 0){
      members.add(userProfile.displayName);
    }

    Visa visa = await _visasRepository.getVisaById(event.visaId);

    yield VisaDetailsState.editing(visa: visa, settings: settings, userCountries: userCountries, members: members, autovalidate: false);
  }

  Stream<VisaDetailsState> _mapDateFromChangedToState(DateFromChanged event) async*{
    Visa updVisa = state.visa;
    updVisa.startDate = event.dateFrom;

    yield state.update(visa: updVisa);
  }

  Stream<VisaDetailsState> _mapDateToChangedToState(DateToChanged event) async*{
    Visa updVisa = state.visa;
    updVisa.endDate = event.dateTo;

    yield state.update(visa: updVisa);
  }

  Stream<VisaDetailsState> _mapVisaSubmittedToState(VisaSubmitted event)async*{
    String errorMessage = "";

    if(!event.isFormValid){
      errorMessage = 'Required fields should not be empty';
    }

    //validate dates
    if(event.visa.endDate.difference(event.visa.startDate).inDays < 1){
      errorMessage += "\nEnd date should be greater than Start date";
    }

    if(errorMessage.isNotEmpty){
      yield VisaDetailsState.failure(
          visa: event.visa,
          settings: state.settings,
          userCountries: state.userCountries,
          members: state.familyMembers,
          autovalidate: true,
          error: errorMessage);
    }else{
      add(SaveVisaClicked(event.visa));
    }
  }

  Stream<VisaDetailsState> _mapSaveVisaClickedToState(Visa visa) async*{
    yield state.copyWith(status: StateStatus.Loading, mode: StateMode.Edit);

    if(visa.id != null){
      visa = await _visasRepository.updateVisa(visa).timeout(Duration(seconds: 3), onTimeout: (){
        print("have timeout");
        return visa;
      });
    }else{
      visa = await _visasRepository.addNewVisa(visa).timeout(Duration(seconds: 3), onTimeout: (){
        print("have timeout");
        return visa;
      });
    }

    UserCountries userCountries = await _visasRepository.userCountries();

    if(userCountries.countries.where((c) => c == visa.countryOfIssue).length == 0){
      userCountries.countries.add(visa.countryOfIssue);
      await _visasRepository.updateUserCountries(userCountries.countries).timeout(Duration(seconds: 3), onTimeout: (){
        print("have timeout");
        return null;
      });
    }

    yield VisaDetailsState.success(visa: visa, settings: state.settings, userCountries: state.userCountries, members: state.familyMembers);
  }
}
