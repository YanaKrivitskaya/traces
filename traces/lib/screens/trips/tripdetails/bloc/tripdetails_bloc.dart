import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:traces/screens/notes/repositories/api_notes_repository.dart';
import 'package:traces/screens/profile/model/group_model.dart';
import 'package:traces/screens/profile/model/group_user_model.dart';
import 'package:traces/screens/profile/repository/api_profile_repository.dart';
import 'package:traces/screens/trips/model/trip.model.dart';
import 'package:traces/screens/trips/repository/api_activities_repository.dart';
import 'package:traces/screens/trips/repository/api_bookings_repository.dart';
import 'package:traces/screens/trips/repository/api_expenses_repository.dart';
import 'package:traces/screens/trips/repository/api_tickets_repository.dart';
import 'package:traces/screens/trips/repository/api_trips_repository.dart';
import 'package:traces/screens/trips/repository/currency_repository.dart';
import 'package:traces/utils/api/customException.dart';
import 'package:traces/utils/services/shared_preferencies_service.dart';
import 'package:image_cropper/image_cropper.dart';

part 'tripdetails_event.dart';
part 'tripdetails_state.dart';

class TripDetailsBloc extends Bloc<TripDetailsEvent, TripDetailsState> {
  final ApiTripsRepository _tripsRepository;
  final ApiProfileRepository _profileRepository;
  final ApiExpensesRepository _expensesRepository;
  final CurrencyRepository _currencyRepository;
  final ApiBookingsRepository _bookingsRepository;
  final ApiTicketsRepository _ticketsRepository;
  final ApiActivitiesRepository _activitiesRepository;
  final ApiNotesRepository _notesRepository;
   SharedPreferencesService sharedPrefsService = SharedPreferencesService();
  
  TripDetailsBloc() : 
  _tripsRepository = new ApiTripsRepository(),
  _profileRepository = new ApiProfileRepository(),
  _expensesRepository = new ApiExpensesRepository(),
  _currencyRepository = new CurrencyRepository(),
  _bookingsRepository = new ApiBookingsRepository(),
  _ticketsRepository = new ApiTicketsRepository(),
  _activitiesRepository = new ApiActivitiesRepository(),
  _notesRepository = new ApiNotesRepository(),
  super(TripDetailsInitial(0, 0, 0)){
    on<GetTripDetails>(_onGetTripDetails);
    on<UpdateTripDetailsSuccess>(_onUpdateTripDetailsSuccess);
    on<DeleteTripClicked>(_onDeleteTripClicked);
    on<TripTabUpdated>(_onTripTabUpdated);
    on<ActivityTabUpdated>(_onActivityTabUpdated);
    on<ExpenseTabUpdated>(_onExpenseTabUpdated);
    on<UpdateExpenses>(_onUpdateExpenses);
    on<UpdateBookings>(_onUpdateBookings);
    on<UpdateActivities>(_onUpdateActivities);
    on<UpdateTickets>(_onUpdateTickets);
    on<UpdateNotes>(_onUpdateNotes);
    on<GetImage>(_onGetImage);
    on<UpdateTripClicked>(_onUpdateTripClicked);
    on<DateRangeUpdated>(_onDateRangeUpdated);
  }

  void _onUpdateTripDetailsSuccess(
      UpdateTripDetailsSuccess event, Emitter<TripDetailsState> emit) async {
    emit(TripDetailsSuccessState(     
      event.trip,
      event.members,
      state.activeTripTab,
      state.activeActivityTab,
      state.activeExpenseTab
    ));
  }

  void _onGetTripDetails(GetTripDetails event, Emitter<TripDetailsState> emit) async {
    try{
      Trip? trip = await _tripsRepository.getTripById(event.tripId);
      var profile = await _profileRepository.getProfileWithGroups();      
      var familyGroup = profile.groups!.firstWhere((g) => g.name == "Family");

      Group family = await _profileRepository.getGroupUsers(familyGroup.id!);

      if(trip?.expenses != null && trip!.expenses!.length > 0){
        int idx = -1;
        trip.expenses!.forEach((exp) async {
          idx = trip.expenses!.indexOf(exp);
          if(exp.amount != null && exp.currency! != "USD" && exp.amountUSD == null){            
            var currencyRate = await _currencyRepository.getCurrencyRateAmountForDate(exp.currency!, exp.amount!, exp.date ?? DateTime.now());
            exp =exp.copyWith(amountUSD: currencyRate.rateAmount);
            exp = await _expensesRepository.updateExpense(exp, trip.id!, exp.category!.id!);
          }
          trip.expenses![idx] = exp;
        });
      }
      
      if(trip != null){
        emit(TripDetailsSuccessState(     
          trip,
          family.users,
          state.activeTripTab,
          state.activeActivityTab,
          state.activeExpenseTab
        ));
      }      
    }on CustomException catch(e){
      emit(TripDetailsErrorState(e.toString(), state.activeTripTab, state.activeActivityTab, state.activeExpenseTab));
    }
      
  }

  void _onDeleteTripClicked(DeleteTripClicked event, Emitter<TripDetailsState> emit) async {
    try{
      await _tripsRepository.deleteTrip(event.tripId);
      emit(TripDetailsDeleted(state.activeTripTab, state.activeActivityTab, state.activeExpenseTab));
    }on CustomException catch(e){
      emit(TripDetailsErrorState(e.toString(), state.activeTripTab, state.activeActivityTab, state.activeExpenseTab));
    }    
  }

  void _onUpdateTripClicked(UpdateTripClicked event, Emitter<TripDetailsState> emit) async {
    try{
      Trip trip = await _tripsRepository.updateTrip(event.updTrip, 0);
      emit(TripDetailsUpdated(state.activeTripTab, state.activeActivityTab, state.activeExpenseTab, trip: trip));
    }on CustomException catch(e){
      emit(TripDetailsErrorState(e.toString(), state.activeTripTab, state.activeActivityTab, state.activeExpenseTab));
    }    
  }

  void _onDateRangeUpdated(DateRangeUpdated event, Emitter<TripDetailsState> emit) async {
    
    Trip trip = state.trip ?? new Trip();

    Trip updTrip = trip.copyWith(startDate: event.startDate, endDate: event.endDate);

    emit(TripDetailsSuccessState(     
          updTrip,
          state.familyMembers!,
          state.activeTripTab,
          state.activeActivityTab,
          state.activeExpenseTab
        ));
  }

  void _onTripTabUpdated(TripTabUpdated event, Emitter<TripDetailsState> emit) async {
    await sharedPrefsService.writeInt(key: event.tabKey, value: event.tab);
    emit(TripDetailsSuccessState(     
      state.trip!,
      state.familyMembers!,
      event.tab,
      state.activeActivityTab,
      state.activeExpenseTab
    ));
  }

  void _onActivityTabUpdated(ActivityTabUpdated event, Emitter<TripDetailsState> emit) async {
    await sharedPrefsService.writeInt(key: event.tabKey, value: event.tab);
    emit(TripDetailsSuccessState(     
      state.trip!,
      state.familyMembers!,
      state.activeTripTab,
      event.tab,
      state.activeExpenseTab
    ));
  }

  void _onExpenseTabUpdated(ExpenseTabUpdated event, Emitter<TripDetailsState> emit) async {
    //emit(TripDetailsLoading(state.activeTripTab, state.activeActivityTab, event.tab, trip: state.trip, familyMembers: state.familyMembers));
    await sharedPrefsService.writeInt(key: event.tabKey, value: event.tab);
    return emit(TripDetailsSuccessState(     
      state.trip!,
      state.familyMembers!,
      state.activeTripTab,
      state.activeActivityTab,
      event.tab
    ));
  }


  void _onUpdateExpenses(UpdateExpenses event, Emitter<TripDetailsState> emit) async {    
    emit(TripDetailsLoading(state.activeTripTab, state.activeActivityTab, state.activeExpenseTab, trip: state.trip, familyMembers: state.familyMembers));
    try{
      var expenses = await _expensesRepository.getTripExpenses(event.tripId);

      Trip trip = state.trip!.copyWith(expenses: expenses);

      emit(TripDetailsSuccessState(     
        trip,
        state.familyMembers!,
        state.activeTripTab,
        state.activeActivityTab,
        state.activeExpenseTab
      ));
    } on CustomException catch(e){
      emit(TripDetailsErrorState(e.toString(), state.activeTripTab, state.activeActivityTab, state.activeExpenseTab));
    } on Exception catch (e){
      emit(TripDetailsErrorState(e.toString(), state.activeTripTab, state.activeActivityTab, state.activeExpenseTab));
    }
  }

  void _onUpdateActivities(UpdateActivities event, Emitter<TripDetailsState> emit) async {    
    emit(TripDetailsLoading(state.activeTripTab, state.activeActivityTab, state.activeExpenseTab, trip: state.trip, familyMembers: state.familyMembers));
    try{
      var activities = await _activitiesRepository.getTripActivities(event.tripId);
      var expenses = await _expensesRepository.getTripExpenses(event.tripId);

      if(event.tab != null && event.tabKey != null){
        await sharedPrefsService.writeInt(key: event.tabKey!, value: event.tab!);
      }

      Trip trip = state.trip!.copyWith(expenses: expenses, activities: activities);

      emit(TripDetailsSuccessState(     
        trip,
        state.familyMembers!,
        state.activeTripTab,
        event.tab ?? state.activeActivityTab,
        state.activeExpenseTab
      ));
    } on CustomException catch(e){
      emit(TripDetailsErrorState(e.toString(), state.activeTripTab, event.tab ?? state.activeActivityTab));
    } on Exception catch (e){
      emit(TripDetailsErrorState(e.toString(), state.activeTripTab, event.tab ?? state.activeActivityTab));
    }
  }

  void _onUpdateBookings(UpdateBookings event, Emitter<TripDetailsState> emit) async {    
    emit(TripDetailsLoading(state.activeTripTab, state.activeActivityTab, state.activeExpenseTab, trip: state.trip, familyMembers: state.familyMembers));
    try{
      var bookings = await _bookingsRepository.getTripBookings(event.tripId);
      var expenses = await _expensesRepository.getTripExpenses(event.tripId);

      Trip trip = state.trip!.copyWith(expenses: expenses, bookings: bookings);

      emit(TripDetailsSuccessState(     
        trip,
        state.familyMembers!,
        state.activeTripTab,
        state.activeActivityTab,
        state.activeExpenseTab
      ));
    } on CustomException catch(e){
      emit(TripDetailsErrorState(e.toString(), state.activeTripTab, state.activeActivityTab, state.activeExpenseTab));
    } on Exception catch (e){
      emit(TripDetailsErrorState(e.toString(), state.activeTripTab, state.activeActivityTab, state.activeExpenseTab));
    }
  }

  void _onUpdateTickets(UpdateTickets event, Emitter<TripDetailsState> emit) async {    
    emit(TripDetailsLoading(state.activeTripTab, state.activeActivityTab, state.activeExpenseTab, trip: state.trip, familyMembers: state.familyMembers));
    try{
      var tickets = await _ticketsRepository.getTripTickets(event.tripId);
      var expenses = await _expensesRepository.getTripExpenses(event.tripId);

      Trip trip = state.trip!.copyWith(expenses: expenses, tickets: tickets);

      emit(TripDetailsSuccessState(     
        trip,
        state.familyMembers!,
        state.activeTripTab,
        state.activeActivityTab,
        state.activeExpenseTab
      ));
    } on CustomException catch(e){
      emit(TripDetailsErrorState(e.toString(), state.activeTripTab, state.activeActivityTab, state.activeExpenseTab));
    } on Exception catch (e){
      emit(TripDetailsErrorState(e.toString(), state.activeTripTab, state.activeActivityTab, state.activeExpenseTab));
    }
  }

  void _onUpdateNotes(UpdateNotes event, Emitter<TripDetailsState> emit) async {    
    emit(TripDetailsLoading(state.activeTripTab, state.activeActivityTab, state.activeExpenseTab, trip: state.trip, familyMembers: state.familyMembers));
    try{
      var notes = await _notesRepository.getTripNotes(event.tripId);
      
      Trip trip = state.trip!.copyWith(notes: notes);

      emit(TripDetailsSuccessState(     
        trip,
        state.familyMembers!,
        state.activeTripTab,
        state.activeActivityTab,
        state.activeExpenseTab
      ));
    } on CustomException catch(e){
      emit(TripDetailsErrorState(e.toString(), state.activeTripTab, state.activeActivityTab, state.activeExpenseTab));
    } on Exception catch (e){
      emit(TripDetailsErrorState(e.toString(), state.activeTripTab, state.activeActivityTab, state.activeExpenseTab));
    }
  }

  void _onGetImage(GetImage event, Emitter<TripDetailsState> emit) async {
    try{
      var image = state.trip?.coverImage;
      Trip updTrip = state.trip!;

      if(event.image != null){
        var imageBytes = await event.image!.readAsBytes();       
        var imageName = event.image!.path; 
        updTrip = await _tripsRepository.updateTripImage(imageBytes, updTrip.id!, imageName);
      }      

      emit(TripDetailsSuccessState(     
        updTrip,
        state.familyMembers!,
        state.activeTripTab,
        state.activeActivityTab,
        state.activeExpenseTab
      ));
    }on CustomException catch(e){
      emit(TripDetailsErrorState(e.toString(), state.activeTripTab, state.activeActivityTab,state.activeExpenseTab));
    } on Exception catch (e){
      emit(TripDetailsErrorState(e.toString(), state.activeTripTab, state.activeActivityTab, state.activeExpenseTab));
    }    
  }

}
