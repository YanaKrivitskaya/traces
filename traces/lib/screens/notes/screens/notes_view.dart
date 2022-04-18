
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:traces/screens/notes/widgets/note_tile.dart';
import 'package:traces/utils/style/styles.dart';
import 'package:traces/widgets/error_widgets.dart';

import '../../../constants/color_constants.dart';
import '../../../constants/route_constants.dart';
import '../../../utils/misc/state_types.dart';
import '../bloc/note_bloc/bloc.dart';
import '../models/note.model.dart';
import '../models/tag.model.dart';

class NotesView extends StatefulWidget{
  NotesView();
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> { 
 
  bool _allTagsSelected = true;
  bool _noTagsSelected = true;
  List<Tag>? _selectedTags;

  TextEditingController? _searchController;

  @override
  void initState() {
    super.initState();

    _searchController = new TextEditingController(text: '');
    _searchController!.addListener(_onSearchTextChanged);    
  }

  @override
  void dispose(){
    _searchController!.dispose();
    super.dispose();    
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<NoteBloc>().add(GetAllNotes());} ,
      child: BlocListener<NoteBloc, NoteState>(
        listener: (context, state) {
          if(state.status != StateStatus.Error && state.exception != null){
            ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                //duration: Duration(days: 1),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(                      
                      width: 250,
                      child: Text(
                        state.exception.toString(), style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.lynxWhite)),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                      ),
                    ),
                    Icon(Icons.error)],
                ),
                backgroundColor: ColorsPalette.redPigment,
              ),
            );
          }
        },
        child: BlocBuilder<NoteBloc, NoteState>(
            bloc: BlocProvider.of(context),
            builder: (context, state){
              if(state.status == StateStatus.Error){
                return errorWidget(context, iconSize: 50.0, color: ColorsPalette.greenGrass, error: state.exception!, fontSize: 20.0);
              }

              if(state.status == StateStatus.Empty || state.status == StateStatus.Loading){
                return Center(child: CircularProgressIndicator());
              }
              if(state.status == StateStatus.Success){
                final notes = _sortNotes(state.filteredNotes!, state.sortField);
                
                _selectedTags = state.selectedTags;
                _allTagsSelected = state.allTagsSelected ?? true;
                _noTagsSelected = state.noTagsSelected ?? true;

                final filteredNotes = _filterNotes(notes, _selectedTags, _allTagsSelected, _noTagsSelected);

                if(!state.searchEnabled!) _searchController!.clear();

                return Container(                  
                  padding: EdgeInsets.only(bottom: 65.0, top: 10.0, left: 10.0, right: 10.0),
                  child: Container(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          state.searchEnabled! ? _searchBar() : Container(),
                          filteredNotes.length > 0 ?
                          Container(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: filteredNotes.length,
                              reverse: state.sortDirection == SortDirections.ASC ? true : false,
                              itemBuilder: (context, position){
                                final note = filteredNotes[position];
                                return _noteCard(note);
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
        ))       
    );    
  }

  Widget _noteCard(Note note, ) => new Card(    
    child: Column(
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        note.trip != null ? Container(
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          alignment: Alignment.centerLeft,
          child: Chip(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
            backgroundColor: /*ColorsPalette.natureGreenLight*/ColorsPalette.amMint,
            label: Text(note.trip!.name!, style: TextStyle(color: /*ColorsPalette.juicyGreen*/ColorsPalette.white)),
          ),
        ) : Container(),    
        InkWell(
            onTap: (){
            Navigator.pushNamed(context, noteDetailsRoute, arguments: note.id).then((value)
              {
                context.read<NoteBloc>().add(GetAllNotes());
              });
            },
          child: NoteTileView(note, _allTagsSelected, _selectedTags),
        )
      ],
    ),
  );

  Widget _searchBar(){
    return Container(
      padding: EdgeInsets.all(10.0),
      child: TextFormField(
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.search, color: ColorsPalette.juicyBlue),
          hintText: 'Search...',
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: ColorsPalette.juicyBlue),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: ColorsPalette.juicyBlue),
          ),
        ),
        controller: _searchController,
        keyboardType: TextInputType.text,
      )
    );
  }

  void _onSearchTextChanged() {
    context.read<NoteBloc>().add(SearchTextChanged(noteName: _searchController!.text));
  }

  List<Note> _sortNotes(List<Note> notes, SortFields? sortOption){
    notes.sort((a, b){
      switch(sortOption){
        case SortFields.DATECREATED:{
          return a.createdDate!.millisecondsSinceEpoch.compareTo(b.createdDate!.millisecondsSinceEpoch);
        }
        case SortFields.DATEMODIFIED:{
          return a.updatedDate!.millisecondsSinceEpoch.compareTo(b.updatedDate!.millisecondsSinceEpoch);
        }
        case SortFields.TITLE:{
          return a.title!.toUpperCase().compareTo(b.title!.toUpperCase());
        }
        default: return a.title!.compareTo(b.title!);
      }      
    });
    return notes;
  }

  List<Note> _filterNotes(List<Note> notes, List<Tag>? selectedTags, bool allTagsSelected, bool? noTagsSelected){
    List<Note> filteredNotes = <Note>[];
    if(allTagsSelected){
      filteredNotes = notes;
    }else{
      if(noTagsSelected!){
        filteredNotes.addAll(notes.where((n) => n.tags!.isEmpty).toList());
      }
      selectedTags!.forEach((t){
        print(t.name);
        notes.where((n) => n.tags!.isNotEmpty && n.tags!.contains(t)).forEach((n){
          print(n.title);
          if(!filteredNotes.any((note) => note.id == n.id)) filteredNotes.add(n);
        });
      });
    }
    //return notes;
    return filteredNotes;
  }

  /*Widget _popupMenu(Note note, int position) => PopupMenuButton<int>(
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
            BlocProvider.value(
              value: context.read<NoteBloc>(),
              child: NoteDeleteAlert(note: note, callback: (val) =>''),
            ),
        );
      }},);*/

}


