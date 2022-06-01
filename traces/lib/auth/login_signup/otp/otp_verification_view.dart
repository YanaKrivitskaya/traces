import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/auth/login_signup/otp/bloc/otp_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:otp_timer_button/otp_timer_button.dart';

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

  @override
  void initState() {
    super.initState();   
    pinController.addListener(_onPinChanged);    
  }

  @override
  void dispose(){
    pinController.dispose();    
    focusNode.dispose();
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
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
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Color.fromRGBO(137, 146, 160, 1),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );

    return Scaffold(
      body: BlocListener<OtpBloc, OtpState>(
        listener: (context, state){
          if(state is OtpFailureState){
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
                    Icon(Icons.error)],
                ),
                backgroundColor: ColorsPalette.redPigment,
              ),
            );
        }
        if(state is OtpLoadingState){
          ScaffoldMessenger.of(context)
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
        if(state is OtpSuccessState){         
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn(state.user));
          Navigator.pop(context);
        } 
        },
        child: BlocBuilder<OtpBloc, OtpState>(
          builder: (context, state){
            return Center(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[                                    
                    Container(
                      margin: const EdgeInsets.only(top: 80, left: 20, right: 20, bottom: 20),
                      height: MediaQuery.of(context).size.height * 0.6,
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
              style: quicksandStyle(fontSize: 24, weight: FontWeight.w700, color: ColorsPalette.juicyBlue ),
            ),
            const SizedBox(height: 24),
            Text(
              'Enter the code sent to the email',
              style: quicksandStyle(fontSize: 16, color: ColorsPalette.black),
            ),
            const SizedBox(height: 16),
            Text(
              '$email',
              style: quicksandStyle(fontSize: 16, color: ColorsPalette.juicyBlue),
            ),
            InkWell(
              child: Text("Wrong email?", style: quicksandStyle(
              fontSize: 16,
              color: ColorsPalette.black,
              decoration: TextDecoration.underline
            )),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 64)
          ],
        ),
        SizedBox(height: 20.0),
        Pinput(
          length: 4,
          controller: pinController,
          focusNode: focusNode,
          defaultPinTheme: defaultTheme,
          separator: SizedBox(width: 16),
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
        const SizedBox(height: 44),
          Text(
            'Didn’t receive a code?',
            style: quicksandStyle(
              fontSize: 16,
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
