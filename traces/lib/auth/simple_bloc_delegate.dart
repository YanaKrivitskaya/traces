import 'package:bloc/bloc.dart';

class SimpleBlocDelegate extends BlocObserver{
  @override
  void onEvent(Bloc bloc, Object event) {
    print(event);
    super.onEvent(bloc, event);
  }

  @override
  void onError(BlocBase  bloc, Object error, StackTrace stackTrace){
    super.onError(bloc, error, stackTrace);
    print(error);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print(transition);
    super.onTransition(bloc, transition);
  }
}