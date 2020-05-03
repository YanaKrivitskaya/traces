import 'dart:async';

import 'package:flutter/material.dart';
import 'package:traces/Models/noteModel.dart';
import 'package:traces/screens/notes/noteRepository.dart';
import '../../colorsPalette.dart';
import 'package:intl/intl.dart';

import '../../globals.dart';

class NoteDetailsPage extends StatefulWidget{

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

  bool _editMode = false;

  bool _isLoading = false;

  NoteModel _note;

  TextEditingController _titleController;
  TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _note = new NoteModel('', '', '', new DateTime.now(), new DateTime.now());
    if(widget.noteId != '') {
      _getNoteById(widget.noteId);
      _isLoading = true;
      _editMode = false;
    }else{
      _editMode = true;
    }
  }

  @override
  Widget build(BuildContext context){

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
        padding: EdgeInsets.only(bottom: 65.0),
          child: (_isLoading != null && !_isLoading) ? Column(children: <Widget>[
            _titleCard(),
            _textCard()
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
    Global.noteRepository.deleteNote(id).then((data){
      Navigator.pop(context, "Delete");
    });
  }

  void _getNoteById(String id) async{
    Global.noteRepository.getNoteById(widget.noteId).then((note){
      setState(() {
        _note = note;
        _isLoading = false;
      });
    });
  }

  void _editNote(NoteModel note) async{
    _isLoading = true;
    if(note.id != ''){
      NoteModel updatedNote = NoteModel(note.id, _titleController.text, _textController.text, note.dateCreated, note.dateModified);
      await Global.noteRepository.updateNote(updatedNote).then((note){
        setState(() {
          _editMode = false;
          _isLoading = false;
          this._note = note;
        });
      });
    } else{
      Global.noteRepository.createNote(_titleController.text, _textController.text).then((note){
        setState(() {
          _editMode = false;
          _isLoading = false;
          this._note = note;
        });
      });;
    }

  }

  Widget _titleCard() => new Card(
      child: Padding(
          padding: _editMode ? EdgeInsets.only(bottom: 15.0, right: 15.0, left: 15.0) : EdgeInsets.all(5.0),
          child:!_editMode?
          ListTile(
            title: Text('${_note.title}', style: new TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Created: ${DateFormat.yMMMd().format(_note.dateCreated)} | Modified: ${DateFormat.yMMMd().format(_note.dateModified)}',  ),
          ) : _titleTextField()
      )
  );

  Widget _textCard() => new Expanded(
    child: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
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
        ],
      ),
    ),
  );

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
      autofocus: true,
  );
  }

