import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants/color_constants.dart';
import 'bloc/profile/bloc.dart';

class NameEditButton extends StatelessWidget {
  final int userId;

  const NameEditButton({
    Key? key,
    required this.userId,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.edit, size: 20.0, color: ColorsPalette.black),
        onPressed: (){
          showDialog(barrierDismissible: false, context: context,builder: (_) =>
              BlocProvider.value(
                value: context.read<ProfileBloc>(),
                child: NameEditDialog(userId: userId),
              ),
          );
        });
  }
}

class NameEditDialog extends StatefulWidget{

  final int userId;

  const NameEditDialog({Key? key, required this.userId}) : super(key: key);

  @override
  _NameEditDialogState createState() => new _NameEditDialogState();
}

class _NameEditDialogState extends State<NameEditDialog>{
  TextEditingController? _usernameController;
  TextEditingController? _emailController;

  @override
  void initState() {
    super.initState();

    _usernameController = TextEditingController(text: context.read<ProfileBloc>().state.profile!.name);
    _usernameController!.addListener(_onUsernameChanged);

    _emailController = TextEditingController(text: context.read<ProfileBloc>().state.profile!.email);
    _emailController!.addListener(_onEmailChanged);
  }

  @override
  void dispose(){
    _usernameController!.dispose();
    _emailController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
    builder: (context, state) {

      return new AlertDialog(
        title: Text('Update user'),
        actions: <Widget>[
          TextButton(
            child: Text('Done'),
            onPressed: () {
              context.read<ProfileBloc>().add(UserUpdated(userId: widget.userId, username: _usernameController!.text, email: _emailController!.text));
              Navigator.pop(context);
            },
            style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.only(left: 25.0, right: 25.0)),            
            foregroundColor: MaterialStateProperty.all<Color>( ColorsPalette.meditSea)
          ),           
          ),
        ],
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _usernameTextField(_usernameController, state),
              _emailTextField(_emailController, state)
            ],
          ),
        ),
      );
    });
  }

  Widget _usernameTextField(TextEditingController? usernameController, ProfileState state) => new TextFormField(
    decoration: const InputDecoration(
      labelText: 'Username',
    ),
    keyboardType: TextInputType.text,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    validator: (_) {
      return !state.isUsernameValid ? 'Invalid Username' : null;
    },
    controller: usernameController,
  );

  Widget _emailTextField(TextEditingController? emailController, ProfileState state) => new TextFormField(
    decoration: const InputDecoration(
      labelText: 'Email',
    ),
    keyboardType: TextInputType.text,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    validator: (_) {
      return !state.isEmailValid ? 'Invalid Email' : null;
    },
    controller: emailController,
  );

  void _onUsernameChanged() {
    context.read<ProfileBloc>().add(UsernameChanged(username: _usernameController!.text));
  }

  void _onEmailChanged() {
    context.read<ProfileBloc>().add(EmailChanged(email: _emailController!.text));
  }
}

