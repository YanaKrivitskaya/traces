import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:traces/screens/notes/tags/tag.dart';

@immutable
abstract class TagState extends Equatable{
  final List<Tag> tags;

  const TagState(this.tags);

  @override
  List<Object> get props => null;
}

class TagsEmpty extends TagState{
  TagsEmpty(List<Tag> tags) : super(tags);
}

class TagsLoadInProgress extends TagState{
  TagsLoadInProgress(List<Tag> tags) : super(tags);
}

class TagsLoadSuccess extends TagState {
  final List<Tag> tags;
  final bool noTags;

  const TagsLoadSuccess(this.tags, this.noTags) : super(tags);

  @override
  List<Object> get props => [tags, noTags];
}

class InitialTagState extends TagState {
  InitialTagState(List<Tag> tags) : super(tags);
}
