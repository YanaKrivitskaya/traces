
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:traces/colorsPalette.dart';
import 'package:traces/constants.dart';
import 'package:traces/screens/notes/bloc/tag_filter_bloc/bloc.dart';
import 'package:traces/screens/notes/tag.dart';
import 'package:traces/screens/notes/note_delete_alert.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traces/screens/notes/note.dart';
import 'bloc/note_bloc/bloc.dart';

class NotesView extends StatefulWidget{
  NotesView();
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  TagFilterBloc _tagBloc;

  List<Tag> _tags;
  bool _allTagsSelected;
  bool _noTagsSelected;
  List<Tag> _selectedTags;

  @override
  void initState() {
    super.initState();

    _tagBloc = BlocProvider.of<TagFilterBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NoteBloc, NoteState>(
        listener: (context, state) {},
        child: BlocBuilder<NoteBloc, NoteState>(
            bloc: BlocProvider.of(context),
            builder: (context, state){
              if(state is NotesLoadInProgress || _tagBloc.state.isLoading || state is NotesEmpty){
                return Center(child: CircularProgressIndicator());
              }
              if(state is NotesLoadSuccess && _tagBloc.state.isSuccess){
                final notes = _sortNotes(state.notes, state.sortField);

                _tags = _tagBloc.state.allTags;
                _selectedTags = _tagBloc.state.selectedTags;
                _allTagsSelected = _tagBloc.state.allTagsChecked;
                _noTagsSelected = _tagBloc.state.noTagsChecked;

                final filteredNotes = _filterNotes(notes, _selectedTags, _allTagsSelected, _noTagsSelected);

                return Container(
                  padding: EdgeInsets.only(bottom: 65.0),
                  child: Container(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[filteredNotes != null && filteredNotes.length > 0 ?
                        Container(
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: filteredNotes.length,
                              reverse: state.sortDirection == SortDirections.ASC ? true : false,
                              itemBuilder: (context, position){
                                final note = filteredNotes[position];
                                return Card(
                                  child: Column(
                                    children: <Widget>[
                                      ListTile(
                                        leading: Icon(Icons.description, size: 40.0, color: ColorsPalette.nycTaxi,),
                                        title: Text('${note.title}'),
                                        subtitle: (note.dateCreated.day.compareTo(note.dateModified.day) == 0) ?
                                        Text('${DateFormat.yMMMd().format(note.dateModified)}',
                                            style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.blueHorizon), fontSize: 12.0)) :
                                        Text('${DateFormat.yMMMd().format(note.dateModified)} / ${DateFormat.yMMMd().format(note.dateCreated)}',
                                            style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.blueHorizon), fontSize: 12.0)),
                                        trailing: _popupMenu(note, position),
                                        onTap: (){
                                          Navigator.pushNamed(context, noteDetailsRoute, arguments: note.id);
                                        },
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                        alignment: Alignment.centerLeft,
                                        child: note.tagIds != null && _tags != null ? getChips(note, _tags, _allTagsSelected, _selectedTags): Container(),
                                      )
                                    ],
                                  ),
                                );
                              }
                          ),
                        ) : Container(
                              padding: new EdgeInsets.all(25.0),
                              child: Center(
                                child: Text("No notes here", style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.greenGrass), fontSize: 18.0)),
                              )
                        )
                        ],
                      ),
                    ),
                  )
                );
              }else {
                return Container();
              }
            }
        ),);
  }

  Widget getChips(Note note, List<Tag> tags, bool allTagsSelected, List<Tag> selectedTags) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: tags.where((t) => note.tagIds.contains(t.id))
              .map((tag) => Padding(
              padding: EdgeInsets.all(3.0),
              child: Text("#"+tag.name, style: GoogleFonts.quicksand(
                  textStyle: TextStyle(color: ColorsPalette.greenGrass),
                  fontSize: 15.0,
                  fontWeight: (selectedTags != null && selectedTags.contains(tag) && !allTagsSelected) ? FontWeight.bold : FontWeight.normal))
          ))
              .toList(),
        ));
  }

  List<Note> _sortNotes(List<Note> notes, SortFields sortOption){
    notes.sort((a, b){
      switch(sortOption){
        case SortFields.DATECREATED:{
          return a.dateCreated.millisecondsSinceEpoch.compareTo(b.dateCreated.millisecondsSinceEpoch);
        }
        case SortFields.DATEMODIFIED:{
          return a.dateModified.millisecondsSinceEpoch.compareTo(b.dateModified.millisecondsSinceEpoch);
        }
        case SortFields.TITLE:{
          return a.title.toUpperCase().compareTo(b.title.toUpperCase());
        }
      }
      return a.title.compareTo(b.title);
    });
    return notes;
  }

  List<Note> _filterNotes(List<Note> notes, List<Tag> selectedTags, bool allTagsSelected, bool noTagsSelected){
    List<Note> filteredNotes = new List<Note>();
    if(allTagsSelected){
      filteredNotes = notes;
    }else{
      if(noTagsSelected){
        filteredNotes.addAll(notes.where((n) => n.tagIds.isEmpty).toList());
      }
      selectedTags.forEach((t){
        notes.where((n) => n.tagIds.isNotEmpty && n.tagIds.contains(t.id)).forEach((n){
          if(!filteredNotes.any((note) => note.id == n.id)) filteredNotes.add(n);
        });
      });
    }
    return filteredNotes;
  }

  Widget _popupMenu(Note note, int position) => PopupMenuButton<int>(
    itemBuilder: (context) => [
      PopupMenuItem(
        value: 2,
        child: Text("Delete",style: TextStyle(color: ColorsPalette.blueHorizon, fontWeight: FontWeight.w700),),),],
    onSelected: (value) async{
      if(value == 2){
        showDialog<String>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (_) =>
              /*BlocProvider<NoteBloc>(
                create: (context) => NoteBloc(notesRepository: FirebaseNotesRepository()),
                child: NoteDeleteAlert(note: note, callback: (val) =>''),
              ),*/
          BlocProvider.value(
            value: context.bloc<NoteBloc>(),
            child: NoteDeleteAlert(note: note, callback: (val) =>''),
          ),
        );
      }},);

}


