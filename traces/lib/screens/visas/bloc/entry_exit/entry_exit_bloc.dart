import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:traces/screens/visas/model/entryExit.dart';
import 'package:traces/screens/visas/model/settings.dart';
import 'package:traces/screens/visas/model/visa.dart';
import 'package:traces/screens/visas/repository/visas_repository.dart';
import 'package:traces/shared/state_types.dart';
import 'package:traces/shared/validator.dart';

part 'entry_exit_event.dart';
part 'entry_exit_state.dart';

class EntryExitBloc extends Bloc<EntryExitEvent, EntryExitState> {
  final VisasRepository _visasRepository;

  EntryExitBloc({@required VisasRepository visasRepository})
      : assert(visasRepository != null),
        _visasRepository = visasRepository,
        super(EntryExitState.empty());

  @override
  EntryExitState get initialState => EntryExitState.empty();

  @override
  Stream<EntryExitState> mapEventToState(EntryExitEvent event) async* {
    if (event is GetEntryDetails) {
      yield* _mapGetEntryDetailsToState(event);
    } else if (event is SubmitEntry) {
      yield* _mapSubmitEntryToState(event);
    }
    else if(event is EntryDateChanged){
      yield* _mapEntryDateChangedToState(event);
    }else if(event is ExitDateChanged){
      yield* _mapExitDateChangedToState(event);
    }
  }

  Stream<EntryExitState> _mapGetEntryDetailsToState(
      GetEntryDetails event) async* {
    yield EntryExitState.loading();

    EntryExit entry;

    if (event.entry == null)
      entry =
          new EntryExit(entryDate: DateTime.now(), exitDate: DateTime.now());
    else
      entry = event.entry;

    VisaSettings settings = await _visasRepository.settings();

    yield EntryExitState.editing(
        visa: event.visa,
        entryExit: entry,
        settings: settings,
        /*isEntryEdit: event.isEntryEdit,
        isExitEdit: event.isExitEdit*/);
  }

  Stream<EntryExitState> _mapSubmitEntryToState(SubmitEntry event) async* {
    yield EntryExitState.loading();

    EntryExit entry;

    if (event.entry.id == null) {
      entry = await _visasRepository.addEntryExit(event.entry, event.visa.id);
    } else {
      if(event.entry.exitCity != null && event.entry.exitCountry != null 
        && event.entry.exitTransport != null){
        event.entry.hasExit = true;
      }
      entry = await _visasRepository.updateEntryExit(event.entry, event.visa.id);
    }

     yield EntryExitState.success(
        visa: event.visa,
        entryExit: entry
        //settings: settings,
        /*isEntryEdit: event.isEntryEdit,
        isExitEdit: event.isExitEdit*/);    
  }

  /*Stream<EntryExitState> _mapCountryChangedToState(String value) async*{
    bool isValid = Validator.isValidString(value);
    /*yield state.update(
        isUsernameValid: Validator.isValidUsername(username),
        mode: StateMode.Edit
    );*/
    //yield EditDetailsState(visa: state.visa, entry: entry, settings: settings, isCityValid: true, isCountryValid: true);
  }*/

  Stream<EntryExitState> _mapEntryDateChangedToState(EntryDateChanged event) async*{
    EntryExit entry = state.entryExit;
    entry.entryDate = event.entryDate;

    yield state.update(entryExit: entry);
  }

  Stream<EntryExitState> _mapExitDateChangedToState(ExitDateChanged event) async*{
    EntryExit entry = state.entryExit;
    entry.exitDate = event.exitDate;

    yield state.update(entryExit: entry);
  }
}
