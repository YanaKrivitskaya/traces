import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:traces/screens/notes/note.dart';
import 'package:traces/screens/notes/tags/tag.dart';

@immutable
abstract class TagState extends Equatable{
  final List<Tag> tags;
  final List<Tag> filteredTags;

  const TagState(this.tags, this.filteredTags);

  @override
  List<Object> get props => null;
}

class TagsEmpty extends TagState{
  TagsEmpty() : super(null, null);
}

class TagsLoadInProgress extends TagState{
  final List<Tag> tags;
  TagsLoadInProgress(this.tags) : super(tags, null);
}

class TagsLoadSuccess extends TagState {
  final List<Tag> tags;
  final List<Tag> filteredTags;
  final bool noTags;

  const TagsLoadSuccess(this.tags, this.noTags, this.filteredTags) : super(tags, filteredTags);

  @override
  List<Object> get props => [tags, noTags, filteredTags];
}

class InitialTagState extends TagState {
  InitialTagState() : super(null, null);
}
