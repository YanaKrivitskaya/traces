import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../auth/bloc.dart';
import '../colorsPalette.dart';
import '../shared/state_types.dart';
import 'bloc/bloc.dart';
import 'form_types.dart';

class LoginSignupForm extends StatefulWidget{
  
  LoginSignupForm();    

  State<LoginSignupForm> createState() => _LoginSignupFormState();
}

class _LoginSignupFormState extends State<LoginSignupForm>{
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _errorMessage;
  bool _isLoading;
  bool _obscurePassword;

  String linkText = "Don't have an account?";
  String linkButtonText = "Create new";
  String actionText = "Login";

  LoginSignupBloc _loginSignupBloc;

  bool get loginIsPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool get registerIsPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty && _usernameController.text.isNotEmpty;

  bool isButtonEnabled(LoginSignupState state){
    bool isLoginFormValid = state.form == FormMode.Login && state.isLoginFormValid && (state.status != StateStatus.Loading) && loginIsPopulated;
    bool isRegisterFormValid = state.form == FormMode.Register && state.isSignupFormValid && (state.status != StateStatus.Loading) && registerIsPopulated;
    bool isResetFormValid = state.form == FormMode.Reset && state.isEmailValid && _emailController.text.isNotEmpty;
    return  isLoginFormValid || isRegisterFormValid || isResetFormValid;
  }

  @override
  void initState() {
    super.initState();
    _loginSignupBloc = BlocProvider.of<LoginSignupBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
    _usernameController.addListener(_onUsernameChanged);
    _errorMessage = "";
    _obscurePassword = true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginSignupBloc, LoginSignupState>(
      listener: (context, state){
        if(state.status == StateStatus.Error){
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 250,
                      child: Text(
                        state.errorMessage, style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.lynxWhite)),
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
        if(state.status == StateStatus.Loading){
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(ColorsPalette.lynxWhite),
                    ),
                  ],
                ),
                backgroundColor: ColorsPalette.blueHorizon,
              ),
            );
        }
        if(state.status == StateStatus.Success){
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
        }
        switch(state.form){
          case FormMode.Login:{
            this.linkText = "Don't have an account?";
            this.linkButtonText = "Create new";
            this.actionText = "Login";
            break;
          }
          case FormMode.Register:{
            this.linkText = "Already have an account?";
            this.linkButtonText = "Login";
            this.actionText = "Register";
            break;
          }
          case FormMode.Reset:{
            this.linkText = "Already have an account?";
            this.linkButtonText = "Login";
            this.actionText = "Reset password";
            break;
          }
        }
        /*if(state.form == FormMode.Login){
          this.linkText = "Don't have an account?";
          this.linkButtonText = "Create new";
          this.actionText = "Login";
        }
        if(state.isRegisterForm){
          this.linkText = "Already have an account?";
          this.linkButtonText = "Login";
          this.actionText = "Register";
        }
        if(state.isResetForm){
          this.linkText = "Already have an account?";
          this.linkButtonText = "Login";
          this.actionText = "Reset password";
        }*/

      },
      child: BlocBuilder<LoginSignupBloc, LoginSignupState>(
        builder: (context, state){
          return Center(
            child: SingleChildScrollView(
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
                              Text(this.actionText, style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.blueHorizon, fontSize: 30.0))),
                              Divider(color: ColorsPalette.blueHorizon),
                              state.form == FormMode.Register ? _usernameTextField(_usernameController, state) : Container(height: 0, width: 0,),
                              !state.isPasswordReseted ?  _emailTextField(_emailController, state) : Container(height: 0, width: 0,),
                              _passwordResetInfo(state),
                              state.form == FormMode.Login || state.form == FormMode.Register ? _passwordTextField(_passwordController, state) : Container(height: 0, width: 0,),
                              state.form == FormMode.Login ? _forgotPasswordLink() : Container(height: 0, width: 0,),
                              _showErrorMessage(),
                              _progressIndicator(),
                              !state.isPasswordReseted ? _submitButton(state) : Container(height: 0, width: 0,),
                              _footerLink(state)
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          );
        }
      ),
    );
  }

  Widget _header() => new Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text("Traces", style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.beniukonBronze, fontSize: 60.0))),
    ],
  );

  Widget _submitButton(LoginSignupState state) => new Container(
      margin: EdgeInsets.only(top: 20),
      child: Align(
          child: RaisedButton(
            color: isButtonEnabled(state)
                ? ColorsPalette.blueHorizon : ColorsPalette.blueGrey,
            textColor: ColorsPalette.lynxWhite,
            child: Text(this.actionText),
            onPressed: () =>
            isButtonEnabled(state)
                  ? _validateAndSubmit(state)
                  : null
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

  void _validateAndSubmit(LoginSignupState state) async{

    if(_validateAndSave()){
      switch(state.form){
        case FormMode.Login:{
          _loginSignupBloc.add(
            SubmittedLogin(
              email: _emailController.text,
              password: _passwordController.text,
            ),
          );
          break;
        }
        case FormMode.Register:{
          _loginSignupBloc.add(
              SubmittedSignup(
                  email: _emailController.text,
                  password: _passwordController.text,
                  username: _usernameController.text
              )
          );
          break;
        }
        case FormMode.Reset:{
          _loginSignupBloc.add(
            SubmittedReset(
                email: _emailController.text
            ),
          );
          break;
        }
      }
      /*if(state.form == FormMode.Login){
        _loginSignupBloc.add(
          SubmittedLogin(
            email: _emailController.text,
            password: _passwordController.text,
          ),
        );
      }else if (state.isRegisterForm){
        _loginSignupBloc.add(
            SubmittedSignup(
                email: _emailController.text,
                password: _passwordController.text,
                username: _usernameController.text
            )
        );
      }else if(state.isResetForm){
        _loginSignupBloc.add(
          SubmittedReset(
              email: _emailController.text
          ),
        );
      }*/
    }
  }

  Widget _emailTextField(TextEditingController emailController, LoginSignupState state) => new TextFormField(
      decoration: const InputDecoration(
        labelText: 'Email',
      ),
      keyboardType: TextInputType.emailAddress,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (_) {
        return !state.isEmailValid ? 'Invalid Email' : null;
      },
      controller: emailController
  );

  Widget _usernameTextField(TextEditingController usernameController, LoginSignupState state) => new TextFormField(
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

  Widget _passwordTextField(TextEditingController passwordController, LoginSignupState state) => new TextFormField(
    decoration: InputDecoration(
      labelText: 'Password',
      suffixIcon: IconButton(
        icon: FaIcon(_obscurePassword ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye),
        onPressed: (){
          setState(() {
            _obscurePassword = !_obscurePassword;
          });
        },
      ),
    ),
    obscureText: _obscurePassword,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    validator: (_) {
    return !state.isPasswordValid ? 'Invalid Password' : null;
    },
    controller: passwordController,
  );

  Widget _forgotPasswordLink() => new Container(
    margin: const EdgeInsets.only(top: 10),
    child: Align(
        alignment: Alignment.centerRight,
        child: InkWell(
          onTap: (){
            _loginSignupBloc.add(ResetPagePressed());
          },
          child: Text(
            "Forgot password?",
            style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.beniukonBronze)),
          ),
        )
    ),
  );

  Widget _passwordResetInfo(LoginSignupState state){
    if(state.isPasswordReseted){
      return Center(
          child: Column(children: <Widget>[
            Icon(Icons.check, size: 60.0, color: ColorsPalette.beniukonBronze),
            Text("Check your mailbox before login")
          ],)
      );
    }
    return Container(height: 0.0,width: 0.0,);
  }

  Widget _showErrorMessage() {
    print(_errorMessage);
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

  Widget _footerLink(LoginSignupState state) => new Container(
    margin: EdgeInsets.only(top: 30.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Column(
          children: <Widget>[
            Text(this.linkText),
          ],
        ),
        Column(
          children: <Widget>[
            InkWell(
                onTap: (){
                  toggleFormMode(state);
                },
                child:
                Text(this.linkButtonText, style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.beniukonBronze)) )
            )
          ],
        )
      ],
    ),
  );

  void toggleFormMode(LoginSignupState state) {
    resetForm();
    state.form == FormMode.Login ? _loginSignupBloc.add(RegisterPagePressed()):
      _loginSignupBloc.add(LoginPagePressed());
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  Widget _progressIndicator() {
    if (_isLoading != null && _isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(height: 0.0,width: 0.0,);
  }

  void _onEmailChanged() {
    _loginSignupBloc.add(
      EmailChanged(email: _emailController.text)
    );
  }

  void _onPasswordChanged() {
    _loginSignupBloc.add(
      PasswordChanged(password: _passwordController.text),
    );
  }

  void _onUsernameChanged() {
    _loginSignupBloc.add(
      UsernameChanged(username: _usernameController.text),
    );
  }
}