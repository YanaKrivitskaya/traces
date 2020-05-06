import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:traces/screens/notes/note.dart';
import './bloc.dart';
import 'package:meta/meta.dart';
import '../repo/note_repository.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NoteRepository _notesRepository;
  StreamSubscription _notesSubscription;

  NotesBloc({@required NoteRepository notesRepository})
      : assert(notesRepository != null),
        _notesRepository = notesRepository;

  @override
  NotesState get initialState => NotesEmpty();

  @override
  Stream<NotesState> mapEventToState(
    NotesEvent event,
  ) async* {

    if (event is GetNotes) {
      yield* _mapGetNotesToState();
    } else if (event is AddNote) {
      yield* _mapAddNoteToState(event);
    } else if (event is UpdateNote) {
      yield* _mapUpdateNoteToState(event);
    } else if (event is DeleteNote) {
      yield* _mapDeleteNoteToState(event);
    } else if (event is UpdateNotesList) {
      yield* _mapUpdateNotesListToState(event);
    }else if(event is UpdateSortOrder){
      yield* _mapNotesUpdateSortOrderToState(event);
    }
  }

  Stream<NotesState> _mapGetNotesToState() async* {
    _notesSubscription?.cancel();

    _notesSubscription = _notesRepository.notes().listen(
          (notes) => add(UpdateNotesList(notes, SortFields.DATEMODIFIED, SortDirections.ASC)),
    );
  }

  Stream<NotesState> _mapAddNoteToState(AddNote event) async* {
    _notesRepository.addNewNote(event.note);
  }

  Stream<NotesState> _mapUpdateNoteToState(UpdateNote event) async* {
    _notesRepository.updateNote(event.note);
  }

  Stream<NotesState> _mapDeleteNoteToState(DeleteNote event) async* {
    _notesRepository.deleteNote(event.note);
  }

  Stream<NotesState> _mapNotesUpdateSortOrderToState(UpdateSortOrder event) async*{

    final currentState = state;
    if(currentState is NotesLoadSuccess){
      final notes = currentState.notes;

      yield NotesLoadInProgress();

      add(UpdateNotesList(notes, event.sortField, event.sortDirection));
    }
  }

  Stream<NotesState> _mapUpdateNotesListToState(UpdateNotesList event) async* {
    yield NotesLoadSuccess(event.sortField, event.sortDirection, event.notes);
  }

  @override
  Future<void> close() {
    _notesSubscription?.cancel();
    return super.close();
  }
}
