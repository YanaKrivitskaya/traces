import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traces/Models/noteModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:traces/services/noteFireService.dart';
import '../../colorsPalette.dart';
import 'package:intl/intl.dart';

/*class NoteDetailsPageArguments {
  final NoteModel note;

  NoteDetailsPageArguments(this.note);
}*/

class NoteDetailsPage extends StatefulWidget{

  /*NoteDetailsPage({this.noteId});*/

  NoteDetailsPage({
    Key key,
    @required this.noteId,
  }) : super(key: key);

  final String noteId;

  @override
  State<StatefulWidget> createState() {
    return new _NotesDetailsPageState();
  }
}

class _NotesDetailsPageState extends State<NoteDetailsPage>{

  final NoteFireService noteService = new NoteFireService();
  bool _editMode = false;

  bool _isLoading = false;

  NoteModel _note;

  TextEditingController _titleController;
  TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _note = new NoteModel('', '_title', '_text', new DateTime.now());
    _getNoteById(widget.noteId);
    _editMode = false;
  }

  @override
  Widget build(BuildContext context){
    //final NoteDetailsPageArguments arguments = ModalRoute.of(context).settings.arguments;

    //_note = arguments.note;

    _titleController = new TextEditingController(text: _note.title);
    _textController = new TextEditingController(text: _note.text);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          _editMode ? _saveAction(_note) : _editAction(),
          _deleteAction(_note, context),
        ],
        backgroundColor: ColorsPalette.greenGrass,
      ),
      body: Container(
          child: (_isLoading != null && !_isLoading) ? Column(children: <Widget>[
            Card(
                child: Padding(
                  padding: _editMode ? EdgeInsets.only(bottom: 15.0, right: 15.0, left: 15.0) : EdgeInsets.all(5.0),
                  child:!_editMode?
                  ListTile(
                    title: Text('${_note.title}', style: new TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Created: ${DateFormat.yMMMd().format(_note.dateCreated)} | Modified: ${DateFormat.yMMMd().format(_note.dateModified)}' ),
                  ) : _titleTextField()
                )
            ),
            Card(
              child: Padding(
                  padding: _editMode ? EdgeInsets.only(bottom: 15.0, right: 15.0, left: 15.0) : EdgeInsets.all(5.0),
                  child:!_editMode?
                    ListTile(
                      title: Text('${_note.text}'),
                      contentPadding: EdgeInsets.all(10.0)
                    ) : _textTextField()
                  )
            )
      ]) : Center(child: CircularProgressIndicator())
      )
    );
  }

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
    noteService.deleteNote(id).then((data){
      Navigator.pop(context, "Delete");
    });
  }

  void _getNoteById(String id) async{
    noteService.getNoteById(widget.noteId).then((note){
      setState(() {
        _note = note;
        _isLoading = false;
      });
    });
  }

  void _editNote(NoteModel note) async{
    _isLoading = true;
    NoteModel updatedNote = NoteModel(note.id, _titleController.text, _textController.text, note.dateCreated);
    await noteService.updateNote(updatedNote).then((note){
      print(note.title);
      setState(() {
        _editMode = false;
        _isLoading = false;
        this._note = note;
      });
    });
  }

  Widget _editAction() => new IconButton(
    icon: Icon(Icons.edit),
    onPressed: () {
      setState(() {
        _editMode = true;
      });
    },
  );

  Widget _saveAction(NoteModel note) => new IconButton(
    icon: Icon(Icons.save),
    onPressed: () {
      _editNote(note);
      /*setState(() {
        _editMode = false;
      });*/
    },
  );

  Widget _deleteAction(NoteModel note, BuildContext context) => new IconButton(
    icon: Icon(Icons.delete),
    onPressed: () {
      _deleteAlert(note).then((res){
        if(res == "Delete") Navigator.of(context).pop();
      });
    },
  );

  Widget _titleTextField() => new TextFormField(
    decoration: const InputDecoration(
      labelText: 'Title',
    ),
    controller: _titleController,
    keyboardType: TextInputType.text
  );

  Widget _textTextField() => new TextFormField(
      decoration: const InputDecoration(
        labelText: 'Note text comes here',
      ),
      controller: _textController,
      keyboardType: TextInputType.multiline,
      maxLines: null,
  );



  }

