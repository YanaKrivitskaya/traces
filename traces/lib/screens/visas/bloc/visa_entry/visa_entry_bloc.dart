import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../utils/api/customException.dart';
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
    super(VisaEntryState.empty()){
      on<GetEntryDetails>(_onGetEntryDetails);
      on<SubmitEntry>(_onSubmitEntry);
      on<EntryDateChanged>(_onEntryDateChanged);
      on<ExitDateChanged>(_onExitDateChanged);
      on<DeleteEntry>(_onDeleteEntry);
    } 

  void _onGetEntryDetails(GetEntryDetails event, Emitter<VisaEntryState> emit) async{
    emit(VisaEntryState.loading());

    VisaEntry? entry;

    if (event.entry == null)
      entry =
          new VisaEntry(
            visaId: event.visa!.id!,           
            entryDate: event.visa!.startDate!
          );
    else
      entry = event.entry;    

    emit(VisaEntryState.editing(
        visa: event.visa, entryExit: entry));
  } 

  void _onSubmitEntry(SubmitEntry event, Emitter<VisaEntryState> emit) async{
    var currentState = state;
    emit(VisaEntryState.loading());

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
    
      emit(VisaEntryState.success(visa: event.visa, entryExit: entry));
    }on CustomException catch(e){
      if(currentState.visaEntry != null){
        emit(VisaEntryState.success(visa: event.visa, entryExit: currentState.visaEntry));
        emit(state.update(error: e));
      }else 
      emit(VisaEntryState.failure(error: e));
    }    
  } 

  void _onDeleteEntry(DeleteEntry event, Emitter<VisaEntryState> emit) async{
    try{
       await _visasRepository.deleteVisaEntry(event.visa!.id!, event.entry!.id!);       
       emit(state.update(entryDeleted: true));
    }on CustomException catch(e){
      emit(state.update(error: e));
    }   
  } 

  void _onEntryDateChanged(EntryDateChanged event, Emitter<VisaEntryState> emit) async{
    state.visaEntry = state.visaEntry!.copyWith(entryDate: event.entryDate);

    emit(state.update(visaEntry: state.visaEntry));
  } 

  void _onExitDateChanged(ExitDateChanged event, Emitter<VisaEntryState> emit) async{
    state.visaEntry = state.visaEntry!.copyWith(exitDate: event.exitDate);

    emit(state.update(visaEntry: state.visaEntry));
  } 
}
