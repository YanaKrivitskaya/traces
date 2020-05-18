import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:traces/screens/notes/note.dart';

@immutable
abstract class DetailsEvent extends Equatable{
  const DetailsEvent();
  @override
  List<Object> get props => [];
}

class GetNoteDetails extends DetailsEvent{
  final String noteId;

  GetNoteDetails(this.noteId);

  @override
  List<Object> get props => [noteId];
}

class NewNoteMode extends DetailsEvent{}

class EditMode extends DetailsEvent{
  final Note note;

  EditMode(this.note);

  @override
  List<Object> get props => [note];
}

class AddTagsClicked extends DetailsEvent{}

class SaveNote extends DetailsEvent{
  final Note note;

  SaveNote(this.note);

  @override
  List<Object> get props => [note];
}

