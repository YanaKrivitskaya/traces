import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/screens/notes/notes_bloc/bloc.dart';
import 'package:traces/screens/notes/note-filter-button.dart';
import 'package:traces/screens/notes/noteRepository.dart';
import 'package:traces/screens/notes/notes-view.dart';
import 'package:traces/screens/notes/repo/firebase_notes_repository.dart';
import 'package:traces/colorsPalette.dart';
import 'package:google_fonts/google_fonts.dart';

class NotesPage extends StatelessWidget{
  NotesPage();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotesBloc>(
      create: (context) => NotesBloc(notesRepository: FirebaseNotesRepository()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Notes', style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.grayLight, fontSize: 40.0))),
          centerTitle: true,
          backgroundColor: ColorsPalette.greenGrass,
          actions: [
            NoteFilterButton()
          ],
        ),
        body:  NotesView()
      ),
    );
  }
}