import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:traces/screens/notes/repository/note_repository.dart';
import 'package:traces/screens/notes/tags/tag.dart';
import './bloc.dart';
import 'package:meta/meta.dart';

class TagBloc extends Bloc<TagEvent, TagState> {
  final NoteRepository _notesRepository;
  StreamSubscription _notesSubscription;

  TagBloc({@required NoteRepository notesRepository})
      : assert(notesRepository != null),
        _notesRepository = notesRepository;

  @override
  TagState get initialState => TagsEmpty();

  @override
  Stream<TagState> mapEventToState(
    TagEvent event,
  ) async* {
    if (event is GetTags) {
      yield* _mapGetTagsToState();
    } else if (event is AddTag) {
      yield* _mapAddTagToState(event);
    } else if (event is UpdateTag) {
      yield* _mapUpdateTagToState(event);
    } else if (event is DeleteTag) {
      yield* _mapDeleteTagToState(event);
    } else if (event is UpdateTagsList) {
      yield* _mapUpdateTagsListToState(event);
    }else if (event is UpdateTagChecked) {
      yield* _mapUpdateTagCheckedToState(event);
    }else if (event is AllTagsChecked) {
      yield* _mapAllTagsCheckedToState(event);
    }else if (event is NoTagsChecked) {
      yield* _mapNoTagsCheckedToState(event);
    }else if (event is TagChanged) {
      yield* _mapTagChangedToState(event);
    }
  }

  Stream<TagState> _mapGetTagsToState() async* {
    _notesSubscription?.cancel();

   _notesSubscription = _notesRepository.tags().listen(
          (tags) => add(UpdateTagsList(tags, true, state.tags ?? tags)),
    );
  }

  Stream<TagState> _mapAddTagToState(AddTag event) async* {
    _notesRepository.addNewTag(event.tag);
  }

  Stream<TagState> _mapUpdateTagToState(UpdateTag event) async* {
    _notesRepository.updateTag(event.tag);
  }

  Stream<TagState> _mapUpdateTagCheckedToState(UpdateTagChecked event) async* {

    yield TagsLoadInProgress(state.tags);

    final currentState = state;
    if(currentState is TagsLoadSuccess){
      List<Tag> tags = currentState.tags;
      tags.firstWhere((t) => t.id == event.tag.id).isChecked = event.tag.isChecked;

      add(UpdateTagsList(tags, currentState.noTags, state.filteredTags));
    }
  }

  Stream<TagState> _mapAllTagsCheckedToState(AllTagsChecked event) async* {

    yield TagsLoadInProgress(state.tags);

    final currentState = state;
    if(currentState is TagsLoadSuccess){
      List<Tag> tags = currentState.tags;
      tags.forEach((t) => t.isChecked = event.checked);

      add(UpdateTagsList(tags, event.checked, state.filteredTags));
    }
  }

  Stream<TagState> _mapNoTagsCheckedToState(NoTagsChecked event) async* {

    yield TagsLoadInProgress(state.tags);

    add(UpdateTagsList(state.tags, event.checked, state.filteredTags));
  }

  Stream<TagState> _mapDeleteTagToState(DeleteTag event) async* {
    _notesRepository.deleteTag(event.tag);
  }


  Stream<TagState> _mapTagChangedToState(TagChanged event) async*{

    yield TagsLoadInProgress(state.tags);

    List<Tag> filteredTags = state.tags.where((t) => t.name.toLowerCase().startsWith(event.tagName.toLowerCase())).toList();

    add(UpdateTagsList(state.tags, false, filteredTags));
  }

  Stream<TagState> _mapUpdateTagsListToState(UpdateTagsList event) async* {
    yield TagsLoadSuccess(event.tags, event.noTags, event.filteredTags);
  }

  @override
  Future<void> close() {
    _notesSubscription?.cancel();
    return super.close();
  }
}
