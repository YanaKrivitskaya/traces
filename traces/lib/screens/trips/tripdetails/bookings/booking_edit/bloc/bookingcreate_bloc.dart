
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:traces/screens/trips/model/booking.model.dart';
import 'package:traces/screens/trips/model/expense.model.dart';
import 'package:traces/screens/trips/repository/api_bookings_repository.dart';
import 'package:traces/utils/api/customException.dart';

part 'bookingcreate_event.dart';
part 'bookingcreate_state.dart';

class BookingCreateBloc extends Bloc<BookingCreateEvent, BookingCreateState> {
  final ApiBookingsRepository _bookingsRepository;

  BookingCreateBloc() : 
  _bookingsRepository = new ApiBookingsRepository(),
  super(BookingCreateInitial(null)){
    on<NewBookingMode>((event, emit) => emit(BookingCreateEdit(new Booking(entryDate: event.date), false)));
    on<EditBookingMode>((event, emit) => emit(BookingCreateEdit(event.booking, false)));
    on<DateRangeUpdated>(_onDateRangeUpdated);
    on<ExpenseUpdated>(_onExpenseUpdated);
    on<BookingSubmitted>(_onBookingSubmitted);
  }

  void _onDateRangeUpdated(DateRangeUpdated event, Emitter<BookingCreateState> emit) async{
    Booking booking = state.booking ?? new Booking();

    Booking updBooking = booking.copyWith(entryDate: event.startDate, exitDate: event.endDate);

    emit(BookingCreateEdit(updBooking, false));
  } 

  void _onExpenseUpdated(ExpenseUpdated event, Emitter<BookingCreateState> emit) async{
    Booking booking = state.booking ?? new Booking();

    Booking updBooking = booking.copyWith(expense: event.expense);

    emit(BookingCreateEdit(updBooking, false));
  } 

  void _onBookingSubmitted(BookingSubmitted event, Emitter<BookingCreateState> emit) async{
    emit(BookingCreateEdit(event.booking, true));
    print(event.booking.toString());

    try{
      Booking booking;
      if(event.booking!.id != null){
        booking = await _bookingsRepository.updateBooking(event.booking!, event.expense, event.tripId);
      }else{
        booking = await _bookingsRepository.createBooking(event.booking!, event.expense, event.tripId);
      }      
      emit(BookingCreateSuccess(booking));
    }on CustomException catch(e){
      emit(BookingCreateError(event.booking, e.toString()));
    }   
  }
}
