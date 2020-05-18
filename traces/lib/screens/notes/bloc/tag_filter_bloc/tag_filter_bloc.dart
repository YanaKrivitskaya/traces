import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:traces/screens/notes/repository/note_repository.dart';
import 'package:traces/screens/notes/tag.dart';
import './bloc.dart';
import 'package:meta/meta.dart';

class TagFilterBloc extends Bloc<TagFilterEvent, TagFilterState> {
  final NoteRepository _notesRepository;
  StreamSubscription _notesSubscription;

  TagFilterBloc({@required NoteRepository notesRepository})
      : assert(notesRepository != null),
        _notesRepository = notesRepository;

  @override
  TagFilterState get initialState => TagFilterState.empty();

  @override
  Stream<TagFilterState> mapEventToState(
    TagFilterEvent event,
  ) async* {
    if (event is GetTags) {
      yield* _mapGetTagsToState();
    }else if (event is UpdateTagsList) {
      yield* _mapUpdateTagsListToState(event);
    }else if (event is AllTagsChecked) {
      yield* _mapAllTagsCheckedToState(event);
    }else if (event is NoTagsChecked) {
      yield* _mapNoTagsCheckedToState(event);
    }else if (event is TagChecked) {
      yield* _mapTagCheckedToState(event);
    }
  }

  Stream<TagFilterState> _mapUpdateTagsListToState(UpdateTagsList event) async* {
    List<Tag> selectedTags= new List<Tag>();
    selectedTags.addAll(event.allTags);
    yield TagFilterState.success(allTags: event.allTags, selectedTags: selectedTags, allTagsChecked: true, noTagsChecked: true, allUnchecked: false);
  }

  Stream<TagFilterState> _mapGetTagsToState() async* {
    _notesSubscription?.cancel();

    yield TagFilterState.loading();

    _notesSubscription = _notesRepository.tags().listen(
          (tags) => add(UpdateTagsList(tags, tags, true, true)),
    );
  }

  Stream<TagFilterState> _mapTagCheckedToState(TagChecked event) async* {
    yield state.update(isLoading: true);
    bool allChecked = state.allTagsChecked;
    bool allUnChecked = state.allUnChecked;

    if(event.checked){
      state.selectedTags.add(event.tag);
      state.selectedTags.length == state.allTags.length && state.noTagsChecked ? allChecked = true : allChecked = false;
      allUnChecked = false;
    }else{
      state.selectedTags.remove(event.tag);
      state.selectedTags.length == 0 ? allUnChecked = true : allUnChecked = false;
      allChecked = false;
    }
    yield state.update(isLoading: false, selectedTags: state.selectedTags, allTagsChecked: allChecked, allUnChecked: allUnChecked);
  }

  Stream<TagFilterState> _mapAllTagsCheckedToState(AllTagsChecked event) async* {
    yield state.update(isLoading: true);

    List<Tag> selectedTags = new List<Tag>();

    if(event.checked) {
      selectedTags.addAll(state.allTags);
      yield state.update(isLoading: false, allTagsChecked: true, allUnChecked: false, selectedTags: selectedTags);
    }else {
      yield state.update(isLoading: false, allTagsChecked: false, allUnChecked: true, selectedTags: selectedTags, noTagsChecked: false);
    }
  }

  Stream<TagFilterState> _mapNoTagsCheckedToState(NoTagsChecked event) async* {
    yield state.update(isLoading: true);
    bool allChecked = state.allTagsChecked;
    event.checked && state.allTags.length == state.selectedTags.length ? allChecked = true : allChecked = false;
    yield state.update(noTagsChecked: event.checked, allTagsChecked: allChecked);
  }
}
