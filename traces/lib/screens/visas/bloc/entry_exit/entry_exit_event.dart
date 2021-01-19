part of 'entry_exit_bloc.dart';

@immutable
abstract class EntryExitEvent {}

class GetEntryDetails extends EntryExitEvent{
  final Visa visa;
  final EntryExit entry;

  GetEntryDetails(this.entry, this.visa);

  @override
  List<Object> get props => [entry, visa];
}

class CountryChanged extends EntryExitEvent{
  final String country;

  CountryChanged({@required this.country});

  @override
  List<Object> get props => [country];
}

class CityChanged extends EntryExitEvent{
  final String city;

  CityChanged({@required this.city});

  @override
  List<Object> get props => [city];
}
