import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:traces/screens/profile/model/member.dart';
import '../../../../shared/state_types.dart';
import '../../../profile/repository/profile_repository.dart';
import '../../model/entryExit.dart';
import '../../model/settings.dart';
import '../../model/user_countries.dart';
import '../../model/visa.dart';
import '../../repository/visas_repository.dart';

part 'visa_details_event.dart';
part 'visa_details_state.dart';

class VisaDetailsBloc extends Bloc<VisaDetailsEvent, VisaDetailsState> {
  final VisasRepository _visasRepository;
  final ProfileRepository _profileRepository;
  StreamSubscription _visasSubscription;
  StreamSubscription _profileSubscription;

  VisaDetailsBloc(
      {@required VisasRepository visasRepository,
      @required ProfileRepository profileRepository})
      : assert(visasRepository != null),
        _visasRepository = visasRepository,
        _profileRepository = profileRepository,
        super(VisaDetailsState.empty());

  @override
  Stream<VisaDetailsState> mapEventToState(VisaDetailsEvent event) async* {
    if (event is GetVisaDetails) {
      yield* _mapGetVisaDetailsToState(event);
    } else if (event is NewVisaMode) {
      yield* _mapNewVisaModeToState(event);
    } else if (event is SaveVisaClicked) {
      yield* _mapSaveVisaClickedToState(event.visa);
    } else if (event is VisaSubmitted) {
      yield* _mapVisaSubmittedToState(event);
    } else if (event is UpdateVisaDetailsSuccess) {
      yield* _mapUpdateVisaDetailsListToSuccessState(event);
    } else if (event is UpdateVisaDetailsEditing) {
      yield* _mapUpdateVisaDetailsListToEditState(event);
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

  Stream<VisaDetailsState> _mapUpdateVisaDetailsListToSuccessState(
      UpdateVisaDetailsSuccess event) async* {
    yield VisaDetailsState.success(
        visa: event.visa,
        entryExits: event.entryExits,  
        settings: event.settings);
  }

  Stream<VisaDetailsState> _mapUpdateVisaDetailsListToEditState(
      UpdateVisaDetailsEditing event) async* {
    yield VisaDetailsState.editing(
        visa: event.visa,        
        settings: event.settings,
        userSettings: event.userSettings,
        members: event.members);
  }

  Stream<VisaDetailsState> _mapGetVisaDetailsToState(
      GetVisaDetails event) async* {
    Visa visa = await _visasRepository.getVisaById(event.visaId);

    var member = await _profileRepository.getMemberById(visa.owner);

    visa.owner = member.name;

    yield VisaDetailsState.loading();

    VisaSettings settings = await _visasRepository.settings();

    _visasSubscription?.cancel();

    _visasSubscription = _visasRepository.entryExits(visa.id).listen(
          (entryExits) => add(UpdateVisaDetailsSuccess(
              visa, entryExits, settings
            )),
        );
  }

  Stream<VisaDetailsState> _mapDeleteVisaEventToState(
      DeleteVisaClicked event) async* {
    await _visasRepository.deleteVisa(event.visaId);
  }

  Stream<VisaDetailsState> _mapNewVisaModeToState(NewVisaMode event) async* {
    yield VisaDetailsState.loading();

    UserSettings userSettings = await _visasRepository.userSettings();
    VisaSettings settings = await _visasRepository.settings();

    _profileSubscription?.cancel();
    
    _profileSubscription = _profileRepository.familyMembers().listen(
      (members) => add(UpdateVisaDetailsEditing(null, settings, members, userSettings))
    );   

    /*yield VisaDetailsState.editing(
        visa: null,
        settings: settings,
        userSettings: userSettings,
        members: members,
        autovalidate: false);*/
  }

  Stream<VisaDetailsState> _mapEditVisaModeToState(
      EditVisaClicked event) async* {
    yield VisaDetailsState.loading();

    UserSettings userSettings = await _visasRepository.userSettings();
    VisaSettings settings = await _visasRepository.settings();
    
    Visa visa = await _visasRepository.getVisaById(event.visaId);

    _profileSubscription?.cancel();
    
    _profileSubscription = _profileRepository.familyMembers().listen(
      (members) => add(UpdateVisaDetailsEditing(visa, settings, members, userSettings))
    );   


    /*yield VisaDetailsState.editing(
        visa: visa,
        settings: settings,
        userSettings: userSettings,
        members: members,
        autovalidate: false);*/
  }

  Stream<VisaDetailsState> _mapDateFromChangedToState(
      DateFromChanged event) async* {
    Visa updVisa = state.visa;
    updVisa.startDate = event.dateFrom;

    yield state.update(visa: updVisa);
  }

  Stream<VisaDetailsState> _mapDateToChangedToState(
      DateToChanged event) async* {
    Visa updVisa = state.visa;
    updVisa.endDate = event.dateTo;

    yield state.update(visa: updVisa);
  }

  Stream<VisaDetailsState> _mapVisaSubmittedToState(
      VisaSubmitted event) async* {
    String errorMessage = "";

    if (!event.isFormValid) {
      errorMessage = 'Required fields should not be empty';
    }

    //validate dates
    if (event.visa.endDate.difference(event.visa.startDate).inDays < 1) {
      errorMessage += "\nEnd date should be greater than Start date";
    }

    if (errorMessage.isNotEmpty) {
      yield VisaDetailsState.failure(
          visa: event.visa,
          settings: state.settings,
          userSettings: state.userSettings,
          members: state.familyMembers,
          autovalidate: true,
          error: errorMessage);
    } else {
      add(SaveVisaClicked(event.visa));
    }
  }

  Stream<VisaDetailsState> _mapSaveVisaClickedToState(Visa visa) async* {
    yield state.copyWith(status: StateStatus.Loading, mode: StateMode.Edit);

    if (visa.id != null) {
      visa = await _visasRepository
          .updateVisa(visa)
          .timeout(Duration(seconds: 3), onTimeout: () {
        print("have timeout");
        return visa;
      });
    } else {
      visa = await _visasRepository
          .addNewVisa(visa)
          .timeout(Duration(seconds: 3), onTimeout: () {
        print("have timeout");
        return visa;
      });
    }

    List<String> countries = [visa.countryOfIssue];

    await _visasRepository
          .updateUserSettings(countries, null)
          .timeout(Duration(seconds: 3), onTimeout: () {
        print("have timeout");
        return null;
      });  


    yield VisaDetailsState.success(
        visa: visa,
        settings: state.settings,
        userSettings: state.userSettings,
        members: state.familyMembers);
  }

  Stream<VisaDetailsState> _mapTabUpdatedToState(
      TabUpdatedClicked event) async* {
    
    yield state.update(activeTab: event.index);
  }
}
