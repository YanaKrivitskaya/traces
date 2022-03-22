part of 'otp_bloc.dart';

@immutable
abstract class OtpEvent {
  const OtpEvent();

  List<Object> get props => [];
}

class ResendTriggered extends OtpEvent{
   final String email;

  ResendTriggered(this.email);

  List<Object> get props => [email];
}

class OtpSubmitted extends OtpEvent{
  final String otp;
  final String email;

  OtpSubmitted(this.otp, this.email);

  List<Object> get props => [otp, email];
}
