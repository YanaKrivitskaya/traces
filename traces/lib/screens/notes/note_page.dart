import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/color_constants.dart';
import '../../constants/route_constants.dart';
import 'bloc/note_bloc/bloc.dart';
import 'bloc/tag_filter_bloc/bloc.dart';
import 'note_filter_button.dart';
import 'notes_view.dart';
import 'tags_filter_button.dart';

class NotesPage extends StatelessWidget{
  NotesPage();

  @override
  Widget build(BuildContext context) {
    
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: context.read<NoteBloc>()/*..add(GetAllNotes())*/,
        ),
        BlocProvider<TagFilterBloc>(
          create: (context) => TagFilterBloc()..add(GetTags()),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: FaIcon(FontAwesomeIcons.chevronLeft, color: ColorsPalette.lynxWhite),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('Notes', style: GoogleFonts.quicksand(textStyle: TextStyle(color: Colors.white, fontSize: 25.0))),
          backgroundColor: ColorsPalette.greenGrass,
          actions: [
            IconButton(
              icon: FaIcon(FontAwesomeIcons.search, color: ColorsPalette.lynxWhite),
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
            Navigator.pushNamed(context, noteDetailsRoute, arguments: 0).then((value) 
              => context.read<NoteBloc>().add(GetAllNotes()));
          },
          tooltip: 'Add New Note',
          backgroundColor: ColorsPalette.nycTaxi,
          child: Icon(Icons.add, color: ColorsPalette.white),
        ),
      ),
    );
  }
}