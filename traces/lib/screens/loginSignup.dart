import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traces/Models/userModel.dart';
import 'package:traces/constants.dart';
import '../colorsPalette.dart';
import '../services/auth.dart';

class LoginSignupPage extends StatefulWidget{
  LoginSignupPage({this.auth, this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  State<StatefulWidget> createState() {
    return new _LoginSignupPageState();
  }
}

class _LoginSignupPageState extends State<LoginSignupPage>{
  final _formKey = GlobalKey<FormState>();
  final _userModel = UserModel();

  String _errorMessage;
  bool _isLoading;
  bool _isLoginForm;
  bool _obscurePassword;

  @override
  void initState() {
    _isLoading = false;
    _errorMessage = "";
    _isLoginForm = true;
    _obscurePassword = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      //resizeToAvoidBottomInset: false,
      //resizeToAvoidBottomPadding: false,
      body: Center(
        child: SingleChildScrollView(
            //reverse: true,
            child: Container(
              margin: const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 20),
              child: Column(
                children: <Widget>[
                  _header(),
                  Container(
                    margin: const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 20),
                    child: Builder(
                        builder: (context) => Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                _isLoginForm ?
                                Text("Login", style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.blueHorizon, fontSize: 30.0)))
                                    : Text("Register", style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.blueHorizon, fontSize: 30.0))),
                                Divider(color: ColorsPalette.blueHorizon),
                                _isLoginForm ? Container(height: 0, width: 0,) : _usernameTextField(),
                                _emailTextField(),
                                _passwordTextField(),
                                _isLoginForm ? _forgotPasswordLink() : Container(height: 0, width: 0,),
                                _showErrorMessage(),
                                _progressIndicator(),
                                _submitButton(),
                                _footerLink()
                              ],
                            )
                        )
                    ),
                  )
                ],
              ),
            )
        )
      )
    );
  }

  Widget _header() => new Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text("Traces", style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.beniukonBronze, fontSize: 60.0))),
    ],
  );

  Widget _progressIndicator() {
    if (_isLoading != null && _isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  void toggleFormMode() {
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  Widget _usernameTextField() => new TextFormField(
    decoration: const InputDecoration(
      labelText: 'Username',
    ),
    keyboardType: TextInputType.text,
    validator: (String value) {
      if(value.isEmpty){
        return 'Please enter Username';
      } else return null;
    },
    onSaved: (String value){
      setState(() =>
      _userModel.username = value.trim()
      );
    },
  );

  Widget _emailTextField() => new TextFormField(
      decoration: const InputDecoration(
        labelText: 'Email',
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if(value.isEmpty){
          return 'Please enter Email';
        } else return null;
      },
      onSaved: (String value){
        setState(() =>
        _userModel.email = value.trim()
        );
      }
  );

  Widget _passwordTextField() => new TextFormField(
      decoration: InputDecoration(
          labelText: 'Password',
          suffixIcon: IconButton(
            icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
            onPressed: (){
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
      ),
      obscureText: _obscurePassword,
      validator: (String value) {
        if(value.isEmpty){
          return 'Please enter Password';
        } else return null;
      },
      onSaved: (String value){
        setState(() =>
        _userModel.password = value.trim()
        );
      },

  );

  Widget _forgotPasswordLink() => new Container(
    margin: const EdgeInsets.only(top: 10),
    child: Align(
        alignment: Alignment.centerRight,
        child: InkWell(
          onTap: (){},
          child: Text(
            "Forgot password?",
            style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.beniukonBronze)),
          ),
        )
    ),
  );

  Widget _submitButton() => new Container(
      margin: EdgeInsets.only(top: 20),
      child: Align(
          child: RaisedButton(
            color: ColorsPalette.blueHorizon,
            textColor: ColorsPalette.grayLight,
            child: _isLoginForm ? Text("Login") : Text("Register"),
            onPressed: (){
              _validateAndSubmit();
            },
          )
      )
  );

  bool _validateAndSave(){
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _validateAndSubmit() async{
    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });
    if(_validateAndSave()){
      String userId = "";
      try{
        if(_isLoginForm){
          userId = await widget.auth.login(_userModel.email, _userModel.password);
          print('Logged in: $userId');
        }else{
          userId = await widget.auth.register(_userModel.email, _userModel.password, _userModel.username);
          await widget.auth.login(_userModel.email, _userModel.password);
          print('Registered: $userId');
        }

        setState(() {
          _isLoading = false;
        });
        if (userId != null && userId.length > 0) {
          widget.loginCallback();
        }
      }
      catch(e){
        setState(() {
          _isLoading = false;
          print(e);
          _errorMessage = e.message != null ? e.message : e;
          _formKey.currentState.reset();
        });
      }
    }else{
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _footerLink() => new Container(
    margin: EdgeInsets.only(top: 30.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Column(
          children: <Widget>[
            _isLoginForm ? Text("Don't have an account?") : Text("Already have an account?")
          ],
        ),
        Column(
          children: <Widget>[
            InkWell(
              onTap: (){
                toggleFormMode();
              },
              child: _isLoginForm ?
              Text("Create new", style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.beniukonBronze)))
                  : Text("Login", style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.beniukonBronze)))
            )
          ],
        )
      ],
    ),
  );

  Widget _showErrorMessage() {
    if (_errorMessage != null && _errorMessage.length > 0) {
      return new Container(
        margin: const EdgeInsets.only(top: 10),
        child: new Text(
          _errorMessage,
          style: TextStyle(
              color: ColorsPalette.redPigment,
              height: 1.0,
              fontWeight: FontWeight.w500),
        ),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

}