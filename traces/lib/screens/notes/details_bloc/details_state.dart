import 'package:meta/meta.dart';
import 'package:traces/screens/notes/note.dart';
import 'package:equatable/equatable.dart';
import 'package:traces/screens/notes/tags/tag.dart';

@immutable
abstract class DetailsState extends Equatable{
  final Note note;
  const DetailsState(this.note);

  @override
  List<Object> get props => [];
}

class InitialDetailsState extends DetailsState {
  InitialDetailsState(Note note) : super(note);
}

class ViewDetailsState extends DetailsState {
  final Note note;
  final List<Tag> noteTags;

  const ViewDetailsState(this.note, this.noteTags) : super(note);

  @override
  List<Object> get props => [note, noteTags];
}

class EditDetailsState extends DetailsState {
  final Note note;
  final List<Tag> selectedTags;

  const EditDetailsState(this.note, {List<Tag> selectedTags})
      : selectedTags = selectedTags ?? null, super(note);

  EditDetailsState copyWith({
    bool addingTagsMode,
    List<Tag> selectedTags
  }){
    return EditDetailsState(
        this.note,
        selectedTags: selectedTags ?? this.selectedTags
    );
  }

  EditDetailsState update({
    bool addingTagsMode,
    List<Tag> selectedTags
  }){
    return EditDetailsState(
        this.note,
        selectedTags: selectedTags
    );
  }

  @override
  List<Object> get props => [note, selectedTags];
}

/*class AddNoteState extends DetailsState {
  final Note note;
  const AddNoteState(this.note);

  @override
  List<Object> get props => [note];
}*/

class LoadingDetailsState extends DetailsState {
  LoadingDetailsState(Note note) : super(note);
}
