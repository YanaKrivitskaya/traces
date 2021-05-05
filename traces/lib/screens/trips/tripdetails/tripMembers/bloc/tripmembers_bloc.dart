import 'package:meta/meta.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:traces/screens/profile/repository/firebase_profile_repository.dart';
import 'package:traces/screens/profile/repository/profile_repository.dart';


part 'tripmembers_event.dart';
part 'tripmembers_state.dart';

class TripMembersBloc extends Bloc<TripMembersEvent, TripMembersState>{
  //final TripsRepository _tripsRepository;
  final ProfileRepository _profileRepository;

  TripMembersBloc(): 
  //_tripsRepository = new FirebaseTripsRepository(),
  _profileRepository = new FirebaseProfileRepository(),
  super(InitialTripMembersState());

  @override
  Stream<TripMembersState> mapEventToState(TripMembersEvent event) async* {
    if(event is GetMembers){
      yield* _mapGetTripMembersToState();
    }
    //throw UnimplementedError();
  }

  Stream<TripMembersState> _mapGetTripMembersToState() async*{
    /*var family = await _profileRepository.addNewProfile();    

    yield SuccessTripMembersState(family);*/
  }

}