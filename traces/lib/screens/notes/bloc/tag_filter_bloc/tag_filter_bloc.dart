import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:traces/screens/notes/repository/note_repository.dart';
import 'package:traces/screens/notes/model/tag.dart';
import 'package:traces/shared/state_types.dart';
import './bloc.dart';
import 'package:meta/meta.dart';

class TagFilterBloc extends Bloc<TagFilterEvent, TagFilterState> {
  final NoteRepository _notesRepository;
  StreamSubscription _notesSubscription;

  TagFilterBloc({@required NoteRepository notesRepository})
      : assert(notesRepository != null),
        _notesRepository = notesRepository, super(TagFilterState.empty());

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
    yield TagFilterState.loading();

    List<Tag> selectedTags= <Tag>[];
    if(event.selectedTags.isEmpty && !event.noTagsChecked && !event.allTagsUnChecked){
      selectedTags.addAll(event.allTags);
    }else{
      selectedTags.addAll(event.selectedTags);
    }

    yield TagFilterState.success(allTags: event.allTags, selectedTags: selectedTags,
        allTagsChecked: event.allTagsChecked, noTagsChecked: event.noTagsChecked, allUnchecked: event.allTagsUnChecked);
  }

  Stream<TagFilterState> _mapGetTagsToState() async* {
    _notesSubscription?.cancel();

    _notesSubscription = _notesRepository.tags().listen(
          (tags) {
            List<Tag> selectedTags = <Tag>[];
            bool allTagsChecked = !state.allTagsChecked ? false : true;
            bool noTagsChecked = !state.noTagsChecked ? false : true;
            bool allTagsUnChecked = !state.allUnChecked ? false : true;

            if(state.selectedTags != null){
              selectedTags = state.selectedTags;
            }
            add(UpdateTagsList(tags, selectedTags: selectedTags, allTagsChecked: allTagsChecked, noTagsChecked: noTagsChecked, allTagsUnChecked: allTagsUnChecked));
          }
    );
  }

  Stream<TagFilterState> _mapTagCheckedToState(TagChecked event) async* {
    yield state.update(stateStatus: StateStatus.Loading);
    bool allChecked = state.allTagsChecked;
    bool allUnChecked = state.allUnChecked;

    print(event.checked);

    if(event.checked){
      state.selectedTags.add(event.tag);
      state.selectedTags.length == state.allTags.length && state.noTagsChecked ? allChecked = true : allChecked = false;
      allUnChecked = false;
    }else{
      state.selectedTags.removeWhere((t) => t.id == event.tag.id);
      state.selectedTags.length == 0 && !state.noTagsChecked ? allUnChecked = true : allUnChecked = false;
      allChecked = false;
    }

    print(state.selectedTags.length);
    yield state.update(stateStatus: StateStatus.Success, selectedTags: state.selectedTags, allTagsChecked: allChecked, allUnChecked: allUnChecked);
  }

  Stream<TagFilterState> _mapAllTagsCheckedToState(AllTagsChecked event) async* {
    yield state.update(stateStatus: StateStatus.Loading);

    List<Tag> selectedTags = <Tag>[];

    if(event.checked) {
      selectedTags.addAll(state.allTags);
      yield state.update(stateStatus: StateStatus.Success, allTagsChecked: true, allUnChecked: false, selectedTags: selectedTags);
    }else {
      yield state.update(stateStatus: StateStatus.Success, allTagsChecked: false, allUnChecked: true, selectedTags: selectedTags, noTagsChecked: false);
    }
  }

  Stream<TagFilterState> _mapNoTagsCheckedToState(NoTagsChecked event) async* {
    yield state.update(stateStatus: StateStatus.Loading);

    bool allChecked = state.allTagsChecked;

    event.checked && state.allTags.length == state.selectedTags.length ? allChecked = true : allChecked = false;

    yield state.update(stateStatus: StateStatus.Success, noTagsChecked: event.checked, allTagsChecked: allChecked, allUnChecked: false);
  }
}
