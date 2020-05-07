import 'package:meta/meta.dart';
import 'package:traces/screens/notes/note.dart';

@immutable
class DetailsState {
  const DetailsState();

  @override
  List<Object> get props => [];
}

class InitialDetailsState extends DetailsState {}

class ViewDetailsState extends DetailsState {
  final Note note;

  const ViewDetailsState(this.note);

  @override
  List<Object> get props => [note];
}

class EditDetailsState extends DetailsState {
  final Note notetoEdit;
  const EditDetailsState(this.notetoEdit);
  @override
  List<Object> get props => [notetoEdit];
}

class AddNoteState extends DetailsState {
  final Note note;
  const AddNoteState(this.note);
  @override
  List<Object> get props => [note];
}

class LoadingDetailsState extends DetailsState {}
