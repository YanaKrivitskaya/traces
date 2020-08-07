import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:traces/screens/notes/repository/note_repository.dart';
import 'package:traces/screens/notes/model/tag.dart';
import './bloc.dart';
import 'package:meta/meta.dart';

class TagAddBloc extends Bloc<TagAddEvent, TagAddState> {
  final NoteRepository _notesRepository;
  StreamSubscription _notesSubscription;

  TagAddBloc({@required NoteRepository notesRepository})
      : assert(notesRepository != null),
        _notesRepository = notesRepository, super(null);

  @override
  TagAddState get initialState => TagAddState.empty();

  @override
  Stream<TagAddState> mapEventToState(
    TagAddEvent event,
  ) async* {
    if (event is GetTags) {
      yield* _mapGetTagsToState();
    } else if (event is AddTag) {
      yield* _mapAddTagToState(event);
    } else if (event is UpdateTag) {
      yield* _mapUpdateTagToState(event);
    } else if (event is TagChanged) {
      yield* _mapTagChangedToState(event);
    }else if (event is UpdateTagsList) {
      yield* _mapUpdateTagsListToState(event);
    }
  }

  Stream<TagAddState> _mapUpdateTagsListToState(UpdateTagsList event) async* {
    List<Tag> filteredTags = new List<Tag>();
    filteredTags.addAll(event.allTags);
    yield TagAddState.success(allTags: event.allTags, filteredTags: filteredTags);
  }

  Stream<TagAddState> _mapGetTagsToState() async* {
    _notesSubscription?.cancel();

    yield TagAddState.loading();

    _notesSubscription = _notesRepository.tags().listen(
          (tags) => add(UpdateTagsList(tags, tags)),
    );
  }

  Stream<TagAddState> _mapAddTagToState(AddTag event) async* {
    _notesRepository.addNewTag(event.tag);
  }

  Stream<TagAddState> _mapUpdateTagToState(UpdateTag event) async* {
    _notesRepository.updateTag(event.tag);
  }

  Stream<TagAddState> _mapTagChangedToState(TagChanged event) async*{
    yield state.update(isLoading: true);

    List<Tag> filteredTags = state.allTags.where((t) => t.name.toLowerCase().startsWith(event.tagName.toLowerCase())).toList();

    yield state.update(filteredTags: filteredTags, isLoading: false);
  }

}
