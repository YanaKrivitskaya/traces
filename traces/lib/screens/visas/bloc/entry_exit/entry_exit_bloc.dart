import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:traces/screens/visas/model/entryExit.dart';
import 'package:traces/screens/visas/model/settings.dart';
import 'package:traces/screens/visas/model/visa.dart';
import 'package:traces/screens/visas/repository/visas_repository.dart';
import 'package:traces/shared/validator.dart';

part 'entry_exit_event.dart';

part 'entry_exit_state.dart';

class EntryExitBloc extends Bloc<EntryExitEvent, EntryExitState> {
  final VisasRepository _visasRepository;

  EntryExitBloc({@required VisasRepository visasRepository})
      :
        assert(visasRepository != null),
        _visasRepository = visasRepository, super(InitialEntryExitState());

  @override
  EntryExitState get initialState => InitialEntryExitState();

  @override
  Stream<EntryExitState> mapEventToState(EntryExitEvent event) async* {
    if(event is GetEntryDetails){
      yield* _mapGetEntryDetailsToState(event);
    }else if(event is CountryChanged){
      yield* _mapGetEntryDetailsToState(event.country);
    }else if(event is CityChanged){
      yield* _mapGetEntryDetailsToState(event.city);
    }
  }

  Stream<EntryExitState> _mapGetEntryDetailsToState(GetEntryDetails event) async*{
    yield LoadingEntryDetailsState();

    EntryExit entry;

    if(event.entry == null) entry = new EntryExit(entryDate: DateTime.now());
    else entry = event.entry;

    VisaSettings settings = await _visasRepository.settings();

    yield EditDetailsState(visa: event.visa, entry: entry, settings: settings, isCityValid: true, isCountryValid: true);
  }

  Stream<EntryExitState> _mapCountryChangedToState(String value) async*{
    bool isValid = Validator.isValidString(value)
    /*yield state.update(
        isUsernameValid: Validator.isValidUsername(username),
        mode: StateMode.Edit
    );*/
    yield EditDetailsState(visa: state.visa, entry: entry, settings: settings, isCityValid: true, isCountryValid: true);
  }

  Stream<EntryExitState> _mapCityChangedToState(String value) async*{

  }
}
