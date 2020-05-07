import 'dart:async';

import 'package:flutter/material.dart';
import 'package:traces/Models/noteModel.dart';
import 'package:traces/screens/notes/details_bloc/bloc.dart';
import 'package:traces/screens/notes/note.dart';
import '../../colorsPalette.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../globals.dart';

class NoteDetailsView extends StatefulWidget{

  NoteDetailsView({
    Key key,
    @required this.noteId,
  }) : super(key: key);

  final String noteId;

  @override
  State<StatefulWidget> createState() {
    return new _NotesDetailsViewState();
  }
}

class _NotesDetailsViewState extends State<NoteDetailsView>{
  DetailsBloc _detailsBloc;

  Note _note;

  bool isEditMode = false;

  TextEditingController _titleController;
  TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _detailsBloc = BlocProvider.of<DetailsBloc>(context);
  }

  @override
  Widget build(BuildContext context){

    return BlocListener<DetailsBloc, DetailsState>(
      listener: (context, state){
      },
      child: BlocBuilder<DetailsBloc, DetailsState>(
          builder: (context, state){
            if(state is InitialDetailsState && widget.noteId != ''){
              _detailsBloc.add(GetNoteDetails(widget.noteId));
            }
            if(state is InitialDetailsState && widget.noteId == ''){
              _detailsBloc.add(NewNoteMode());
            }
            if(state is ViewDetailsState){
              _note = state.note;
              return new Scaffold(
                  appBar: AppBar(
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    actions: <Widget>[
                      _editAction(state),
                      _deleteAction(_note, context),
                    ],
                    backgroundColor: ColorsPalette.greenGrass,
                  ),
                  body: Container(
                      padding: EdgeInsets.only(bottom: 65.0),
                      child:
                      Column(children: <Widget>[
                        _titleViewCard(),
                        _textViewCard()
                      ])
                  )
              );
            }
            if(state is EditDetailsState){
              _note = state.notetoEdit;

              _titleController = new TextEditingController(text: _note.title);
              _textController = new TextEditingController(text: _note.text);
              return new Scaffold(
                  appBar: AppBar(
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    actions: <Widget>[
                      _saveAction(state),
                      _deleteAction(_note, context),
                    ],
                    backgroundColor: ColorsPalette.greenGrass,
                  ),
                  body: Container(
                      padding: EdgeInsets.only(bottom: 65.0),
                      child:
                      Column(children: <Widget>[
                        _titleCard(),
                        _textCard()
                      ])
                  )
              );
            }
            return Container();
          }
      ),
    );
  }

  Widget _editAction(DetailsState state) => new IconButton(
    icon: Icon(Icons.edit),
    onPressed: () {
      if(state is ViewDetailsState){
        _detailsBloc.add(EditMode(state.note));
      }
    },
  );

  Widget _titleViewCard() => new Card(
      child: Padding(
          padding: EdgeInsets.all(5.0),
          child:
          ListTile(
            title: Text('${_note.title}', style: new TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Created: ${DateFormat.yMMMd().format(_note.dateCreated)} | Modified: ${DateFormat.yMMMd().format(_note.dateModified)}',  ),
          )
      )
  );

  Widget _textViewCard() => new Expanded(
    child: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Card(
              child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child:
                  ListTile(
                      title: Text('${_note.text}'),
                      contentPadding: EdgeInsets.all(10.0)
                  )
              )
          )
        ],
      ),
    ),
  );

  Widget _titleCard() => new Card(
      child: Padding(
        padding: EdgeInsets.only(bottom: 15.0, right: 15.0, left: 15.0),
          child: _titleTextField()
      )
  );

  Widget _titleTextField() => new TextFormField(
      decoration: const InputDecoration(
        labelText: 'Title',
      ),
      controller: _titleController,
      keyboardType: TextInputType.text
  );

  Widget _textCard() => new Expanded(
    child: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Card(child: Padding(padding: EdgeInsets.only(bottom: 15.0, right: 15.0, left: 15.0) ,
                  child:_textTextField())
          )
        ],
      ),
    ),
  );

  Widget _textTextField() => new TextFormField(
    decoration: const InputDecoration(
      labelText: 'Note text comes here',
    ),
    controller: _textController,
    keyboardType: TextInputType.multiline,
    maxLines: null,
    autofocus: true,
  );

  Future<String> _deleteAlert(NoteModel note) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete note?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('${note.title}'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Delete'),
              onPressed: () {
                _deleteNote(context, note.id);
              },
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context, "Cancel");
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteNote(BuildContext context, String id) async{
    Global.noteRepository.deleteNote(id).then((data){
      Navigator.pop(context, "Delete");
    });
  }

  void _editNote(NoteModel note) async{
    //_isLoading = true;
    if(note.id != ''){
      NoteModel updatedNote = NoteModel(note.id, _titleController.text, _textController.text, note.dateCreated, note.dateModified);
      await Global.noteRepository.updateNote(updatedNote).then((note){
        /*setState(() {
          _editMode = false;
          _isLoading = false;
          this._note = note;
        });*/
      });
    } else{
      Global.noteRepository.createNote(_titleController.text, _textController.text).then((note){
        /*setState(() {
          _editMode = false;
          _isLoading = false;
          this._note = note;
        });*/
      });
    }
  }

  Widget _saveAction(DetailsState state) => new IconButton(
    icon: Icon(Icons.save),
    onPressed: () {
      //_editNote(note);
    },
  );

  Widget _deleteAction(Note note, BuildContext context) => new IconButton(
    icon: Icon(Icons.delete),
    onPressed: () {
      /*_deleteAlert(note).then((res){
        if(res == "Delete") Navigator.of(context).pop();
      });*/
    },
  );


}

