import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../shared/state_types.dart';
import '../../model/tag.model.dart';
import '../../repository/api_notes_repository.dart';
import '../../repository/api_tags_repository.dart';
import 'bloc.dart';

class TagAddBloc extends Bloc<TagAddEvent, TagAddState> {
  final ApiNotesRepository _notesRepository;
  final ApiTagsRepository _tagsRepository;

  TagAddBloc()
      : _notesRepository = new ApiNotesRepository(), 
        _tagsRepository = new ApiTagsRepository(), 
        super(TagAddState.empty());

  @override
  Stream<TagAddState> mapEventToState(
    TagAddEvent event,
  ) async* {
    if (event is GetTags) {
      yield* _mapGetTagsToState();
    } else if (event is AddTag) {
      yield* _mapAddTagToState(event);
    } else if (event is UpdateNoteTag) {
      yield* _mapUpdateNoteTagToState(event);
    } else if (event is TagChanged) {
      yield* _mapTagChangedToState(event);
    }else if (event is UpdateTagsList) {
      yield* _mapUpdateTagsListToState(event);
    }
  }

  Stream<TagAddState> _mapUpdateTagsListToState(UpdateTagsList event) async* {
    List<Tag> filteredTags = <Tag>[];
    filteredTags.addAll(event.allTags);
    yield TagAddState.success(allTags: event.allTags, filteredTags: filteredTags);
  }

  Stream<TagAddState> _mapGetTagsToState() async* {
    yield TagAddState.loading();

    var tags = await _tagsRepository.getTags();
    add(UpdateTagsList(tags, tags));
  }

  Stream<TagAddState> _mapAddTagToState(AddTag event) async* {
    yield state.update(stateStatus: StateStatus.Loading);

    Tag tag = await _tagsRepository.createTag(event.tag);
    state.allTags.add(tag);

    add(TagChanged(tagName: tag.name));    
  }

  Stream<TagAddState> _mapUpdateNoteTagToState(UpdateNoteTag event) async* {
    event.isChecked      
      ? await _notesRepository.addNoteTag(event.noteId, event.tagId)
      : await _notesRepository.deleteNoteTag(event.noteId, event.tagId);
    yield TagAddState.success(allTags: state.allTags, filteredTags: state.filteredTags);
  }

  Stream<TagAddState> _mapTagChangedToState(TagChanged event) async*{
    yield state.update(stateStatus: StateStatus.Loading);

    List<Tag> filteredTags = state.allTags.where((t) => t.name.toLowerCase().contains(event.tagName.toLowerCase())).toList();

    yield state.update(filteredTags: filteredTags, stateStatus: StateStatus.Success);
  }

}
