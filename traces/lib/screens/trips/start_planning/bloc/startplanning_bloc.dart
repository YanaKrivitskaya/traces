import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:traces/screens/trips/model/api_models/currency.model.dart';
import 'package:traces/screens/trips/repository/currency_repository.dart';

import '../../../../utils/api/customException.dart';
import '../../../profile/model/group_model.dart';
import '../../../profile/repository/api_profile_repository.dart';
import '../../model/trip.model.dart';
import '../../repository/api_trips_repository.dart';

part 'startplanning_event.dart';
part 'startplanning_state.dart';

class StartPlanningBloc extends Bloc<StartPlanningEvent, StartPlanningState> {
  final ApiTripsRepository _tripsRepository;
  final ApiProfileRepository _profileRepository;
  final CurrencyRepository _currencyRepository;
  
  StartPlanningBloc() : 
  _tripsRepository = new ApiTripsRepository(),
  _profileRepository = new ApiProfileRepository(),
  _currencyRepository = new CurrencyRepository(),
  super(StartPlanningInitial(null, null)){
    on<NewTripMode>(_onNewTripMode);
    on<DateRangeUpdated>(_onDateRangeUpdated);
    on<StartPlanningSubmitted>(_onStartPlanningSubmitted);
  } 

  void _onNewTripMode(NewTripMode event, Emitter<StartPlanningState> emit) async{
    List<Currency>? currencies = await _currencyRepository.getCurrencies();

    emit(StartPlanningSuccessState(new Trip(), currencies, false));
  } 

  void _onDateRangeUpdated(DateRangeUpdated event, Emitter<StartPlanningState> emit) async{
    Trip trip = state.trip ?? new Trip();

    Trip updTrip = trip.copyWith(startDate: event.startDate, endDate: event.endDate);

    emit(StartPlanningSuccessState(updTrip, state.currencies, false));
  } 

  void _onStartPlanningSubmitted(StartPlanningSubmitted event, Emitter<StartPlanningState> emit) async{
    emit(StartPlanningSuccessState(event.trip, state.currencies, true));

    if(event.trip!.startDate == null || event.trip!.endDate == null){
      var error = 'Please choose the dates';
      emit(StartPlanningErrorState(event.trip, state.currencies, error));
    }
    else{
      try{
        var profile = await _profileRepository.getProfileWithGroups();      
        var familyGroup = profile.groups!.firstWhere((g) => g.name == "Family");

        Group family = await _profileRepository.getGroupUsers(familyGroup.id!);
        event.trip!.users = [family.users.firstWhere((u) => u.accountId == profile.accountId)];

        Trip trip = await _tripsRepository.createTrip(event.trip!, profile.accountId);        

        emit(StartPlanningCreatedState(trip, state.currencies,));
      } on CustomException catch(e){
        emit(StartPlanningErrorState(event.trip, state.currencies, e.toString()));
      }
      
    } 
  }
}
