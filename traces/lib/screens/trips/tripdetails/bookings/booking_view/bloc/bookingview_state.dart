part of 'bookingview_bloc.dart';

abstract class BookingViewState {
  Booking? booking;

  BookingViewState(this.booking);

  @override
  List<Object?> get props => [booking];
}

class BookingViewInitial extends BookingViewState {
  BookingViewInitial(Booking? booking) : super(booking);
}

class BookingViewLoading extends BookingViewState {
  BookingViewLoading(Booking? booking) : super(booking);
}

class BookingViewSuccess extends BookingViewState {

  BookingViewSuccess(Booking? booking) : super(booking);

  @override
  List<Object?> get props => [booking];
}

class BookingViewError extends BookingViewState {
  final String error;

  BookingViewError(Booking? booking, this.error) : super(booking);

  @override
  List<Object?> get props => [booking, error];
}
