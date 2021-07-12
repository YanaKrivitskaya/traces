import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:traces/utils/api/customException.dart';

import '../../../../utils/misc/state_types.dart';
import '../../models/tag.model.dart';
import '../../repositories/api_notes_repository.dart';
import '../../repositories/api_tags_repository.dart';
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
    }
  }

  Stream<TagAddState> _mapGetTagsToState() async* {
    yield TagAddState.loading();
    try{
      var tags = await _tagsRepository.getTags();
      yield TagAddState.success(allTags: tags, filteredTags: tags);
    } on CustomException catch(e){
      yield TagAddState.failure(allTags: state.allTags, filteredTags: state.filteredTags, error: e);
    }    
  }

  Stream<TagAddState> _mapAddTagToState(AddTag event) async* {
    yield state.update(stateStatus: StateStatus.Loading);

    try{
      Tag tag = await _tagsRepository.createTag(event.tag);
      state.allTags!.add(tag);

      add(TagChanged(tagName: tag.name));    
    }on CustomException catch(e){
      yield TagAddState.failure(allTags: state.allTags, filteredTags: state.filteredTags, error: e);
    } 
    
  }

  Stream<TagAddState> _mapUpdateNoteTagToState(UpdateNoteTag event) async* {
    try{
      event.isChecked!      
      ? await _notesRepository.addNoteTag(event.noteId, event.tagId)
      : await _notesRepository.deleteNoteTag(event.noteId, event.tagId);
      yield TagAddState.success(allTags: state.allTags, filteredTags: state.filteredTags);
    }on CustomException catch(e){
      yield TagAddState.failure(allTags: state.allTags, filteredTags: state.filteredTags, error: e);
    } 
    
  }

  Stream<TagAddState> _mapTagChangedToState(TagChanged event) async*{
    yield state.update(stateStatus: StateStatus.Loading);

    List<Tag> filteredTags = state.allTags!.where((t) => t.name!.toLowerCase().contains(event.tagName!.toLowerCase())).toList();

    yield state.update(filteredTags: filteredTags, stateStatus: StateStatus.Success);
  }

}
