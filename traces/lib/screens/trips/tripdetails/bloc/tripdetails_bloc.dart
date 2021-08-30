import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:traces/screens/profile/model/group_model.dart';
import 'package:traces/screens/profile/model/group_user_model.dart';
import 'package:traces/screens/profile/repository/api_profile_repository.dart';
import 'package:traces/screens/trips/model/trip.model.dart';
import 'package:traces/screens/trips/repository/api_activities_repository.dart';
import 'package:traces/screens/trips/repository/api_bookings_repository.dart';
import 'package:traces/screens/trips/repository/api_expenses_repository.dart';
import 'package:traces/screens/trips/repository/api_tickets_repository.dart';
import 'package:traces/screens/trips/repository/api_trips_repository.dart';
import 'package:traces/utils/api/customException.dart';
import 'package:traces/utils/services/shared_preferencies_service.dart';

part 'tripdetails_event.dart';
part 'tripdetails_state.dart';

class TripDetailsBloc extends Bloc<TripDetailsEvent, TripDetailsState> {
  final ApiTripsRepository _tripsRepository;
  final ApiProfileRepository _profileRepository;
  final ApiExpensesRepository _expensesRepository;
  final ApiBookingsRepository _bookingsRepository;
  final ApiTicketsRepository _ticketsRepository;
  final ApiActivitiesRepository _activitiesRepository;
   SharedPreferencesService sharedPrefsService = SharedPreferencesService();
  
  TripDetailsBloc() : 
  _tripsRepository = new ApiTripsRepository(),
  _profileRepository = new ApiProfileRepository(),
  _expensesRepository = new ApiExpensesRepository(),
  _bookingsRepository = new ApiBookingsRepository(),
  _ticketsRepository = new ApiTicketsRepository(),
  _activitiesRepository = new ApiActivitiesRepository(),
  super(TripDetailsInitial(0));

  @override
  Stream<TripDetailsState> mapEventToState(TripDetailsEvent event) async* {
    if (event is GetTripDetails) {
      yield* _mapGetTripDetailsToState(event);
    } else if (event is UpdateTripDetailsSuccess){
      yield* _mapUpdateTripDetailsToSuccessState(event);
    } else if (event is DeleteTripClicked){
      yield* _mapDeleteTripToState(event);
    } else if (event is TabUpdated) {
      yield* _mapTabUpdatedToState(event);
    } else if (event is UpdateExpenses) {
      yield* _mapUpdateExpensesToState(event);
    } else if (event is UpdateBookings) {
      yield* _mapUpdateBookingsToState(event);
    } else if (event is UpdateActivities) {
      yield* _mapUpdateActivitiesToState(event);
    } else if (event is UpdateTickets) {
      yield* _mapUpdateTicketsToState(event);
    }
  }

  Stream<TripDetailsState> _mapUpdateTripDetailsToSuccessState(
      UpdateTripDetailsSuccess event) async* {
    yield TripDetailsSuccessState(     
      event.trip,
      event.members,
      state.activeTab
    );
  }

  Stream<TripDetailsState> _mapGetTripDetailsToState(GetTripDetails event) async* {
    try{
      Trip? trip = await _tripsRepository.getTripById(event.tripId);
      var profile = await _profileRepository.getProfileWithGroups();      
      var familyGroup = profile.groups!.firstWhere((g) => g.name == "Family");

      Group family = await _profileRepository.getGroupUsers(familyGroup.id!);
      
      if(trip != null){
        yield TripDetailsSuccessState(     
          trip,
          family.users,
          0
        );
      }      
    }on CustomException catch(e){
      yield TripDetailsErrorState(e.toString(), state.activeTab);
    }
      
  }

  Stream<TripDetailsState> _mapDeleteTripToState(DeleteTripClicked event) async* {
    try{
      await _tripsRepository.deleteTrip(event.tripId);
      yield TripDetailsDeleted(state.activeTab);
    }on CustomException catch(e){
      yield TripDetailsErrorState(e.toString(), state.activeTab);
    }    
  }

  Stream<TripDetailsState> _mapTabUpdatedToState(TabUpdated event) async* {
    await sharedPrefsService.writeInt(key: "tripTab", value: event.tab);
    yield TripDetailsSuccessState(     
      state.trip!,
      state.familyMembers!,
      event.tab
    );
  }

  Stream<TripDetailsState> _mapUpdateExpensesToState(UpdateExpenses event) async* {    
    yield TripDetailsLoading(state.activeTab, trip: state.trip, familyMembers: state.familyMembers);
    try{
      var expenses = await _expensesRepository.getTripExpenses(event.tripId);

      Trip trip = state.trip!.copyWith(expenses: expenses);

      yield TripDetailsSuccessState(     
        trip,
        state.familyMembers!,
        state.activeTab
      );
    } on CustomException catch(e){
      yield TripDetailsErrorState(e.toString(), state.activeTab);
    } on Exception catch (e){
      yield TripDetailsErrorState(e.toString(), state.activeTab);
    }
  }

  Stream<TripDetailsState> _mapUpdateActivitiesToState(UpdateActivities event) async* {    
    yield TripDetailsLoading(state.activeTab, trip: state.trip, familyMembers: state.familyMembers);
    try{
      var activities = await _activitiesRepository.getTripActivities(event.tripId);
      var expenses = await _expensesRepository.getTripExpenses(event.tripId);

      Trip trip = state.trip!.copyWith(expenses: expenses, activities: activities);

      yield TripDetailsSuccessState(     
        trip,
        state.familyMembers!,
        state.activeTab
      );
    } on CustomException catch(e){
      yield TripDetailsErrorState(e.toString(), state.activeTab);
    } on Exception catch (e){
      yield TripDetailsErrorState(e.toString(), state.activeTab);
    }
  }

  Stream<TripDetailsState> _mapUpdateBookingsToState(UpdateBookings event) async* {    
    yield TripDetailsLoading(state.activeTab, trip: state.trip, familyMembers: state.familyMembers);
    try{
      var bookings = await _bookingsRepository.getTripBookings(event.tripId);
      var expenses = await _expensesRepository.getTripExpenses(event.tripId);

      Trip trip = state.trip!.copyWith(expenses: expenses, bookings: bookings);

      yield TripDetailsSuccessState(     
        trip,
        state.familyMembers!,
        state.activeTab
      );
    } on CustomException catch(e){
      yield TripDetailsErrorState(e.toString(), state.activeTab);
    } on Exception catch (e){
      yield TripDetailsErrorState(e.toString(), state.activeTab);
    }
  }

  Stream<TripDetailsState> _mapUpdateTicketsToState(UpdateTickets event) async* {    
    yield TripDetailsLoading(state.activeTab, trip: state.trip, familyMembers: state.familyMembers);
    try{
      var tickets = await _ticketsRepository.getTripTickets(event.tripId);
      var expenses = await _expensesRepository.getTripExpenses(event.tripId);

      Trip trip = state.trip!.copyWith(expenses: expenses, tickets: tickets);

      yield TripDetailsSuccessState(     
        trip,
        state.familyMembers!,
        state.activeTab
      );
    } on CustomException catch(e){
      yield TripDetailsErrorState(e.toString(), state.activeTab);
    } on Exception catch (e){
      yield TripDetailsErrorState(e.toString(), state.activeTab);
    }
  }

}
