import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
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
  super(TripDetailsInitial(0)){
    on<GetTripDetails>(_onGetTripDetails);
    on<UpdateTripDetailsSuccess>(_onUpdateTripDetailsSuccess);
    on<DeleteTripClicked>(_onDeleteTripClicked);
    on<TabUpdated>(_onTabUpdated);
    on<UpdateExpenses>(_onUpdateExpenses);
    on<UpdateBookings>(_onUpdateBookings);
    on<UpdateActivities>(_onUpdateActivities);
    on<UpdateTickets>(_onUpdateTickets);
    on<GetImage>(_onGetImage);
    on<UpdateTripClicked>(_onUpdateTripClicked);
    on<DateRangeUpdated>(_onDateRangeUpdated);
  }

  void _onUpdateTripDetailsSuccess(
      UpdateTripDetailsSuccess event, Emitter<TripDetailsState> emit) async {
    emit(TripDetailsSuccessState(     
      event.trip,
      event.members,
      state.activeTab
    ));
  }

  void _onGetTripDetails(GetTripDetails event, Emitter<TripDetailsState> emit) async {
    try{
      Trip? trip = await _tripsRepository.getTripById(event.tripId);
      var profile = await _profileRepository.getProfileWithGroups();      
      var familyGroup = profile.groups!.firstWhere((g) => g.name == "Family");

      Group family = await _profileRepository.getGroupUsers(familyGroup.id!);
      
      if(trip != null){
        emit(TripDetailsSuccessState(     
          trip,
          family.users,
          state.activeTab
        ));
      }      
    }on CustomException catch(e){
      emit(TripDetailsErrorState(e.toString(), state.activeTab));
    }
      
  }

  void _onDeleteTripClicked(DeleteTripClicked event, Emitter<TripDetailsState> emit) async {
    try{
      await _tripsRepository.deleteTrip(event.tripId);
      emit(TripDetailsDeleted(state.activeTab));
    }on CustomException catch(e){
      emit(TripDetailsErrorState(e.toString(), state.activeTab));
    }    
  }

  void _onUpdateTripClicked(UpdateTripClicked event, Emitter<TripDetailsState> emit) async {
    try{
      Trip trip = await _tripsRepository.updateTrip(event.updTrip, 0);
      emit(TripDetailsUpdated(state.activeTab, trip));
    }on CustomException catch(e){
      emit(TripDetailsErrorState(e.toString(), state.activeTab));
    }    
  }

  void _onDateRangeUpdated(DateRangeUpdated event, Emitter<TripDetailsState> emit) async {
    
    Trip trip = state.trip ?? new Trip();

    Trip updTrip = trip.copyWith(startDate: event.startDate, endDate: event.endDate);

    emit(TripDetailsSuccessState(     
          updTrip,
          state.familyMembers!,
          state.activeTab
        ));
  }

  void _onTabUpdated(TabUpdated event, Emitter<TripDetailsState> emit) async {
    await sharedPrefsService.writeInt(key: "tripTab", value: event.tab);
    emit(TripDetailsSuccessState(     
      state.trip!,
      state.familyMembers!,
      event.tab
    ));
  }

  void _onUpdateExpenses(UpdateExpenses event, Emitter<TripDetailsState> emit) async {    
    emit(TripDetailsLoading(state.activeTab, trip: state.trip, familyMembers: state.familyMembers));
    try{
      var expenses = await _expensesRepository.getTripExpenses(event.tripId);

      Trip trip = state.trip!.copyWith(expenses: expenses);

      emit(TripDetailsSuccessState(     
        trip,
        state.familyMembers!,
        state.activeTab
      ));
    } on CustomException catch(e){
      emit(TripDetailsErrorState(e.toString(), state.activeTab));
    } on Exception catch (e){
      emit(TripDetailsErrorState(e.toString(), state.activeTab));
    }
  }

  void _onUpdateActivities(UpdateActivities event, Emitter<TripDetailsState> emit) async {    
    emit(TripDetailsLoading(state.activeTab, trip: state.trip, familyMembers: state.familyMembers));
    try{
      var activities = await _activitiesRepository.getTripActivities(event.tripId);
      var expenses = await _expensesRepository.getTripExpenses(event.tripId);

      Trip trip = state.trip!.copyWith(expenses: expenses, activities: activities);

      emit(TripDetailsSuccessState(     
        trip,
        state.familyMembers!,
        state.activeTab
      ));
    } on CustomException catch(e){
      emit(TripDetailsErrorState(e.toString(), state.activeTab));
    } on Exception catch (e){
      emit(TripDetailsErrorState(e.toString(), state.activeTab));
    }
  }

  void _onUpdateBookings(UpdateBookings event, Emitter<TripDetailsState> emit) async {    
    emit(TripDetailsLoading(state.activeTab, trip: state.trip, familyMembers: state.familyMembers));
    try{
      var bookings = await _bookingsRepository.getTripBookings(event.tripId);
      var expenses = await _expensesRepository.getTripExpenses(event.tripId);

      Trip trip = state.trip!.copyWith(expenses: expenses, bookings: bookings);

      emit(TripDetailsSuccessState(     
        trip,
        state.familyMembers!,
        state.activeTab
      ));
    } on CustomException catch(e){
      emit(TripDetailsErrorState(e.toString(), state.activeTab));
    } on Exception catch (e){
      emit(TripDetailsErrorState(e.toString(), state.activeTab));
    }
  }

  void _onUpdateTickets(UpdateTickets event, Emitter<TripDetailsState> emit) async {    
    emit(TripDetailsLoading(state.activeTab, trip: state.trip, familyMembers: state.familyMembers));
    try{
      var tickets = await _ticketsRepository.getTripTickets(event.tripId);
      var expenses = await _expensesRepository.getTripExpenses(event.tripId);

      Trip trip = state.trip!.copyWith(expenses: expenses, tickets: tickets);

      emit(TripDetailsSuccessState(     
        trip,
        state.familyMembers!,
        state.activeTab
      ));
    } on CustomException catch(e){
      emit(TripDetailsErrorState(e.toString(), state.activeTab));
    } on Exception catch (e){
      emit(TripDetailsErrorState(e.toString(), state.activeTab));
    }
  }

  void _onGetImage(GetImage event, Emitter<TripDetailsState> emit) async {
    try{
      var image = state.trip?.coverImage;
      Trip updTrip = state.trip!;

      if(event.image != null){
        image = event.image!.readAsBytesSync();
        updTrip = await _tripsRepository.updateTripImage(event.image!, updTrip.id!);
      }      

      emit(TripDetailsSuccessState(     
        updTrip,
        state.familyMembers!,
        state.activeTab
      ));
    }on CustomException catch(e){
      emit(TripDetailsErrorState(e.toString(), state.activeTab));
    } on Exception catch (e){
      emit(TripDetailsErrorState(e.toString(), state.activeTab));
    }
    
    
  }

}
