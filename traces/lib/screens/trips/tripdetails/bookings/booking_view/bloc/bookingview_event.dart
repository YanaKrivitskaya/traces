part of 'bookingview_bloc.dart';

@immutable
abstract class BookingViewEvent {}

class GetBookingDetails extends BookingViewEvent {
  final int bookingId;

  GetBookingDetails(this.bookingId);

  List<Object> get props => [bookingId];
}
