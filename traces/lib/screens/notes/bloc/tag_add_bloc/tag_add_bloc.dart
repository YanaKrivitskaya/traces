import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:traces/screens/notes/repositories/mock_notes_repository.dart';
import 'package:traces/screens/notes/repositories/mock_tags_repository.dart';
import 'package:traces/screens/notes/repositories/notes_repository.dart';
import 'package:traces/screens/notes/repositories/tags_repository.dart';
import 'package:traces/utils/api/customException.dart';

import '../../../../utils/misc/state_types.dart';
import '../../models/tag.model.dart';
import '../../repositories/api_notes_repository.dart';
import '../../repositories/api_tags_repository.dart';
import 'bloc.dart';

class TagAddBloc extends Bloc<TagAddEvent, TagAddState> {
  final NotesRepository _notesRepository;
  final TagsRepository _tagsRepository;

  TagAddBloc()
      : _notesRepository = const String.fromEnvironment("mode") == "test" ? new MockNotesRepository() : new ApiNotesRepository(), 
        _tagsRepository = const String.fromEnvironment("mode") == "test" ? new MockTagsRepository() : new ApiTagsRepository(), 
        super(TagAddState.empty()){
          on<GetTags>(_onGetTags);
          on<AddTag>(_onAddTag);
          on<UpdateNoteTag>(_onUpdateNoteTag);
          on<TagChanged>(_onTagChanged);
        }

  void _onGetTags(GetTags event, Emitter<TagAddState> emit) async{
    emit(TagAddState.loading());
    try{
      var tags = await _tagsRepository.getTags();
      return emit(TagAddState.success(allTags: tags, filteredTags: tags));
    } on CustomException catch(e){
      return emit(TagAddState.failure(allTags: state.allTags, filteredTags: state.filteredTags, error: e));
    }  
  }

  void _onAddTag(AddTag event, Emitter<TagAddState> emit) async{
    emit(state.update(stateStatus: StateStatus.Loading));

    try{
      Tag tag = await _tagsRepository.createTag(event.tag);
      state.allTags!.add(tag);

      add(TagChanged(tagName: tag.name));    
    }on CustomException catch(e){
      return emit(TagAddState.failure(allTags: state.allTags, filteredTags: state.filteredTags, error: e));
    } 
  }

  void _onUpdateNoteTag(UpdateNoteTag event, Emitter<TagAddState> emit) async{
    try{
      event.isChecked!      
      ? await _notesRepository.addNoteTag(event.noteId, event.tagId)
      : await _notesRepository.deleteNoteTag(event.noteId, event.tagId);
      return emit(TagAddState.success(allTags: state.allTags, filteredTags: state.filteredTags));
    }on CustomException catch(e){
      return emit(TagAddState.failure(allTags: state.allTags, filteredTags: state.filteredTags, error: e));
    } 
  }

  void _onTagChanged(TagChanged event, Emitter<TagAddState> emit) async{
    emit(state.update(stateStatus: StateStatus.Loading));

    List<Tag> filteredTags = state.allTags!.where((t) => t.name!.toLowerCase().contains(event.tagName!.toLowerCase())).toList();

    return emit(state.update(filteredTags: filteredTags, stateStatus: StateStatus.Success));
  }
}
