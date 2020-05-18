import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:traces/screens/notes/repository/note_repository.dart';
import 'package:traces/screens/notes/tag.dart';
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
    else if (event is TagFilterChecked) {
      yield* _mapTagFilterCheckedToState(event);
    }
  }

  Stream<TagState> _mapGetTagsToState() async* {
    _notesSubscription?.cancel();

   _notesSubscription = _notesRepository.tags().listen(
          (tags) => add(UpdateTagsList(tags, true, state.tags ?? tags, state.selectedTags ?? tags)),
    );
  }

  Stream<TagState> _mapAddTagToState(AddTag event) async* {
    _notesRepository.addNewTag(event.tag);
  }

  Stream<TagState> _mapUpdateTagToState(UpdateTag event) async* {
    print(event.tag);
    _notesRepository.updateTag(event.tag);
  }

  // used from tag filtering alert an in add filter window
  Stream<TagState> _mapUpdateTagCheckedToState(UpdateTagChecked event) async* {

    yield TagsLoadInProgress(state.tags, state.selectedTags);

    final currentState = state;
    if(currentState is TagsLoadSuccess){
      List<Tag> tags = currentState.tags;
      tags.firstWhere((t) => t.id == event.tag.id).isChecked = event.tag.isChecked;

      add(UpdateTagsList(tags, currentState.noTags, state.filteredTags, state.selectedTags));
    }
  }

  Stream<TagState> _mapTagFilterCheckedToState(TagFilterChecked event) async* {

    yield TagsLoadInProgress(state.tags, state.selectedTags);

    final currentState = state;
    if(currentState is TagsLoadSuccess){

      event.tag.isChecked ? state.selectedTags.add(event.tag) : state.selectedTags.remove(event.tag);

      add(UpdateTagsList(state.tags, currentState.noTags, state.filteredTags, state.selectedTags));
    }
  }

  Stream<TagState> _mapAllTagsCheckedToState(AllTagsChecked event) async* {

    yield TagsLoadInProgress(state.tags, state.selectedTags);

    final currentState = state;
    if(currentState is TagsLoadSuccess){
      /*List<Tag> tags = currentState.tags;
      tags.forEach((t) => t.isChecked = event.checked);*/

      if(event.checked){
        add(UpdateTagsList(state.tags, event.checked, state.filteredTags, state.tags));
      }else{
        add(UpdateTagsList(state.tags, event.checked, state.filteredTags, null));
      }
    }
  }

  Stream<TagState> _mapNoTagsCheckedToState(NoTagsChecked event) async* {

    yield TagsLoadInProgress(state.tags, state.selectedTags);

    add(UpdateTagsList(state.tags, event.checked, state.filteredTags, state.selectedTags));
  }

  Stream<TagState> _mapDeleteTagToState(DeleteTag event) async* {
    _notesRepository.deleteTag(event.tag);
  }


  Stream<TagState> _mapTagChangedToState(TagChanged event) async*{

    yield TagsLoadInProgress(state.tags, state.selectedTags);

    List<Tag> filteredTags = state.tags.where((t) => t.name.toLowerCase().startsWith(event.tagName.toLowerCase())).toList();

    add(UpdateTagsList(state.tags, false, filteredTags, state.selectedTags));
  }

  Stream<TagState> _mapUpdateTagsListToState(UpdateTagsList event) async* {
    yield TagsLoadSuccess(event.tags, event.noTags, event.filteredTags, event.selectedTags ?? state.selectedTags);
  }

  @override
  Future<void> close() {
    _notesSubscription?.cancel();
    return super.close();
  }
}
