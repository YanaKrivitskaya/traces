import 'package:equatable/equatable.dart';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:traces/screens/trips/model/trip.model.dart';
import 'package:traces/screens/trips/repository/api_trips_repository.dart';
import 'package:traces/utils/api/customException.dart';

import '../../../utils/services/shared_preferencies_service.dart';

part 'trips_event.dart';
part 'trips_state.dart';

class TripsBloc extends Bloc<TripsEvent, TripsState> {
  final ApiTripsRepository _tripsRepository;
  SharedPreferencesService sharedPrefsService = SharedPreferencesService();
 
  TripsBloc() 
  : _tripsRepository = new ApiTripsRepository(),
    super(TripsInitial(null, 0)){
      on<GetAllTrips>(_onGetAllTrips);
      on<UpdateTripsList>((event, emit) => emit(TripsSuccessState(event.trips, state.activeTab)));
      on<TabUpdated>(_onTabUpdated);
    }

  void _onGetAllTrips(GetAllTrips event, Emitter<TripsState> emit) async{
    emit(TripsLoadingState(state.allTrips, state.activeTab));
    try{
      var trips = await _tripsRepository.getTrips();
      emit(TripsSuccessState(trips, state.activeTab));
    } on CustomException catch(e){
      //yield T(error: e);
    }  
  }

  void _onTabUpdated(TabUpdated event, Emitter<TripsState> emit) async {
    await sharedPrefsService.writeInt(key: "tripTab", value: event.tab);
    emit(TripsSuccessState(     
      state.allTrips,      
      event.tab
    ));
  }
}
