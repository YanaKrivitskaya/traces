import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:traces/screens/trips/model/booking.model.dart';
import 'package:traces/screens/trips/repository/api_bookings_repository.dart';
import 'package:traces/utils/api/customException.dart';

part 'bookingview_event.dart';
part 'bookingview_state.dart';

class BookingViewBloc extends Bloc<BookingViewEvent, BookingViewState> {
  final ApiBookingsRepository _bookingsRepository;

  BookingViewBloc() : 
  _bookingsRepository = new ApiBookingsRepository(),
  super(BookingViewInitial(null)){
    on<GetBookingDetails>((event, emit) async{
      emit(BookingViewLoading(state.booking));
      try{
        Booking? activity = await _bookingsRepository.getBookingById(event.bookingId);
              
        emit(BookingViewSuccess(activity));
              
      }on CustomException catch(e){
        emit(BookingViewError(state.booking, e.toString()));
      }
    });
  }
}
