import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traces/Models/loginModel.dart';
import 'package:traces/constants.dart';
import '../colorsPalette.dart';

class RegisterPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return new _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage>{
  final _formKey = GlobalKey<FormState>();
  final _registerModel = RegisterModel();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
          child: Container(
            margin: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                        "Traces", style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.beniukonBronze, fontSize: 60.0))
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
                  child: Builder(
                      builder: (context) => Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              Text(
                                  "Register", style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.blueHorizon, fontSize: 30.0))
                              ),
                              Divider(
                                  color: ColorsPalette.blueHorizon
                              ),
                              _formTextField('Username', TextInputType.text, _registerModel.username, false),
                              _formTextField('Email', TextInputType.emailAddress, _registerModel.email, false),
                              _formTextField('Password', TextInputType.text, _registerModel.password, true),
                              _registerButton(),
                              _footerLoginLink(),
                            ],
                          )
                      )
                  ),
                )
              ],
            ),
          )
      ),
    );
  }

  Widget _registerButton() => new Container(
      margin: EdgeInsets.only(top: 20),
      child: RaisedButton(
        color: ColorsPalette.blueHorizon,
        textColor: ColorsPalette.grayLight,
        child: Text("Signup"),
        onPressed: (){
          final form = _formKey.currentState;
          if (form.validate()) {
            //_formKey.currentState.save();
            form.save();
          }
        },
      )
  );

  Widget _formTextField(String labelValue, TextInputType textInputValue, var saveValue, bool obscureText) => new TextFormField(
    decoration: InputDecoration(
      labelText: labelValue,
    ),
    keyboardType: textInputValue,
    obscureText: obscureText,
    validator: (String value){
      if(value.isEmpty){
        return 'Please enter ' +  labelValue;
      } else return null;
    },
    onSaved: (String value){
      setState(() =>
      saveValue = value
      );
    },
  );

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
      _registerModel.email = value
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
        _registerModel.email = value
        );
      }
  );

  Widget _passwordTextField() => new TextFormField(
      decoration: const InputDecoration(
        labelText: 'Password',
      ),
      obscureText: true,
      validator: (String value) {
        if(value.isEmpty){
          return 'Please enter Password';
        } else return null;
      },
      onSaved: (String value){
        setState(() =>
        _registerModel.password = value
        );
      }
  );

  Widget _footerLoginLink() => new Container(
    margin: EdgeInsets.only(top: 30.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Column(
          children: <Widget>[
            Text(
                "Already have an account?"
            )
          ],
        ),
        Column(
          children: <Widget>[
            InkWell(
              onTap: (){
                Navigator.pushNamed(context, loginRoute);
              },
              child: Text(
                "Login",
                style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.beniukonBronze)),
              ),
            )
          ],
        )
      ],
    ),
  );
}