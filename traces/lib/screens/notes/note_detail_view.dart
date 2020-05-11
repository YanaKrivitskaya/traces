
import 'package:flutter/material.dart';
import 'package:traces/screens/notes/details_bloc/bloc.dart';
import 'package:traces/screens/notes/note_delete_alert.dart';
import 'package:traces/screens/notes/note.dart';
import 'package:traces/screens/notes/notes_bloc/bloc.dart';
import 'package:traces/screens/notes/repository/firebase_notes_repository.dart';
import '../../colorsPalette.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  Note _note = Note('');
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _titleController = new TextEditingController(text: _note.title);
    _textController = new TextEditingController(text: _note.text);
  }
  @override
  void dispose(){
    _titleController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){

    return BlocListener<DetailsBloc, DetailsState>(
      listener: (context, state){},
      child: BlocBuilder<DetailsBloc, DetailsState>(builder: (context, state){
        if(state is ViewDetailsState){
          _note = state.note;
          _isEditMode = false;
        }
        if(state is EditDetailsState){
          _note = state.note;
          _isEditMode = true;
          _titleController.text = state.note.title;
          _textController.text = state.note.text;
        }
        return new Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: <Widget>[
              _isEditMode ? _saveAction(_note) : _editAction(state),
              _deleteAction(_note, context),
            ],
            backgroundColor: ColorsPalette.greenGrass,
          ),
            body: Container(
                padding: EdgeInsets.only(bottom: 65.0),
                child: Column(children: <Widget>[
                  _titleCard(),
                  _textCard()
                ])
            )
        );
      }),
    );
  }

  Widget _editAction(DetailsState state) => new IconButton(
    icon: Icon(Icons.edit),
    onPressed: () {
      if(state is ViewDetailsState){
        context.bloc<DetailsBloc>().add(EditMode(state.note));
      }
    },
  );

  Widget _saveAction(Note note) => new IconButton(
    icon: Icon(Icons.save),
    onPressed: () {
      Note noteToSave = new Note(_textController.text, title: _titleController.text, id: note.id, dateCreated: note.dateCreated);
      context.bloc<DetailsBloc>().add(SaveNote(noteToSave));
    },
  );

  Widget _titleCard() => new Card(
      child: Padding(
          padding: _isEditMode ? EdgeInsets.only(bottom: 15.0, right: 15.0, left: 15.0) : EdgeInsets.all(5.0),
          child:!_isEditMode?
          ListTile(
            title: Text('${_note.title}', style: new TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Created: ${DateFormat.yMMMd().format(_note.dateCreated)} | Modified: ${DateFormat.yMMMd().format(_note.dateModified)}',  ),
          ) : _titleTextField()
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
          Card(
              child: Padding(
                  padding: _isEditMode ? EdgeInsets.only(bottom: 15.0, right: 15.0, left: 15.0) : EdgeInsets.all(5.0),
                  child:!_isEditMode?
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

  Widget _textTextField() => new TextFormField(
    decoration: const InputDecoration(
      labelText: 'Note text comes here',
    ),
    controller: _textController,
    keyboardType: TextInputType.multiline,
    maxLines: null,
    autofocus: true,
  );

  Widget _deleteAction(Note note, BuildContext context) => new IconButton(
    icon: Icon(Icons.delete),
    onPressed: () {
      showDialog<String>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (_) =>
            BlocProvider<NotesBloc>(
              create: (context) => NotesBloc(notesRepository: FirebaseNotesRepository()),
              child: NoteDeleteAlert(note: note,
                  callback: (val) =>
                    val == 'Delete' ? Navigator.of(context).pop() : ''
                  ),
            ),
      );
    },
  );

}

