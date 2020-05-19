import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:traces/screens/notes/bloc/note_bloc/bloc.dart';
import 'package:traces/screens/notes/model/note.dart';
import 'package:traces/screens/notes/model/tag.dart';
import 'package:traces/screens/notes/repository/note_repository.dart';

import 'package:meta/meta.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final NoteRepository _notesRepository;
  StreamSubscription _notesSubscription;

  NoteBloc({@required NoteRepository notesRepository})
      : assert(notesRepository != null),
        _notesRepository = notesRepository;

  @override
  NoteState get initialState => NotesEmpty();

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
    }
  }

  Stream<NoteState> _mapGetAllNotesToState() async* {
    _notesSubscription?.cancel();
    _notesSubscription = _notesRepository.notes().listen(
            (notes) =>
              add(UpdateNotesList(notes, SortFields.DATEMODIFIED, SortDirections.ASC))
    );
  }

  Stream<NoteState> _mapNotesUpdateSortFilterToState(UpdateSortFilter event) async*{

    final currentState = state;
    if(currentState is NotesLoadSuccess){
      final notes = currentState.notes;

      yield NotesLoadInProgress();

      add(UpdateNotesList(notes, event.sortField, event.sortDirection));
    }
  }

  Stream<NoteState> _mapDeleteNoteToState(DeleteNote event) async* {
    List<String> noteTags = event.note.tagIds;
    _notesRepository.deleteNote(event.note);

    if(noteTags.isNotEmpty){
      noteTags.forEach((tagId) async {
        Tag tag = await _notesRepository.getTagById(tagId);
        Tag updatedTag = new Tag(tag.name, id: tag.id, usage: tag.usage -1);
        _notesRepository.updateTag(updatedTag);
      });
    }
  }

  Stream<NoteState> _mapUpdateNotesListToState(UpdateNotesList event) async* {
    yield NotesLoadSuccess(event.sortField, event.sortDirection, event.notes);
  }

  Stream<NoteState> _mapSelectedTagsUpdatedToState(SelectedTagsUpdated event) async* {

    final currentState = state;
    if(currentState is NotesLoadSuccess){

      yield NotesLoadInProgress();

      add(UpdateNotesList(currentState.notes, currentState.sortField, currentState.sortDirection));
    }
  }

  @override
  Future<void> close() {
    _notesSubscription?.cancel();
    return super.close();
  }
}
