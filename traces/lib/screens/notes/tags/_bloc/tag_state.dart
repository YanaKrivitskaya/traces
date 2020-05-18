import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:traces/screens/notes/tag.dart';

@immutable
abstract class TagState extends Equatable{
  final List<Tag> tags;
  final List<Tag> filteredTags;
  final List<Tag> selectedTags;

  const TagState(this.tags, this.filteredTags, this.selectedTags);

  @override
  List<Object> get props => null;
}

class TagsEmpty extends TagState{
  TagsEmpty() : super(null, null, null);
}

class TagsLoadInProgress extends TagState{
  final List<Tag> tags;
  final List<Tag> selectedTags;
  TagsLoadInProgress(this.tags, this.selectedTags) : super(tags, null, selectedTags);
}

class TagsLoadSuccess extends TagState {
  final List<Tag> tags;
  final List<Tag> filteredTags;
  final bool noTags;
  final List<Tag> selectedTags;

  const TagsLoadSuccess(this.tags, this.noTags, this.filteredTags, this.selectedTags) : super(tags, filteredTags, selectedTags);

  @override
  List<Object> get props => [tags, noTags, filteredTags];
}

class InitialTagState extends TagState {
  InitialTagState() : super(null, null, null);
}
