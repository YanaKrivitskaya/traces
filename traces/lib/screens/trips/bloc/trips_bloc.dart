import 'package:equatable/equatable.dart';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:traces/screens/trips/model/trip.model.dart';
import 'package:traces/screens/trips/repository/api_trips_repository.dart';
import 'package:traces/utils/api/customException.dart';

part 'trips_event.dart';
part 'trips_state.dart';

class TripsBloc extends Bloc<TripsEvent, TripsState> {
  final ApiTripsRepository _tripsRepository;
 
  TripsBloc() 
  : _tripsRepository = new ApiTripsRepository(),
    super(TripsInitial()){
      on<GetAllTrips>(_onGetAllTrips);
      on<UpdateTripsList>((event, emit) => emit(TripsSuccessState(event.trips)));
    }

  void _onGetAllTrips(GetAllTrips event, Emitter<TripsState> emit) async{
    emit(TripsLoadingState());
    try{
      var trips = await _tripsRepository.getTrips();
      emit(TripsSuccessState(trips));
    } on CustomException catch(e){
      //yield T(error: e);
    }  
  }
}
