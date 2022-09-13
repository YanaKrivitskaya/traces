import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:traces/screens/trips/model/trip_day.model.dart';
import 'package:traces/screens/trips/repository/api_trips_repository.dart';
import 'package:traces/utils/api/customException.dart';
import 'package:tuple/tuple.dart';

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
      Tuple2<Trip?, TripDay?> tupleResponse = await _tripsRepository.getCurrentTrip();
      emit(CurrentTripSuccessState(tupleResponse.item1, tupleResponse.item2));
    } on CustomException catch(e){
      //yield T(error: e);
      print(e);
    }
    });
  }
}
