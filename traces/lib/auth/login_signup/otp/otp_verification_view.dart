import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/auth/login_signup/otp/bloc/otp_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:otp_timer_button/otp_timer_button.dart';
import 'package:traces/main.dart';

import '../../../constants/color_constants.dart';
import '../../../utils/style/styles.dart';
import '../../auth_bloc/bloc.dart';

class OtpVerificationView extends StatefulWidget{  
  final String email;
  OtpVerificationView(this.email);

  @override
  _OtpVerificationViewState createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView>{

  final pinController = TextEditingController();
  final focusNode = FocusNode();

  OtpTimerButtonController otpController = OtpTimerButtonController();

  // declare as global
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();   
    pinController.addListener(_onPinChanged);    
  }

  @override
  void dispose(){
    pinController.dispose();    
    focusNode.dispose();    
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 60,
      height: 64,
      textStyle: quicksandStyle(fontSize: 20, color: ColorsPalette.black),
      decoration: BoxDecoration(
        color: ColorsPalette.lynxWhite,
        borderRadius: BorderRadius.circular(24),
      ),
    );

    final cursor = Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 21,
        height: 1,
        margin: EdgeInsets.only(bottom: sizerHeightsm),
        decoration: BoxDecoration(
          color: Color.fromRGBO(137, 146, 160, 1),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      body: BlocListener<OtpBloc, OtpState>(
        listener: (context, state){
          if(state is OtpFailureState){
          globalScaffoldMessenger.currentState!
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
                    Icon(Icons.error)],
                ),
                backgroundColor: ColorsPalette.redPigment,
              ),
            );
        }
        if(state is OtpLoadingState){
          globalScaffoldMessenger.currentState!
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
                backgroundColor: ColorsPalette.juicyYellow,
                duration: Duration(seconds: 2),
              ),
            );
        }
        if(state is OtpEditState){
          pinController.text = '';
        }
        if(state is OtpSuccessState){         
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn(state.user));
          Navigator.pop(context);
        } 
        },
        child: BlocBuilder<OtpBloc, OtpState>(
          builder: (context, state){
            return Center(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(viewPadding),
                child: Column(
                  children: <Widget>[                                    
                    Container(
                      margin: EdgeInsets.only(top: formTopPadding, left: viewPadding, right: viewPadding, bottom: viewPadding),
                      height: loginFormHeight,
                      child: _pinForm(pinController, defaultPinTheme, cursor, widget.email, otpController),
                    )
                  ],
                ),
              ),
            )
          );
          }
        ),
      )
    );
  }

  void _onPinChanged() {
    var pin = pinController.text;
    if(pin.length == 4){
      BlocProvider.of<OtpBloc>(context).add(OtpSubmitted(pin, widget.email));
    }    
  }

  Widget _pinForm(TextEditingController pinController, PinTheme defaultTheme, Widget cursor, String email, OtpTimerButtonController otpController) => new Container(
    child: Column(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Verification',
              style: quicksandStyle(fontSize: smallHeaderFontSize, weight: FontWeight.w700, color: ColorsPalette.juicyBlue ),
            ),
            SizedBox(height: sizerHeightlg),
            Text(
              'Enter the code sent to the email',
              style: quicksandStyle(fontSize: fontSizesm, color: ColorsPalette.black),
            ),
            Text(
              '$email',
              style: quicksandStyle(fontSize: fontSizesm, color: ColorsPalette.juicyBlue),
            ),
            SizedBox(height: sizerHeightlg),
            InkWell(
              child: Text("Wrong email?", style: quicksandStyle(
              fontSize: fontSize,
              color: ColorsPalette.black,
              decoration: TextDecoration.underline
            )),
              onTap: () => Navigator.pop(context),
            ),
            SizedBox(height: formBottomPadding)
          ],
        ),
        SizedBox(height: sizerHeightsm),
        Pinput(
          length: 4,
          controller: pinController,
          focusNode: focusNode,
          defaultPinTheme: defaultTheme,
          focusedPinTheme: defaultTheme.copyWith(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.05999999865889549),
                  offset: Offset(0, 3),
                  blurRadius: 16,
                )
              ],
            ),
          ),
          showCursor: true,
          cursor: cursor,
        ),
        SizedBox(height: formBottomPadding),
          Text(
            'Didn’t receive a code?',
            style: quicksandStyle(
              fontSize: fontSizesm,
              color: ColorsPalette.juicyBlue,
            ),
          ),
          OtpTimerButton(
            controller: otpController,
            onPressed: () {   
              otpController.startTimer();           
              BlocProvider.of<OtpBloc>(context).add(ResendTriggered(widget.email));
            },
            text: Text('Resend'),
            duration: 60,
            backgroundColor: ColorsPalette.juicyBlue,
          ),
      ],
    ),
  );

}
