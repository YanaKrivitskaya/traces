import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../../utils/api/customException.dart';
import '../../../model/booking.model.dart';
import '../../../model/expense.model.dart';
import '../../../repository/api_bookings_repository.dart';

part 'bookingcreate_event.dart';
part 'bookingcreate_state.dart';

class BookingCreateBloc extends Bloc<BookingCreateEvent, BookingCreateState> {
  final ApiBookingsRepository _bookingsRepository;

  BookingCreateBloc() : 
  _bookingsRepository = new ApiBookingsRepository(),
  super(BookingCreateInitial(null));

  @override
  Stream<BookingCreateState> mapEventToState(
    BookingCreateEvent event,
  ) async* {
    if (event is NewBookingMode) {
      yield* _mapNewBookingModeToState(event);
    } else if (event is DateRangeUpdated) {
      yield* _mapDateUpdatedToState(event);
    } else if (event is BookingSubmitted) {
      yield* _mapBookingSubmittedToState(event);
    } else if (event is ExpenseUpdated) {
      yield* _mapExpenseUpdatedToState(event);
    }
  }

  Stream<BookingCreateState> _mapNewBookingModeToState(NewBookingMode event) async* {
    yield BookingCreateEdit(new Booking(), false);
  }

  Stream<BookingCreateState> _mapDateUpdatedToState(DateRangeUpdated event) async* {
    
    Booking booking = state.booking ?? new Booking();

    Booking updBooking = booking.copyWith(entryDate: event.startDate, exitDate: event.endDate);

    yield BookingCreateEdit(updBooking, false);
  }

  Stream<BookingCreateState> _mapExpenseUpdatedToState(ExpenseUpdated event) async* {
    
    Booking booking = state.booking ?? new Booking();

    Booking updBooking = booking.copyWith(expense: event.expense);

    yield BookingCreateEdit(updBooking, false);
  }

  Stream<BookingCreateState> _mapBookingSubmittedToState(BookingSubmitted event) async* {
    yield BookingCreateEdit(event.booking, true);
    print(event.booking.toString());

    try{
      Booking booking = await _bookingsRepository.createBooking(event.booking!, event.expense, event.tripId);
      yield BookingCreateSuccess(booking);
    }on CustomException catch(e){
        yield BookingCreateError(event.booking, e.toString());
    }   
  }
}
