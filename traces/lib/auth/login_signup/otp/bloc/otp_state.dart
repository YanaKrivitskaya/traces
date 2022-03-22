part of 'otp_bloc.dart';

@immutable
abstract class OtpState {}

class OtpInitial extends OtpState {}

class OtpEditState extends OtpState{
  final String? otp;

  OtpEditState(this.otp);

  List<Object?> get props => [otp];
}

class OtpLoadingState extends OtpState {
  final String? otp;

  OtpLoadingState(this.otp);

  List<Object?> get props => [otp];
}

class OtpSuccessState extends OtpState {
  final String otp;
  final Account user;

  OtpSuccessState(this.otp, this.user);

  List<Object> get props => [otp, user];
}

class OtpFailureState extends OtpState {
  final String? otp;
  final String error;

  OtpFailureState(this.otp, this.error);

  List<Object?> get props => [otp, error];
}
