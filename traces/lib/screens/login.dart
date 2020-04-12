import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traces/Models/loginModel.dart';
import 'package:traces/constants.dart';
import '../colorsPalette.dart';

class LoginPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return new _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage>{
  final _formKey = GlobalKey<FormState>();
  final _loginModel = LoginModel();

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
                            "Login", style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.blueHorizon, fontSize: 30.0))
                        ),
                        Divider(
                            color: ColorsPalette.blueHorizon
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            /*icon: Icon(Icons.email),*/
                            //hintText: 'What do people call you?',
                            labelText: 'Email',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (String value) {
                            if(value.isEmpty){
                              return 'Please enter Email';
                            }
                          },
                          onSaved: (String value){
                            setState(() =>
                            _loginModel.email = value
                            );
                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            /*icon: Icon(Icons.email),*/
                            //hintText: 'What do people call you?',
                            labelText: 'Password',
                          ),
                          obscureText: true,
                          validator: (String value) {
                            if(value.isEmpty){
                              return 'Please enter Password';
                            }
                          },
                          onSaved: (String value){
                            setState(() =>
                            _loginModel.password = value
                            );
                          },
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: (){

                            },
                              child: Text(
                                "Forgot password?",
                                style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.beniukonBronze)),
                              ),
                            )
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: RaisedButton(
                              color: ColorsPalette.blueHorizon,
                              textColor: ColorsPalette.grayLight,
                              child: Text("Login"),
                              onPressed: (){
                                if (_formKey.currentState.validate()) {
                                  //_formKey.currentState.save();
                                }
                              },
                          )
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 30.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text(
                                    "Don't have an account?"
                                  )
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  InkWell(
                                    onTap: (){
                                      Navigator.pushNamed(context, registerRoute);
                                    },
                                    child: Text(
                                      "Create new",
                                      style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.beniukonBronze)),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        )
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
}