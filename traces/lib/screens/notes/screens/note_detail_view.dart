
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:traces/utils/style/styles.dart';
import 'package:traces/widgets/error_widgets.dart';

import '../../../constants/color_constants.dart';
import '../bloc/note_bloc/bloc.dart';
import '../bloc/note_details_bloc/bloc.dart';
import '../bloc/tag_add_bloc/bloc.dart';
import '../models/note.model.dart';
import '../models/tag.model.dart';
import '../widgets/note_delete_alert.dart';
import '../widgets/tags_add_dialog.dart';

class NoteDetailsView extends StatefulWidget{
  NoteDetailsView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _NotesDetailsViewState();
  }
}

class _NotesDetailsViewState extends State<NoteDetailsView>{

  TextEditingController? _titleController;
  TextEditingController? _textController;

  Note? _note = Note();
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _titleController = new TextEditingController(text: _note!.title);
    _textController = new TextEditingController(text: _note!.content);
  }

  @override
  void dispose(){
    _titleController!.dispose();
    _textController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){

    return BlocListener<NoteDetailsBloc, NoteDetailsState>(
      listener: (context, state){        
        if(state is ErrorDetailsState && state.note != null){
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
                        state.errorMessage.toString(), style:quicksandStyle(color: ColorsPalette.lynxWhite),
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
      child: BlocBuilder<NoteDetailsBloc, NoteDetailsState>(builder: (context, state){
        if(state is ViewDetailsState){
          _note = state.note;          
          _isEditMode = false;
        }
        if(state is EditDetailsState){
          _note = state.note;
          _isEditMode = true;
          _titleController!.text = state.note!.title ?? '';
          _textController!.text = state.note!.content ?? '';
        }
        return new Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: ColorsPalette.black),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            centerTitle: true,
            /*title: _isEditMode ? Text("Edit note", style: quicksandStyle(fontSize: 30.0)) 
              : Text("View note", style: quicksandStyle(fontSize: 30.0)),*/
            actions: <Widget>[
               _isEditMode ? _saveAction(_note) : _editAction(state),
              !_isEditMode ? _tagsAction(_note!.id): Container(),             
              _note!.id != null && !_isEditMode ? _deleteAction(_note, context) : Container(),
            ],
            backgroundColor: ColorsPalette.white,
            elevation: 0,
          ),

          floatingActionButton: _isEditMode ? FloatingActionButton.extended(
            onPressed: (){},
            backgroundColor: ColorsPalette.juicyYellow,
            label: Text("Image", style: quicksandStyle(color: ColorsPalette.white),),
            icon: Icon(Icons.image_outlined, color: ColorsPalette.white),
          ) : Container(),
          body: Container(
              child: state is LoadingDetailsState || state is InitialNoteDetailsState
                  ? Center(child: CircularProgressIndicator())
                  : state is ErrorDetailsState && state.note == null ? errorWidget(context, error: state.errorMessage)
                  : _noteView(_note!.tags)
          ),
          backgroundColor: Colors.white,
        );
      }),
    );
  }

  Widget _getTags(List<Tag> tags) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: tags.map((tag) => Padding(
              padding: EdgeInsets.all(3.0),
              child: Text("#"+tag.name!, style: TextStyle(color: ColorsPalette.juicyBlue, fontSize: 14.0),)
          )).toList(),
        ));
  }

  Widget _tagsAction(int? noteId) => new IconButton(
    padding: EdgeInsets.only(right: 10.0),
    constraints: BoxConstraints(),    
    icon: Icon(Icons.tag, color: ColorsPalette.black),
    onPressed: () {
      showDialog(
          barrierDismissible: false, context: context, builder: (_) =>
          MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: context.read<NoteDetailsBloc>(),
              ),
              BlocProvider<TagAddBloc>(
                  create: (context) => TagAddBloc()..add(GetTags()),
              ),
            ],
            child:  TagsAddDialog(callback: (val) async {
              if(val == 'Ok'){
                context.read<NoteDetailsBloc>().add(GetNoteDetails(noteId));                
              }
            }),
          ));},
  );

  Widget _editAction(NoteDetailsState state) => new IconButton(
    padding: EdgeInsets.only(right: 10.0),
    constraints: BoxConstraints(),   
    icon: Icon(Icons.edit, color: ColorsPalette.black),
    onPressed: () {
      if(state is ViewDetailsState){
        context.read<NoteDetailsBloc>().add(EditModeClicked(state.note));
      }
    },
  );

  Widget _saveAction(Note? note) => new IconButton(
    padding: EdgeInsets.only(right: 10.0),
    constraints: BoxConstraints(),   
    icon: Icon(Icons.check, color: ColorsPalette.black),
    onPressed: () {
      Note noteToSave = new Note(
        content: _textController!.text, 
        title: _titleController!.text, 
        id: note!.id, 
        userId: note.userId,
        deleted: note.deleted,
        createdDate: note.createdDate, tags: note.tags);
      context.read<NoteDetailsBloc>().add(SaveNoteClicked(noteToSave));
    },
  );

  Widget _noteView(List<Tag>? tags){
    return Container(
        padding: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 15),
        margin: EdgeInsets.all(5),
        color: Colors.white,
        child: Container(
            child: SingleChildScrollView(
                child: _isEditMode
                    ? _noteCardEdit(tags)
                    : _noteCardView(tags!)
            )
        )
    );
  }

  Widget _noteCardView(List<Tag> tags) => new Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      _note!.trip != null ? Container(        
        alignment: Alignment.centerLeft,
        child: Chip(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
          backgroundColor: ColorsPalette.amMint,
          label: Text(_note!.trip!.name!, style: TextStyle(color: ColorsPalette.white)),
        ),
      ) : Container(), 
      Text('${_note!.title}', style: quicksandStyle(fontSize: 18.0, weight: FontWeight.bold)),
      Text('Created: ${DateFormat.yMMMd().format(_note!.createdDate!)} | Modified: ${DateFormat.yMMMd().format(_note!.updatedDate!)}',
          style: quicksandStyle(fontSize: 14.0
          )),
      _note!.tags!.length > 0 ? Divider(color: ColorsPalette.juicyYellow) : Container(),
      _getTags(tags),
      Divider(color: ColorsPalette.juicyYellow),
      Text('${_note!.content ?? ''}', style:quicksandStyle(fontSize: 16)),
    ],
  );

  Widget _noteCardEdit(List<Tag>? tags) => new Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      Container(        
        alignment: Alignment.centerLeft,
        child: Chip(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
          backgroundColor: ColorsPalette.amMint,
          avatar: Icon(Icons.signpost, color: ColorsPalette.white,),
          label: Text("Add Trip reference", style: TextStyle(color: ColorsPalette.white)),
        ),
      ), 
      TextFormField(
        cursorColor: ColorsPalette.black,
        decoration: const InputDecoration(
            labelText: 'Title',
            border: InputBorder.none,
            labelStyle: TextStyle(color: ColorsPalette.black)
        ),
        style: quicksandStyle(fontSize: 18.0, weight: FontWeight.bold),
        controller: _titleController,
        keyboardType: TextInputType.text,
        autofocus: true,
      ),
      _note!.tags != null && _note!.tags!.length > 0 ? _getTags(tags!) : Container(),
      Divider(color: ColorsPalette.juicyYellow),
      TextFormField(
        decoration: const InputDecoration(
            labelText: 'Note text comes here',
            border: InputBorder.none
        ),
        controller: _textController,
        keyboardType: TextInputType.multiline,
        maxLines: null,
      )
    ],
  );

  Widget _deleteAction(Note? note, BuildContext context) => new IconButton(
    padding: EdgeInsets.only(right: 10.0),
    constraints: BoxConstraints(),   
    icon: Icon(Icons.delete, color: ColorsPalette.black),
    onPressed: () {
      showDialog<String>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (_) =>
            BlocProvider<NoteDetailsBloc>(
              create: (context) => NoteDetailsBloc(/*TagFilterBloc()*/),
              child: NoteDeleteAlert(note: note,
                  callback: (val) async {
                    if(val == 'Ok'){
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
                                    "Note deleted successfully", style:quicksandStyle(color: ColorsPalette.lynxWhite),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 5,
                                  ),
                                ),
                                Icon(Icons.check, color: ColorsPalette.lynxWhite,)],
                            ),
                            backgroundColor: ColorsPalette.greenGrass,
                          ),
                      );
                      Navigator.of(context).pop();
                    }
                    else{
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
                                    val, style:quicksandStyle(color: ColorsPalette.lynxWhite),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 5,
                                  ),
                                ),
                                Icon(Icons.error, color: ColorsPalette.lynxWhite,)],
                            ),
                            backgroundColor: ColorsPalette.redPigment,
                          ),
                      );
                    }
                  }                 
              ),
            ),
      );
    },
  );
}

