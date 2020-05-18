import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class TagAddBloc extends Bloc<TagAddEvent, TagAddState> {
  @override
  TagAddState get initialState => InitialTagAddState();

  @override
  Stream<TagAddState> mapEventToState(
    TagAddEvent event,
  ) async* {
    // TODO: Add Logic
  }
}
