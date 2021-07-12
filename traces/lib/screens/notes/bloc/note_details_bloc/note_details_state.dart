import 'package:equatable/equatable.dart';
import 'package:traces/utils/api/customException.dart';

import '../../models/note.model.dart';


abstract class NoteDetailsState extends Equatable {
  final Note? note;

  const NoteDetailsState(this.note);

  @override
  List<Object?> get props => [];
}

class LoadingDetailsState extends NoteDetailsState {
  LoadingDetailsState(Note? note) : super(note);
}

class ViewDetailsState extends NoteDetailsState {
  final Note? note;
  final bool? noteDeleted;

  const ViewDetailsState(this.note, this.noteDeleted) : super(note);

  @override
  List<Object?> get props => [note, noteDeleted];
}

class EditDetailsState extends NoteDetailsState {
  final Note? note;

  const EditDetailsState(this.note) : super(note);

  @override
  List<Object?> get props => [note];
}

class InitialNoteDetailsState extends NoteDetailsState {
  InitialNoteDetailsState(Note? note) : super(note);
}

class ErrorDetailsState extends NoteDetailsState {
  final Note? note;
  final CustomException errorMessage;

  const ErrorDetailsState(this.note, this.errorMessage) : super(note);

  @override
  List<Object> get props => [errorMessage];
}
