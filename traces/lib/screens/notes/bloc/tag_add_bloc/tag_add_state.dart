import 'package:equatable/equatable.dart';

abstract class TagAddState extends Equatable {
  const TagAddState();
}

class InitialTagAddState extends TagAddState {
  @override
  List<Object> get props => [];
}
