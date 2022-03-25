import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/constants/route_constants.dart';
import 'package:traces/utils/style/styles.dart';


import '../../constants/color_constants.dart';
import 'bloc/bloc.dart';
class LoginSignupForm extends StatefulWidget{
  
  LoginSignupForm();    

  State<LoginSignupForm> createState() => _LoginSignupFormState();
}

class _LoginSignupFormState extends State<LoginSignupForm>{
  final TextEditingController _emailController = TextEditingController();  
  final _formKey = GlobalKey<FormState>();

  String? _errorMessage;
  bool? _isLoading;

  late LoginSignupBloc _loginSignupBloc;

  @override
  void initState() {
    super.initState();
    _loginSignupBloc = BlocProvider.of<LoginSignupBloc>(context);
    _emailController.addListener(_onEmailChanged);    
    _errorMessage = "";
  }

  @override
  void dispose(){  
    _emailController.dispose();   
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {    

    return BlocListener<LoginSignupBloc, LoginState>(
      listener: (context, state){
        if(state is LoginStateError){
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                duration: Duration(days: 1),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      
                      width: 250,
                      child: Text(
                        state.error, style:quicksandStyle(color: ColorsPalette.lynxWhite),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                      ),
                    ),
                    Icon(Icons.error, color: ColorsPalette.white)],
                ),
                backgroundColor: ColorsPalette.redPigment,
              ),
            );
        }
        if(state is LoginStateLoading){
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                duration: Duration(days: 1),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(ColorsPalette.lynxWhite),
                    ),
                  ],
                ),
                backgroundColor: ColorsPalette.juicyBlue,
              ),
            );
        }
        if(state is LoginStateSuccess){
          Navigator.pushNamed(context, otpVerificationRoute, arguments: state.email);
          //BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn(state.user));
        }        
      },
      child: BlocBuilder<LoginSignupBloc, LoginState>(
        builder: (context, state){
          return Center(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      //height: MediaQuery.of(context).size.height * 0.2,
                      child: Align(
                        alignment: Alignment.center,
                        child: _header(),
                      ),
                    ),                    
                    Container(
                      margin: const EdgeInsets.only(top: 80, left: 20, right: 20, bottom: 20),
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: Builder(
                        builder: (context) => Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              Column(children: [
                                Text("Email", style: quicksandStyle(color: ColorsPalette.juicyBlue, fontSize: 30.0)),
                                _emailTextField(_emailController, state),
                                _showErrorMessage(),
                                _progressIndicator(),
                                _submitButton(state),
                              ],)                            
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
      Text("Traces", style: quicksandStyle(color: ColorsPalette.juicyOrange, fontSize: 60.0)),
    ],
  );

  Widget _submitButton(LoginState state) => new Container(
      margin: EdgeInsets.only(top: 20),
      child: Align(
      child: OutlinedButton(
        child: Text("Sign In", style: TextStyle(color: ColorsPalette.white),),
        onPressed: (){
          _validateAndSubmit(state);
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(ColorsPalette.juicyOrange)        
        ),
      )
    )
  );

  bool _validateAndSave(){
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _validateAndSubmit(LoginState state) async{
    FocusScope.of(context).unfocus();

    if(_validateAndSave()){
      _loginSignupBloc.add(
            SubmittedLogin(
              email: _emailController.text,
              //password: _passwordController.text,
            ),
          );
    }
  }

  Widget _emailTextField(TextEditingController emailController, LoginState state) => new TextFormField(
      decoration: const InputDecoration(
        //labelText: 'Email',        
        hintText: "username@company.com"
      ),
      textAlign: TextAlign.center,
      keyboardType: TextInputType.emailAddress,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (_) {
        return (state is LoginStateEdit && !state.isEmailValid) ? 'Invalid Email' : null;
      },
      controller: emailController
  );

  Widget _showErrorMessage() {
    print(_errorMessage);
    if (_errorMessage != null && _errorMessage!.length > 0) {
      return new Container(
        margin: const EdgeInsets.only(top: 10),
        child: new Text(
          _errorMessage!,
          style: TextStyle(
              color: ColorsPalette.redPigment,
              height: 1.0,
              fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
        ),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget _progressIndicator() {
    if (_isLoading != null && _isLoading!) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(height: 0.0,width: 0.0,);
  }

  void _onEmailChanged() {
    _loginSignupBloc.add(
      EmailChanged(email: _emailController.text)
    );
  }
}