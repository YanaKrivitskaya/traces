
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../constants/color_constants.dart';
import '../bloc/note_bloc/bloc.dart';
import '../bloc/note_details_bloc/bloc.dart';
import '../bloc/tag_add_bloc/bloc.dart';
import '../models/note.model.dart';
import '../models/tag.model.dart';
import '../widgets/note_delete_alert.dart';
import '../widgets/tags_add_dialog.dart';

class NoteDetailsView extends StatefulWidget{
  NoteDetailsView({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _NotesDetailsViewState();
  }
}

class _NotesDetailsViewState extends State<NoteDetailsView>{

  TextEditingController _titleController;
  TextEditingController _textController;

  Note _note = Note();
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _titleController = new TextEditingController(text: _note.title);
    _textController = new TextEditingController(text: _note.content);
  }

  @override
  void dispose(){
    _titleController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){

    return BlocListener<NoteDetailsBloc, NoteDetailsState>(
      listener: (context, state){
        print(state);
      },
      child: BlocBuilder<NoteDetailsBloc, NoteDetailsState>(builder: (context, state){
        if(state is ViewDetailsState){
          _note = state.note;          
          _isEditMode = false;
        }
        if(state is EditDetailsState){
          _note = state.note;
          _isEditMode = true;
          _titleController.text = state.note.title;
          _textController.text = state.note.content;
        }
        return new Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: FaIcon(FontAwesomeIcons.chevronLeft, color: ColorsPalette.lynxWhite),
              onPressed: () {                
                Navigator.of(context).pop();
              },
            ),
            title: _isEditMode ? Text("Edit note", style: TextStyle(color: ColorsPalette.lynxWhite)) 
              : Text("View note", style: TextStyle(color: ColorsPalette.lynxWhite)),
            actions: <Widget>[
              !_isEditMode ? _tagsAction(_note.id): Container(),
              _isEditMode ? _saveAction(_note) : _editAction(state),
              _note.id != null ? _deleteAction(_note, context) : Container(),
            ],
            backgroundColor: ColorsPalette.greenGrass,
          ),
          body: Container(
              child: state is LoadingDetailsState || state is InitialNoteDetailsState
                  ? Center(child: CircularProgressIndicator())
                  :_noteView(_note.tags)
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
              child: Text("#"+tag.name, style: TextStyle(color: ColorsPalette.greenGrass, fontSize: 14.0),)
          )).toList(),
        ));
  }

  Widget _tagsAction(int noteId) => new IconButton(
    icon: FaIcon(FontAwesomeIcons.hashtag, color: ColorsPalette.lynxWhite),
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
    icon: FaIcon(FontAwesomeIcons.edit, color: ColorsPalette.lynxWhite),
    onPressed: () {
      if(state is ViewDetailsState){
        context.read<NoteDetailsBloc>().add(EditModeClicked(state.note));
      }
    },
  );

  Widget _saveAction(Note note) => new IconButton(
    icon: FaIcon(FontAwesomeIcons.solidSave, color: ColorsPalette.lynxWhite),
    onPressed: () {
      Note noteToSave = new Note(
        content: _textController.text, 
        title: _titleController.text, 
        id: note.id, 
        userId: note.userId,
        deleted: note.deleted,
        createdDate: note.createdDate, tags: note.tags);
      context.read<NoteDetailsBloc>().add(SaveNoteClicked(noteToSave));
    },
  );

  Widget _noteView(List<Tag> tags){
    return Container(
        padding: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 15),
        margin: EdgeInsets.all(5),
        color: Colors.white,
        child: Container(
            child: SingleChildScrollView(
                child: _isEditMode
                    ? _noteCardEdit(tags)
                    : _noteCardView(tags)
            )
        )
    );
  }

  Widget _noteCardView(List<Tag> tags) => new Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      Text('${_note.title}', style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      Text('Created: ${DateFormat.yMMMd().format(_note.createdDate)} | Modified: ${DateFormat.yMMMd().format(_note.updatedDate)}',
          style: new TextStyle(fontSize: 12.0
          )),
      _note.tags.length > 0 ? Divider(color: ColorsPalette.nycTaxi) : Container(),
      _getTags(tags),
      Divider(color: ColorsPalette.nycTaxi),
      Text('${_note.content ?? ''}', style: new TextStyle(fontSize: 16),),
    ],
  );

  Widget _noteCardEdit(List<Tag> tags) => new Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      TextFormField(
        decoration: const InputDecoration(
            labelText: 'Title',
            border: InputBorder.none
        ),
        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        controller: _titleController,
        keyboardType: TextInputType.text,
        autofocus: true,
      ),
      _note.tags != null && _note.tags.length > 0 ? _getTags(tags) : Container(),
      Divider(color: ColorsPalette.nycTaxi),
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

  Widget _deleteAction(Note note, BuildContext context) => new IconButton(
    icon: FaIcon(FontAwesomeIcons.trashAlt, color: ColorsPalette.lynxWhite),
    onPressed: () {
      showDialog<String>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (_) =>
            BlocProvider<NoteBloc>(
              create: (context) => NoteBloc(),
              child: NoteDeleteAlert(note: note,
                  callback: (val) async {
                    if(val == 'Delete'){
                      Navigator.of(context).pop();
                    }
                  }                 
              ),
            ),
      );
    },
  );
}

