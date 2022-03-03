part of 'bookingcreate_bloc.dart';

abstract class BookingCreateState {
  Booking? booking;

  BookingCreateState(this.booking);

  @override
  List<Object?> get props => [booking];
}

class BookingCreateInitial extends BookingCreateState {
  BookingCreateInitial(Booking? booking) : super(booking);
}

class BookingCreateEdit extends BookingCreateState {
  final bool loading;

  BookingCreateEdit(Booking? booking, this.loading) : super(booking);

  @override
  List<Object?> get props => [booking, loading];
}

class BookingCreateError extends BookingCreateState {
  final String error;

  BookingCreateError(Booking? booking, this.error) : super(booking);

  @override
  List<Object?> get props => [booking, error];
}

class BookingCreateSuccess extends BookingCreateState {

  BookingCreateSuccess(Booking? booking) : super(booking);

  @override
  List<Object?> get props => [booking];
}
