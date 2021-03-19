import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../shared/state_types.dart';
import '../../model/entryExit.dart';
import '../../model/settings.dart';
import '../../model/user_countries.dart';
import '../../model/visa.dart';
import '../../repository/visas_repository.dart';

part 'entry_exit_event.dart';
part 'entry_exit_state.dart';

class EntryExitBloc extends Bloc<EntryExitEvent, EntryExitState> {
  final VisasRepository _visasRepository;

  EntryExitBloc({@required VisasRepository visasRepository})
      : assert(visasRepository != null),
        _visasRepository = visasRepository,
        super(EntryExitState.empty());

  @override
  Stream<EntryExitState> mapEventToState(EntryExitEvent event) async* {
    if (event is GetEntryDetails) {
      yield* _mapGetEntryDetailsToState(event);
    } else if (event is SubmitEntry) {
      yield* _mapSubmitEntryToState(event);
    } else if (event is EntryDateChanged) {
      yield* _mapEntryDateChangedToState(event);
    } else if (event is ExitDateChanged) {
      yield* _mapExitDateChangedToState(event);
    } else if (event is DeleteEntry) {
      yield* _mapDeleteEntryToState(event);
    }
  }

  Stream<EntryExitState> _mapGetEntryDetailsToState(
      GetEntryDetails event) async* {
    yield EntryExitState.loading();

    EntryExit entry;

    if (event.entry == null)
      entry =
          new EntryExit(entryDate: event.visa.startDate, exitDate: null);
    else
      entry = event.entry;

    VisaSettings settings = await _visasRepository.settings();
    UserSettings userSettings = await _visasRepository.userSettings();

    yield EntryExitState.editing(
        visa: event.visa, entryExit: entry, settings: settings, userSettings: userSettings);
  }

  Stream<EntryExitState> _mapSubmitEntryToState(SubmitEntry event) async* {
    yield EntryExitState.loading();

    EntryExit entry;

    if (event.entry.id == null) {
      entry = await _visasRepository.addEntryExit(event.entry, event.visa.id);
    } else {
      if (event.entry.exitCity != null &&
          event.entry.exitCity != '' &&
          event.entry.exitCountry != null &&
          event.entry.exitCountry != '' &&
          event.entry.exitTransport != null) {
        event.entry.hasExit = true;
      }
      entry =
          await _visasRepository.updateEntryExit(event.entry, event.visa.id);
    }
    List<String> countries = [entry.entryCountry, entry.exitCountry];
    List<String> cities = [entry.entryCity, entry.exitCity];

    await _visasRepository
          .updateUserSettings(countries, cities)
          .timeout(Duration(seconds: 3), onTimeout: () {
        print("have timeout");
        return null;
      });  

    yield EntryExitState.success(visa: event.visa, entryExit: entry);
  }

  Stream<EntryExitState> _mapDeleteEntryToState(DeleteEntry event) async* {
    await _visasRepository.deleteEntry(event.visa.id, event.entry.id)
      .timeout(Duration(seconds: 3), onTimeout: () {
        print("have timeout");
        return null;
      });
  }

  Stream<EntryExitState> _mapEntryDateChangedToState(
      EntryDateChanged event) async* {
    EntryExit entry = state.entryExit;
    entry.entryDate = event.entryDate;

    yield state.update(entryExit: entry);
  }

  Stream<EntryExitState> _mapExitDateChangedToState(
      ExitDateChanged event) async* {
    EntryExit entry = state.entryExit;
    entry.exitDate = event.exitDate;

    yield state.update(entryExit: entry);
  }
}
