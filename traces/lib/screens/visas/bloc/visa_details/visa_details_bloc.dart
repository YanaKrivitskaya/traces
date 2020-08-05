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
    }else if(event is SaveVisaClicked){
      yield* _mapSaveVisaClickedToState(event.visa);
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

    if(members.length == 0){
      members.add(userProfile.displayName);
    }

    yield VisaDetailsState.success(visa: null, settings: settings, userCountries: userCountries, members: members);
  }

  Stream<VisaDetailsState> _mapSaveVisaClickedToState(Visa visa) async*{
    yield state.copyWith(isLoading: true);

    if(visa.endDate.difference(visa.startDate).inDays < 1){
      yield VisaDetailsState.failure(
          visa: visa,
          settings: state.settings,
          userCountries: state.userCountries,
          members: state.familyMembers,
          error: "End date should be greater than Start date");
    }

    visa = await _visasRepository.addNewVisa(visa).timeout(Duration(seconds: 3), onTimeout: (){
      print("have timeout");
      return visa;
    });

    UserCountries userCountries = await _visasRepository.userCountries();

    if(userCountries.countries.where((c) => c == visa.countryOfIssue).length == 0){
      userCountries.countries.add(visa.countryOfIssue);
      await _visasRepository.updateUserCountries(userCountries.countries).timeout(Duration(seconds: 3), onTimeout: (){
        print("have timeout");
        return null;
      });
    }

    yield VisaDetailsState.success(visa: visa, settings: state.settings, userCountries: state.userCountries, members: state.familyMembers);
  }
}
