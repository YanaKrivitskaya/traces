import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:traces/screens/profile/repository/profile_repository.dart';
import 'package:traces/screens/visas/model/settings.dart';
import 'package:traces/screens/visas/model/user_countries.dart';
import 'package:traces/screens/visas/model/visa.dart';
import 'package:traces/screens/visas/repository/visas_repository.dart';

part 'visa_details_event.dart';

part 'visa_details_state.dart';

class VisaDetailsBloc extends Bloc<VisaDetailsEvent, VisaDetailsState> {
  final VisasRepository _visasRepository;
  final ProfileRepository _profileRepository;
  StreamSubscription _visasSubscription;

  VisaDetailsBloc({@required VisasRepository visasRepository, @required ProfileRepository profileRepository})
      : assert(visasRepository != null),
        _visasRepository = visasRepository,
        _profileRepository = profileRepository;


  @override
  VisaDetailsState get initialState => VisaDetailsState.empty();

  @override
  Stream<VisaDetailsState> mapEventToState(VisaDetailsEvent event) async* {
    if(event is GetVisaDetails){
      yield* _mapGetVisaDetailsToState(event);
    }else if(event is NewVisaMode){
      yield* _mapNewVisaModeToState(event);
    }
  }

  Stream<VisaDetailsState> _mapGetVisaDetailsToState(GetVisaDetails event) async*{
    Visa visa = await _visasRepository.getVisaById(event.visaId);

    yield VisaDetailsState.loading();

    UserCountries userCountries = await _visasRepository.userCountries();

    Settings settings = await _visasRepository.settings();

    yield VisaDetailsState.success(visa: visa, settings: settings, userCountries: userCountries);
  }

  Stream<VisaDetailsState> _mapNewVisaModeToState(NewVisaMode event) async*{
    yield VisaDetailsState.loading();

    UserCountries userCountries = await _visasRepository.userCountries();
    Settings settings = await _visasRepository.settings();
    var userProfile = await _profileRepository.getCurrentProfile();
    List<String> members = userProfile.familyMembers;

    yield VisaDetailsState.success(visa: null, settings: settings, userCountries: userCountries, members: members);
  }
}
