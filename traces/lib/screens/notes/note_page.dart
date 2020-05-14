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
import 'package:traces/screens/notes/tags/bloc/bloc.dart';
import 'package:traces/screens/notes/tags_filter_button.dart';

class NotesPage extends StatelessWidget{
  NotesPage();

  @override
  Widget build(BuildContext context) {
    
    return MultiBlocProvider(
      providers: [
        BlocProvider<NotesBloc>(
          create: (context) => NotesBloc(
              notesRepository: FirebaseNotesRepository()
          )..add(GetNotes()),
        ),
        BlocProvider<TagBloc>(
          create: (context) => TagBloc(
              notesRepository: FirebaseNotesRepository()
          )..add(GetTags()),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('All Notes', style: GoogleFonts.quicksand(textStyle: TextStyle(color: Colors.white, fontSize: 25.0))),
          //centerTitle: true,
          backgroundColor: ColorsPalette.greenGrass,
          actions: [
            IconButton(
                icon: Icon(Icons.search, color: Colors.white,)
            ),
            TagsFilterButton(),
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