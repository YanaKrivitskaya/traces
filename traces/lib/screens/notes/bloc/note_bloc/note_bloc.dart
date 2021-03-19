import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:traces/screens/notes/bloc/note_bloc/bloc.dart';
import 'package:traces/screens/notes/model/note.dart';
import 'package:traces/screens/notes/model/tag.dart';
import 'package:traces/screens/notes/repository/note_repository.dart';
import 'package:meta/meta.dart';
import 'package:traces/shared/state_types.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final NoteRepository _notesRepository;
  StreamSubscription _notesSubscription;

  NoteBloc({@required NoteRepository notesRepository})
      : assert(notesRepository != null),
        _notesRepository = notesRepository, super(NoteState.empty());

  @override
  Stream<NoteState> mapEventToState(
    NoteEvent event,
  ) async* {
    if (event is GetAllNotes) {
      yield* _mapGetAllNotesToState();
    } else if (event is DeleteNote) {
      yield* _mapDeleteNoteToState(event);
    }else if (event is UpdateNotesList) {
      yield* _mapUpdateNotesListToState(event);
    }else if(event is UpdateSortFilter){
      yield* _mapNotesUpdateSortFilterToState(event);
    } else if(event is SelectedTagsUpdated){
      yield* _mapSelectedTagsUpdatedToState(event);
    } else if(event is SearchTextChanged){
      yield* _mapSearchTextChangedToState(event);
    } else if(event is SearchBarToggle){
      yield* _mapSearchBarToggleToState(event);
    }
  }

  Stream<NoteState> _mapUpdateNotesListToState(UpdateNotesList event) async* {
    List<Note> filteredNotes = <Note>[];
    filteredNotes.addAll(event.allNotes);
    yield NoteState.success(allNotes: event.allNotes, filteredNotes: filteredNotes,
        sortField: event.sortField, sortDirection: event.sortDirection, searchEnabled: false);
  }

  Stream<NoteState> _mapGetAllNotesToState() async* {
    _notesSubscription?.cancel();

    yield NoteState.loading();

    try{
      _notesSubscription = _notesRepository.notes().listen(
            (notes) => add(UpdateNotesList(notes, SortFields.DATEMODIFIED, SortDirections.ASC, notes)),
      );
    }catch(e){
      yield NoteState.failure(error: e.message);
    }

  }

  Stream<NoteState> _mapNotesUpdateSortFilterToState(UpdateSortFilter event) async*{
    yield NoteState.loading();
    yield state.update(sortField: event.sortField, sortDirection: event.sortDirection);
  }

  Stream<NoteState> _mapSearchBarToggleToState(SearchBarToggle event) async*{
    yield state.update(stateStatus: StateStatus.Loading);

    List<Note> filteredNotes = <Note>[];

    !state.searchEnabled ? filteredNotes.addAll(state.allNotes) :  filteredNotes.addAll(state.filteredNotes);

    yield state.update(stateStatus: StateStatus.Success, searchEnabled: !state.searchEnabled, filteredNotes: filteredNotes);
  }

  Stream<NoteState> _mapDeleteNoteToState(DeleteNote event) async* {

    List<String> noteTags = event.note.tagIds;

    try{
      _notesRepository.deleteNote(event.note);

      if(noteTags.isNotEmpty){
        noteTags.forEach((tagId) async {
          Tag tag = await _notesRepository.getTagById(tagId);
          Tag updatedTag = new Tag(tag.name, id: tag.id, usage: tag.usage -1);
          _notesRepository.updateTag(updatedTag);
        });
      }
    }catch(e){
      yield NoteState.failure(error: e.message);
    }
  }

  Stream<NoteState> _mapSelectedTagsUpdatedToState(SelectedTagsUpdated event) async* {
    yield state.update(stateStatus: StateStatus.Loading);
    yield state.update(stateStatus: StateStatus.Success);
  }

  Stream<NoteState> _mapSearchTextChangedToState(SearchTextChanged event) async*{
    yield state.update(stateStatus: StateStatus.Loading);

    List<Note> filteredNotes = <Note>[];

    event.noteName.length > 0
        ? filteredNotes = state.allNotes.where((n) => n.title.toLowerCase().contains(event.noteName.toLowerCase())).toList()
        : filteredNotes.addAll(state.allNotes);

    yield state.update(filteredNotes: filteredNotes, stateStatus: StateStatus.Success);
  }

  @override
  Future<void> close() {
    _notesSubscription?.cancel();
    return super.close();
  }
}
