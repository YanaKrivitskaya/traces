import 'package:equatable/equatable.dart';
import 'package:traces/screens/notes/note.dart';
import 'package:traces/screens/notes/tag.dart';

abstract class NoteDetailsState extends Equatable {
  const NoteDetailsState();

  @override
  List<Object> get props => [];
}

class LoadingDetailsState extends NoteDetailsState {}

class ViewDetailsState extends NoteDetailsState {
  final Note note;
  final List<Tag> noteTags;

  const ViewDetailsState(this.note, this.noteTags);

  @override
  List<Object> get props => [note, noteTags];
}

class EditDetailsState extends NoteDetailsState {
  final Note note;

  const EditDetailsState(this.note);


  /*EditDetailsState copyWith({
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
  }*/

  @override
  List<Object> get props => [note];
}

class InitialNoteDetailsState extends NoteDetailsState {}
