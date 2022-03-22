import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../utils/api/customException.dart';
import '../../../utils/helpers/validation_helper.dart';
import '../../model/account.model.dart';
import '../../model/login.model.dart';
import '../../repository/api_user_repository.dart';
import 'bloc.dart';

class LoginSignupBloc extends Bloc<LoginSignupEvent, LoginState> { 
  ApiUserRepository _apiUserRepository;

  /// Define a custom `EventTransformer`
  EventTransformer<LoginSignupEvent> debounce<LoginSignupEvent>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }

  LoginSignupBloc():      
      _apiUserRepository = new ApiUserRepository(),
      super(LoginStateInitial(null)){
        /// Apply the custom `EventTransformer` to the `EventHandler`
        on<EmailChanged>(_onEmailChanged, transformer: debounce(Duration(milliseconds: 500)));       
        on<SubmittedLogin>(_sendOtptoEmail);       
      }

  void _onEmailChanged(EmailChanged event, Emitter<LoginState> emit) async{
    return emit(LoginStateEdit(
      event.email, 
      Validator.isValidEmail(event.email)
    ));
  }

  void _sendOtptoEmail(SubmittedLogin event, Emitter<LoginState> emit)async{
    emit(LoginStateLoading(event.email));
    //LoginModel loginModel = LoginModel(email: event.email, password: event.password);
    try{
      await _apiUserRepository.signInWithEmail(event.email);
      return emit(LoginStateSuccess(event.email));
    } on CustomException catch(e){      
      return emit (LoginStateError(event.email, e.toString()));
    }
  } 
}
