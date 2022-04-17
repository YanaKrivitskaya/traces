
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:traces/constants/route_constants.dart';
import 'package:traces/screens/notes/bloc/trip_list_bloc/trip_list_bloc.dart';
import 'package:traces/screens/notes/widgets/trip_list_dialog.dart';
import 'package:traces/utils/style/styles.dart';
import 'package:traces/widgets/error_widgets.dart';
import 'package:image_picker/image_picker.dart';

import '../../../constants/color_constants.dart';
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
  var _date = DateTime.now();

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
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: ColorsPalette.black),
              onPressed: (){
                Navigator.pop(context);
              },
            ),                     
            actions: <Widget>[
               _isEditMode ? _saveAction(_note) : _editAction(state),
              !_isEditMode ? _tagsAction(_note!.id): Container(),             
              _note!.id != null && !_isEditMode ? _deleteAction(_note, context) : Container(),
            ],
            backgroundColor: ColorsPalette.white,
            elevation: 0,
          ),
          floatingActionButton: _isEditMode && _note != null && _note!.image == null ? FloatingActionButton.extended(
            onPressed: (){
              _showSelectionDialog(context, _note!.id!);
            },
            backgroundColor: ColorsPalette.juicyYellow,
            label: Text("Image", style: quicksandStyle(color: ColorsPalette.white),),
            icon: Icon(Icons.image_outlined, color: ColorsPalette.white),
          ) : Container(),
          body: Container(
              child: state is LoadingDetailsState || state is InitialNoteDetailsState
                  ? Center(child: CircularProgressIndicator())
                  : state is ErrorDetailsState && state.note == null ? errorWidget(context, error: state.errorMessage)
                  :  _noteView(_note!.tags, state)
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

  Widget _noteView(List<Tag>? tags, NoteDetailsState state){
    return Container(
        padding: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 15),
        margin: EdgeInsets.all(5),
        color: Colors.white,
        child: Container(
            child: _isEditMode
                    ? _noteCardEdit(tags)
                    : _noteCardView(tags!, state)
        )
    );
  }

  Widget _noteCardView(List<Tag> tags, NoteDetailsState state) => new InkWell(
    onTap: (){
      if(state is ViewDetailsState){
        context.read<NoteDetailsBloc>().add(EditModeClicked(state.note));
      }
    },
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(        
          alignment: Alignment.centerLeft,
          child: ActionChip(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
            backgroundColor: ColorsPalette.amMint,
            avatar: Icon(Icons.signpost, color: ColorsPalette.white,),
            label: Text(_note!.trip != null ? _note!.trip!.name! : "Add Trip reference", style: TextStyle(color: ColorsPalette.white)),
            onPressed: (){              
                showDialog(
                  barrierDismissible: false, context: context, builder: (_) =>
                  BlocProvider<TripListBloc>(
                    create: (context) => TripListBloc()..add(GetTripsList(_note!)),
                    child: TripsListDialog(noteId: _note!.id!, callback: (val) async {
                if(val == 'Ok'){
                  context.read<NoteDetailsBloc>().add(GetNoteDetails(_note!.id!));                
                }
              }),
                  ),
              );
              },
          ),
        ),
        Text('${_note!.title}', style: quicksandStyle(fontSize: 18.0, weight: FontWeight.bold)),
        Text('Created: ${DateFormat.yMMMd().format(_note!.createdDate!)} | Modified: ${DateFormat.yMMMd().format(_note!.updatedDate!)}',
            style: quicksandStyle(fontSize: 14.0
            )),
        _note!.tags!.length > 0 ? Divider(color: ColorsPalette.juicyYellow) : Container(),
        _getTags(tags),
        Divider(color: ColorsPalette.juicyYellow),        
        Container(
          height: MediaQuery.of(context).size.height * 0.6,
          child: SingleChildScrollView(child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(alignment: Alignment.topLeft, child:  Text('${_note!.content ?? ''}', style:quicksandStyle(fontSize: 16))),
            SizedBox(height: 10.0),
            InkWell(
              onTap: (){
                Navigator.of(context).pushNamed(noteImageView, arguments: _note!.image!);
              },
              child: _note!.image != null ? Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [ 
                  Container(
                    padding: EdgeInsets.only(top: 10.0),
                    child: ClipRRect(                  
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.memory(            
                          _note!.image!)
                                      
                      ),
                  ),                  
                  Positioned(
                    top: 6.0,
                    child:InkWell(
                        onTap: (){
                          context.read<NoteDetailsBloc>().add(GetImage(null));
                        },                        
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorsPalette.juicyDarkBlue,
                          ),
                          child: Icon(Icons.close, size: 19.0, color: ColorsPalette.white,),
                        ),
                      ))
                ],
              ): Container()      
            )
            
          ]))) 
      ],
    ));

    Widget _noteCardEdit(List<Tag>? tags) => new Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[      
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
          //autofocus: true,
        ),
        Text('Created: ${DateFormat.yMMMd().format(_note!.createdDate ?? _date)} | Modified: ${DateFormat.yMMMd().format(_note!.updatedDate ?? _date)}',
            style: quicksandStyle(fontSize: 14.0
            )),
        _note!.tags != null && _note!.tags!.length > 0 ? _getTags(tags!) : Container(),
        Divider(color: ColorsPalette.juicyYellow),
        Container(
          padding: EdgeInsets.only(bottom: 20.0),
          height: MediaQuery.of(context).size.height * 0.6,
          child: SingleChildScrollView(
            // physics: ClampingScrollPhysics(),
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextFormField(
              decoration: const InputDecoration(                  
                  border: InputBorder.none
              ),
              controller: _textController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              autofocus: true,
            ),
            InkWell(
              onTap: (){
                Navigator.of(context).pushNamed(noteImageView, arguments: _note!.image!);
              },
              child: _note!.image != null ? Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [ 
                  Container(
                    padding: EdgeInsets.only(top: 10.0),
                    child: ClipRRect(                  
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.memory(            
                          _note!.image!)
                                      
                      ),
                  ),                  
                  Positioned(
                    top: 6.0,
                    child:InkWell(
                        onTap: (){
                          context.read<NoteDetailsBloc>().add(GetImage(null));
                        },                        
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorsPalette.juicyDarkBlue,
                          ),
                          child: Icon(Icons.close, size: 19.0, color: ColorsPalette.white,),
                        ),
                      ))
                ],
              ): Container()      
            )
          ])))
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

  Future _showSelectionDialog(BuildContext context, int noteId) async {
    await showDialog(
      context: context,
      builder: (_) => new SimpleDialog(
        title: Text('Select photo'),
        children: <Widget>[
          SimpleDialogOption(
            child: Text('From gallery'),
            onPressed: () {
              selectOrTakePhoto(ImageSource.gallery, context, noteId);
              Navigator.pop(context);
            },
          ),
          SimpleDialogOption(
            child: Text('Take a photo'),
            onPressed: () {
              selectOrTakePhoto(ImageSource.camera, context, noteId);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Future selectOrTakePhoto(ImageSource imageSource, BuildContext context, int noteId) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: imageSource);

    if(pickedFile != null){
      Navigator.pushNamed(context, imageCropRoute, arguments: File(pickedFile.path)).then((imageFile) {
        if(imageFile != null){
          context.read<NoteDetailsBloc>().add(GetImage(imageFile as File));          
        }
      });
    }
  }
}

