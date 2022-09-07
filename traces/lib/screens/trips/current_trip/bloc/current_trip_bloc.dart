import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:traces/screens/trips/repository/api_trips_repository.dart';
import 'package:traces/utils/api/customException.dart';

import '../../model/trip.model.dart';

part 'current_trip_event.dart';
part 'current_trip_state.dart';

class CurrentTripBloc extends Bloc<CurrentTripEvent, CurrentTripState> {
  final ApiTripsRepository _tripsRepository;
  
  CurrentTripBloc() : _tripsRepository = new ApiTripsRepository(),
  super(CurrentTripInitial()) {
    on<GetCurrentTrip>((event, emit) async {
      emit(CurrentTripInitial());
    try{
      var trip = await _tripsRepository.getCurrentTrip();
      emit(CurrentTripSuccessState(trip));
    } on CustomException catch(e){
      //yield T(error: e);
    }
    });
  }
}
