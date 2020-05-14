import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class SimpleBlocDelegate extends BlocDelegate{
  @override
  void onEvent(Bloc bloc, Object event) {
    print(event);
    super.onEvent(bloc, event);
  }

  @override
  onError(Bloc bloc, Object error, StackTrace stackTrace){
    super.onError(bloc, error, stackTrace);
    print(error);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print(transition);
    super.onTransition(bloc, transition);
  }
}