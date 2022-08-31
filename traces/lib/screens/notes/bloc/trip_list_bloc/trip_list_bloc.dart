import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:traces/screens/notes/models/note.model.dart';
import 'package:traces/screens/notes/repositories/api_notes_repository.dart';
import 'package:traces/screens/trips/model/trip.model.dart';
import 'package:traces/screens/trips/repository/api_trips_repository.dart';
import 'package:traces/utils/api/customException.dart';

part 'trip_list_event.dart';
part 'trip_list_state.dart';

class TripListBloc extends Bloc<TripListEvent, TripListState> {
  final ApiTripsRepository _tripsRepository;
  final ApiNotesRepository _notesRepository;

  TripListBloc() :
  _tripsRepository = new ApiTripsRepository(),
  _notesRepository = new ApiNotesRepository(),
  super(TripListInitial()) {
    on<GetTripsList>(_onGetTripsList);
    on<TripSubmitted>(_onAddTrip);
    on<TripUpdated>(_onTripUpdated);
  }

  void _onGetTripsList(GetTripsList event, Emitter<TripListState> emit) async{
    emit(TripListLoading(null, null, event.note.trip));

    var allTrips = List<Trip>.filled(1, new Trip(
      id: 0,
      name: "No Trip"
    ), growable: true);

    try{
      var trips = await _tripsRepository.getTripsList();

      var selectedTrip;
      if(trips != null){
        allTrips.addAll(trips);
        if(event.note.trip != null){
          selectedTrip = allTrips.firstWhere((t) => t.id == event.note.trip!.id);
        }
      }
      emit(TripListSuccess(allTrips, selectedTrip ?? null, state.currentTrip));
    }on CustomException catch(e){
      emit(TripListFailure(null, null, state.currentTrip, e.toString()));
    }
  }

  void _onTripUpdated(TripUpdated event, Emitter<TripListState> emit) async{
    emit(TripListSuccess(state.trips!, event.trip, state.currentTrip));
  }

  void _onAddTrip(TripSubmitted event, Emitter<TripListState> emit) async{
    emit(TripListLoading(state.trips, state.selectedTrip, state.currentTrip));

    try{
      if(state.selectedTrip != null){
        if(state.selectedTrip!.id! > 0){
          if(state.currentTrip == null || (state.currentTrip != null && state.currentTrip!.id! != state.selectedTrip!.id!)){
            await _notesRepository.addNoteTrip(event.noteId, event.tripId);
          }          
        }
        if(state.selectedTrip!.id! == 0 && state.currentTrip != null){
          await _notesRepository.deleteNoteTrip(event.noteId, state.currentTrip!.id!);
        }
      }      

      emit(TripListSubmitted(state.trips!, state.selectedTrip, state.currentTrip));
    }on CustomException catch(e){
      emit(TripListFailure(state.trips!, state.selectedTrip, state.currentTrip, e.toString()));
    } 
  }
}
