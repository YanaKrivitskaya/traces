import 'package:flutter/material.dart';
import 'package:traces/colorsPalette.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/screens/profile/bloc/bloc.dart';

class NameEditButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.edit, size: 20.0, color: ColorsPalette.meditSea),
        onPressed: (){
          showDialog(barrierDismissible: false, context: context,builder: (_) =>
              BlocProvider.value(
                value: context.bloc<ProfileBloc>(),
                child: NameEditDialog(),
              ),
          );
        });
  }
}

class NameEditDialog extends StatefulWidget{

  @override
  _NameEditDialogState createState() => new _NameEditDialogState();
}

class _NameEditDialogState extends State<NameEditDialog>{
  TextEditingController _usernameController;

  @override
  void initState() {
    super.initState();

    _usernameController = TextEditingController(text: context.bloc<ProfileBloc>().state.profile.displayName);
    _usernameController.addListener(_onUsernameChanged);

  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
    builder: (context, state) {

      return new AlertDialog(
        title: Text('Update name'),
        actions: <Widget>[
          FlatButton(
            child: Text('Done'),
            onPressed: () {
              context.bloc<ProfileBloc>().add(UsernameUpdated(username: _usernameController.text));
              Navigator.pop(context);
            },
            textColor: ColorsPalette.meditSea,
          ),
        ],
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _usernameTextField(_usernameController, state)
            ],
          ),
        ),
      );
    });
  }

  Widget _usernameTextField(TextEditingController usernameController, ProfileState state) => new TextFormField(
    decoration: const InputDecoration(
      labelText: 'Username',
    ),
    keyboardType: TextInputType.text,
    autovalidate: true,
    validator: (_) {
      return !state.isUsernameValid ? 'Invalid Username' : null;
    },
    controller: usernameController,
  );

  void _onUsernameChanged() {
    context.bloc<ProfileBloc>().add(UsernameChanged(username: _usernameController.text));
  }
}

