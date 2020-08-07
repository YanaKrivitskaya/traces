import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'entry_exit_event.dart';

part 'entry_exit_state.dart';

class EntryExitBloc extends Bloc<EntryExitEvent, EntryExitState> {
  EntryExitBloc(EntryExitState initialState) : super(initialState);

  @override
  EntryExitState get initialState => InitialEntryExitState();

  @override
  Stream<EntryExitState> mapEventToState(EntryExitEvent event) async* {
    // TODO: Add your event logic
  }
}
