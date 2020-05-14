
import 'package:flutter/material.dart';
import 'package:traces/screens/notes/details_bloc/bloc.dart';
import 'package:traces/screens/notes/note_delete_alert.dart';
import 'package:traces/screens/notes/note.dart';
import 'package:traces/screens/notes/notes_bloc/bloc.dart';
import 'package:traces/screens/notes/repository/firebase_notes_repository.dart';
import 'package:traces/screens/notes/tags/bloc/bloc.dart';
import 'package:traces/screens/notes/tags/tag.dart';
import 'package:traces/screens/notes/tags_add_dialog.dart';
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
  List<Tag> _noteTags = new List<Tag>();
  List<Tag> _selectedTags = new List<Tag>();
  bool _isEditMode = false;

  List<Tag> _allTags;

  @override
  void initState() {
    super.initState();
    _titleController = new TextEditingController(text: _note.title);
    _textController = new TextEditingController(text: _note.text);
    //_tagController = new TextEditingController();

    _allTags = BlocProvider.of<TagBloc>(context).state.tags;
  }

  @override
  void dispose(){
    _titleController.dispose();
    _textController.dispose();
    _selectedTags.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){

    return BlocListener<DetailsBloc, DetailsState>(
      listener: (context, state){},
      child: BlocBuilder<DetailsBloc, DetailsState>(builder: (context, state){
        if(state is ViewDetailsState){
          _note = state.note;
          _noteTags = state.noteTags;
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
            title: _isEditMode ? Text("Edit note") : Text("View note"),
            actions: <Widget>[
              !_isEditMode ? _tagsAction() : Container(),
              _isEditMode ? _saveAction(_note) : _editAction(state),
              _note.id != null ? _deleteAction(_note, context) : Container(),
            ],
            backgroundColor: ColorsPalette.greenGrass,
          ),
          body: Container(
             child: state is LoadingDetailsState
                ? Center(child: CircularProgressIndicator())
                : _noteView(_noteTags)
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
          ))
              .toList(),
        ));
  }

  Widget _tagsAction() => new IconButton(
    icon: Icon(Icons.turned_in_not, color: Colors.white),
    onPressed: () {
      showDialog(
          barrierDismissible: false, context: context, builder: (_) =>
          MultiBlocProvider(
            providers: [
              BlocProvider<TagBloc>(
                create: (context) => TagBloc(notesRepository: FirebaseNotesRepository()
                )..add(GetTags()),
              ),
              BlocProvider.value(
                value: context.bloc<DetailsBloc>(),
              ),
            ],
            child:  TagsAddDialog(),
          )
      );
    },
  );

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
      Note noteToSave = new Note(_textController.text, title: _titleController.text, id: note.id, dateCreated: note.dateCreated, tagIds: note.tagIds);
      context.bloc<DetailsBloc>().add(SaveNote(noteToSave));
    },
  );

  Widget _noteView(List<Tag> tags){
    return Container(
      child: _isEditMode
          ? _noteCardEdit(tags)
          : _noteCardView(tags)
    );
  }

  Widget _noteCardView(List<Tag> tags) => new Container(
    padding: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 15),
    margin: EdgeInsets.all(5),
    color: Colors.white,
    child: Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('${_note.title}', style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text('Created: ${DateFormat.yMMMd().format(_note.dateCreated)} | Modified: ${DateFormat.yMMMd().format(_note.dateModified)}',
                style: new TextStyle(fontSize: 12.0
                )),
            _noteTags.length > 1 ? Divider(color: ColorsPalette.nycTaxi) : Container(),
            _getTags(tags),
            Divider(color: ColorsPalette.nycTaxi),
            Text('${_note.text}', style: new TextStyle(fontSize: 16),),
          ],
        )
      )
    )
  );

  Widget _noteCardEdit(List<Tag> tags) => new Container(
      padding: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 15),
      margin: EdgeInsets.all(5),
      color: Colors.white,
      child: Container(
          child: SingleChildScrollView(
              child: Column(
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
                  _noteTags.length > 0 ? _getTags(tags) : Container(),
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
              )
          )
      )
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
