import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:traces/utils/api/customException.dart';

import '../../../../utils/misc/state_types.dart';
import '../../model/visa.model.dart';
import '../../model/visa_entry.model.dart';
import '../../repository/api_visas_repository.dart';

part 'visa_entry_event.dart';
part 'visa_entry_state.dart';

class VisaEntryBloc extends Bloc<VisaEntryEvent, VisaEntryState> {
  final ApiVisasRepository _visasRepository;

  VisaEntryBloc():
    _visasRepository = new ApiVisasRepository(),
    super(VisaEntryState.empty());

  @override
  Stream<VisaEntryState> mapEventToState(VisaEntryEvent event) async* {
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

  Stream<VisaEntryState> _mapGetEntryDetailsToState(
      GetEntryDetails event) async* {
    yield VisaEntryState.loading();

    VisaEntry? entry;

    if (event.entry == null)
      entry =
          new VisaEntry(
            visaId: event.visa!.id!,           
            entryDate: event.visa!.startDate!
          );
    else
      entry = event.entry;    

    yield VisaEntryState.editing(
        visa: event.visa, entryExit: entry);
  }

  Stream<VisaEntryState> _mapSubmitEntryToState(SubmitEntry event) async* {
    var currentState = state;
    yield VisaEntryState.loading();

    try{
      VisaEntry entry;

      if (event.entry!.id == null) {
        entry = await _visasRepository.createVisaEntry(event.visa!.id!, event.entry!);
      } else {
        if ((event.entry!.exitCity?.isNotEmpty ?? true) &&
            (event.entry!.exitCountry?.isNotEmpty ?? true) &&
            (event.entry!.exitTransport?.isNotEmpty ?? true) ) {
          event.entry = event.entry!.copyWith(hasExit: true);
        }
        entry =
            await _visasRepository.updateVisaEntry(event.visa!.id!, event.entry!);
      }
    
      yield VisaEntryState.success(visa: event.visa, entryExit: entry);
    }on CustomException catch(e){
      if(currentState.visaEntry != null){
        yield VisaEntryState.success(visa: event.visa, entryExit: currentState.visaEntry);
        yield state.update(error: e);
      }else 
      yield VisaEntryState.failure(error: e);
    }    
  }

  Stream<VisaEntryState> _mapDeleteEntryToState(DeleteEntry event) async* {
    try{
       await _visasRepository.deleteVisaEntry(event.visa!.id!, event.entry!.id!);       
       yield state.update(entryDeleted: true);
    }on CustomException catch(e){
      yield state.update(error: e);
    }   
  }

  Stream<VisaEntryState> _mapEntryDateChangedToState(
      EntryDateChanged event) async* {    
    state.visaEntry = state.visaEntry!.copyWith(entryDate: event.entryDate);

    yield state.update(visaEntry: state.visaEntry);
  }

  Stream<VisaEntryState> _mapExitDateChangedToState(
      ExitDateChanged event) async* {
    state.visaEntry = state.visaEntry!.copyWith(exitDate: event.exitDate);

    yield state.update(visaEntry: state.visaEntry);
  }
}
