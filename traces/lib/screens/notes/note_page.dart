import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/constants.dart';
import 'package:traces/screens/notes/bloc/tag_filter_bloc/bloc.dart';
import 'package:traces/screens/notes/note_filter_button.dart';
import 'package:traces/screens/notes/notes_view.dart';
import 'package:traces/screens/notes/repository/firebase_notes_repository.dart';
import 'package:traces/colorsPalette.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traces/screens/notes/tags_filter_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'bloc/note_bloc/bloc.dart';

class NotesPage extends StatelessWidget{
  NotesPage();

  @override
  Widget build(BuildContext context) {
    
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: context.read<NoteBloc>()..add(GetAllNotes()),
        ),
        BlocProvider<TagFilterBloc>(
          create: (context) => TagFilterBloc(
              notesRepository: FirebaseNotesRepository()
          )..add(GetTags()),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: FaIcon(FontAwesomeIcons.chevronLeft),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('Notes', style: GoogleFonts.quicksand(textStyle: TextStyle(color: Colors.white, fontSize: 25.0))),
          backgroundColor: ColorsPalette.greenGrass,
          actions: [
            IconButton(
              icon: FaIcon(FontAwesomeIcons.search),
              onPressed: (){
                context.read<NoteBloc>().add(SearchBarToggle());
              },
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
          child: Icon(Icons.add, color: ColorsPalette.white),
        ),
      ),
    );
  }
}