import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traces/Models/userModel.dart';
import '../colorsPalette.dart';
import '../services/auth.dart';

enum FormAction {
  LOGIN,
  SIGNUP,
  RESETPASS,
}

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
  bool _obscurePassword;
  bool _resetPassword;

  FormAction _formAction = FormAction.LOGIN;

  @override
  void initState() {
    _isLoading = false;
    _errorMessage = "";
    _formAction = FormAction.LOGIN;
    _obscurePassword = true;
    _resetPassword = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context){

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
                                _getFormHeader(),
                                Divider(color: ColorsPalette.blueHorizon),
                                _formAction == FormAction.SIGNUP ? _usernameTextField() : Container(height: 0, width: 0,),
                                !_resetPassword ?  _emailTextField() : Container(height: 0, width: 0,),
                                _passwordResetInfo(),
                                _formAction == FormAction.RESETPASS ? Container(height: 0, width: 0,) : _passwordTextField(),
                                _formAction == FormAction.LOGIN ? _forgotPasswordLink() : Container(height: 0, width: 0,),
                                _showErrorMessage(),
                                _progressIndicator(),
                                !_resetPassword ? _submitButton() : Container(height: 0, width: 0,),
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

  Widget _getFormHeader(){
    switch(_formAction){
      case FormAction.LOGIN:
        return Text("Login", style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.blueHorizon, fontSize: 30.0)));
      case FormAction.SIGNUP:
        return Text("Register", style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.blueHorizon, fontSize: 30.0)));
      case FormAction.RESETPASS:
        return Text("Reset Password", style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.blueHorizon, fontSize: 30.0)));
    }
    return Text("Login", style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.blueHorizon, fontSize: 30.0)));
  }

  Widget _getButtonText(){
    switch(_formAction){
      case FormAction.LOGIN: return Text("Login");
      case FormAction.SIGNUP: return Text("Register");
      case FormAction.RESETPASS: return Text("Reset Password");
    }
    return Text("Login");
  }

  Widget _progressIndicator() {
    if (_isLoading != null && _isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(height: 0.0,width: 0.0,);
  }

  Widget _passwordResetInfo(){
    if(_formAction == FormAction.RESETPASS && _resetPassword){
      return Center(
        child: Column(children: <Widget>[
          Icon(Icons.check, size: 60.0, color: ColorsPalette.beniukonBronze),
          Text("Check your mailbox before login")
        ],)
      );
    }
    return Container(height: 0.0,width: 0.0,);
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  void toggleFormMode() {
    resetForm();
    setState(() {
      _formAction == FormAction.LOGIN ? _formAction = FormAction.SIGNUP : _formAction = FormAction.LOGIN;
      _resetPassword = false;
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
          onTap: (){
            setState(() {
              _formAction = FormAction.RESETPASS;
            });
          },
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
            child: _getButtonText(),
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
      _resetPassword = false;
    });
    if(_validateAndSave()){
      String userId = "";
      try{
        if(_formAction == FormAction.LOGIN){
          userId = await widget.auth.login(_userModel.email, _userModel.password);
          print('Logged in: $userId');
        }else if (_formAction == FormAction.SIGNUP){
          userId = await widget.auth.register(_userModel.email, _userModel.password, _userModel.username);
          await widget.auth.login(_userModel.email, _userModel.password);
          print('Registered: $userId');
        }else{
          await widget.auth.resetPassword(_userModel.email);
          setState(() {
            _resetPassword = true;
          });
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
          _resetPassword = false;
          print(e);
          _errorMessage = e.message != null ? e.message : e;
          _formKey.currentState.reset();
        });
      }
    }else{
      setState(() {
        _resetPassword = false;
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
            _formAction == FormAction.LOGIN ? Text("Don't have an account?") : Text("Already have an account?")
          ],
        ),
        Column(
          children: <Widget>[
            InkWell(
              onTap: (){
                toggleFormMode();
              },
              child: _formAction == FormAction.LOGIN ?
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