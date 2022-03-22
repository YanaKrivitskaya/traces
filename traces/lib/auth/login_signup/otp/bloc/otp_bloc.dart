import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:traces/auth/model/account.model.dart';

import '../../../../utils/api/customException.dart';
import '../../../repository/api_user_repository.dart';

part 'otp_event.dart';
part 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  ApiUserRepository _apiUserRepository;
  
  OtpBloc() : 
  _apiUserRepository = new ApiUserRepository(),
  super(OtpInitial()) {
    on<OtpSubmitted>(_verifyOtp);
    on<ResendTriggered>(_resendOtp);
  }

  void _verifyOtp(OtpSubmitted event, Emitter<OtpState> emit)async{
    emit(OtpLoadingState(event.otp));
    //LoginModel loginModel = LoginModel(email: event.email, password: event.password);
    try{
      var user = await _apiUserRepository.verifyOtp(event.otp, event.email);
      return emit(OtpSuccessState(event.otp, user));
    } on CustomException catch(e){      
      return emit (OtpFailureState(event.otp, e.toString()));
    }
  } 

  void _resendOtp(ResendTriggered event, Emitter<OtpState> emit)async{
    emit(OtpLoadingState(null));    
    try{
      await _apiUserRepository.signInWithEmail(event.email);
      return emit(OtpEditState(null));
    } on CustomException catch(e){      
      return emit (OtpFailureState(null, e.toString()));
    }
  } 
}
