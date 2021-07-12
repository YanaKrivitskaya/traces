import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:traces/utils/api/customException.dart';

import '../../../../utils/misc/state_types.dart';
import '../../models/tag.model.dart';
import '../../repositories/api_tags_repository.dart';
import 'bloc.dart';

class TagFilterBloc extends Bloc<TagFilterEvent, TagFilterState> {
  final ApiTagsRepository _tagsRepository;

  TagFilterBloc(): 
    _tagsRepository = new ApiTagsRepository(), 
    super(TagFilterState.empty());

  @override
  Stream<TagFilterState> mapEventToState(
    TagFilterEvent event,
  ) async* {
    if (event is GetTags) {
      yield* _mapGetTagsToState();
    }else if (event is AllTagsChecked) {
      yield* _mapAllTagsCheckedToState(event);
    }else if (event is NoTagsChecked) {
      yield* _mapNoTagsCheckedToState(event);
    }else if (event is TagChecked) {
      yield* _mapTagCheckedToState(event);
    }
  }


  Stream<TagFilterState> _mapGetTagsToState() async* {
    try{
      var tags = await _tagsRepository.getTags();

      List<Tag>? selectedTags = <Tag>[];
      bool allTagsChecked = !state.allTagsChecked! ? false : true;
      bool noTagsChecked = !state.noTagsChecked! ? false : true;
      bool allTagsUnChecked = !state.allUnChecked! ? false : true;

      if(state.selectedTags != null){
        selectedTags = state.selectedTags;
      }else{
        selectedTags = tags;
      }

      if(selectedTags!.isEmpty && !noTagsChecked && !allTagsUnChecked){
        selectedTags.addAll(tags!);
      }else{
        selectedTags.addAll(selectedTags);
      }

      yield TagFilterState.success(allTags: tags, selectedTags: selectedTags,
          allTagsChecked: allTagsChecked, noTagsChecked: noTagsChecked, allUnchecked: allTagsUnChecked);
    }on CustomException catch(e){
      yield TagFilterState.failure(allTags: state.allTags, selectedTags: state.selectedTags,
          allTagsChecked: state.allTagsChecked, noTagsChecked: state.noTagsChecked, allUnchecked: state.allUnChecked, error: e);
    }   
  }

  Stream<TagFilterState> _mapTagCheckedToState(TagChecked event) async* {
    yield state.update(stateStatus: StateStatus.Loading);
    bool? allChecked = state.allTagsChecked;
    bool? allUnChecked = state.allUnChecked;

    print(event.checked);

    if(event.checked!){
      state.selectedTags!.add(event.tag);
      state.selectedTags!.length == state.allTags!.length && state.noTagsChecked! ? allChecked = true : allChecked = false;
      allUnChecked = false;
    }else{
      state.selectedTags!.removeWhere((t) => t.id == event.tag.id);
      state.selectedTags!.length == 0 && !state.noTagsChecked! ? allUnChecked = true : allUnChecked = false;
      allChecked = false;
    }

    print(state.selectedTags!.length);
    yield state.update(stateStatus: StateStatus.Success, selectedTags: state.selectedTags, allTagsChecked: allChecked, allUnChecked: allUnChecked);
  }

  Stream<TagFilterState> _mapAllTagsCheckedToState(AllTagsChecked event) async* {
    yield state.update(stateStatus: StateStatus.Loading);

    List<Tag> selectedTags = <Tag>[];

    if(event.checked!) {
      selectedTags.addAll(state.allTags!);
      yield state.update(stateStatus: StateStatus.Success, allTagsChecked: true, allUnChecked: false, selectedTags: selectedTags, noTagsChecked: true);
    }else {
      yield state.update(stateStatus: StateStatus.Success, allTagsChecked: false, allUnChecked: true, selectedTags: selectedTags, noTagsChecked: false);
    }
  }

  Stream<TagFilterState> _mapNoTagsCheckedToState(NoTagsChecked event) async* {
    yield state.update(stateStatus: StateStatus.Loading);

    bool? allChecked = state.allTagsChecked;

    event.checked! && state.allTags!.length == state.selectedTags!.length ? allChecked = true : allChecked = false;

    yield state.update(stateStatus: StateStatus.Success, noTagsChecked: event.checked, allTagsChecked: allChecked, allUnChecked: false);
  }
}
