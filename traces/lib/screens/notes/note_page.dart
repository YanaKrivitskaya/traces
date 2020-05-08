import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/constants.dart';
import 'package:traces/screens/notes/notes_bloc/bloc.dart';
import 'package:traces/screens/notes/note_filter_button.dart';
import 'package:traces/screens/notes/notes_view.dart';
import 'package:traces/screens/notes/repository/firebase_notes_repository.dart';
import 'package:traces/colorsPalette.dart';
import 'package:google_fonts/google_fonts.dart';

class NotesPage extends StatelessWidget{
  NotesPage();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotesBloc>(
      create: (context) => NotesBloc(
          notesRepository: FirebaseNotesRepository()
      )..add(GetNotes()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Notes', style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.grayLight, fontSize: 40.0))),
          centerTitle: true,
          backgroundColor: ColorsPalette.greenGrass,
          actions: [
            NoteFilterButton()
          ],
        ),
        body:  NotesView(),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.pushNamed(context, noteDetailsRoute, arguments: '');
          },
          tooltip: 'Add New Note',
          backgroundColor: ColorsPalette.nycTaxi,
          child: Icon(Icons.add, color: ColorsPalette.grayLight),
        ),
      ),
    );
  }
}