import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traces/utils/style/styles.dart';

import '../../../constants/color_constants.dart';
import '../../../constants/route_constants.dart';
import '../bloc/note_bloc/bloc.dart';
import '../bloc/tag_filter_bloc/bloc.dart';
import '../widgets/note_filter_button.dart';
import '../widgets/tags_filter_button.dart';
import 'notes_view.dart';

class NotesPage extends StatelessWidget{
  NotesPage();

  @override
  Widget build(BuildContext context) {
    
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: context.read<NoteBloc>(),
        ),
        BlocProvider.value(
          value: context.read<TagFilterBloc>(),
        )       
      ],
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: ColorsPalette.black),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          title: Text('Notes', style: quicksandStyle(fontSize: 30.0, color: ColorsPalette.black)),
          elevation: 0,
          backgroundColor: ColorsPalette.white,
          actions: [
            IconButton(
              padding: EdgeInsets.only(right: 10.0),
              constraints: BoxConstraints(),      
              icon: Icon(Icons.search, color: ColorsPalette.black),
              onPressed: (){
                context.read<NoteBloc>().add(SearchBarToggle());
              },
            ),
            TagsFilterButton(),
            NoteFilterButton()
          ],
        ),
        body:  NotesView(),        
        floatingActionButton:  FloatingActionButton.extended(
          onPressed: (){
            Navigator.pushNamed(context, noteDetailsRoute, arguments: 0).then((value) 
              => context.read<NoteBloc>().add(GetAllNotes()));
          },
          tooltip: 'Add New Note',
          backgroundColor: ColorsPalette.juicyYellow,
          label: Text("Create", style: quicksandStyle(color: ColorsPalette.white),),
          icon: Icon(Icons.add, color: ColorsPalette.white),
        ),
      ),
    );
  }
}