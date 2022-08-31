import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../utils/services/shared_preferencies_service.dart';

part 'tripviewoptions_event.dart';
part 'tripviewoptions_state.dart';

class TripViewOptionsBloc extends Bloc<TripViewOptionsEvent, TripViewOptionsState> {
  SharedPreferencesService sharedPrefsService = SharedPreferencesService();
  
  TripViewOptionsBloc() : super(TripViewOptionSelectedState(null)) {
    on<ViewOptionUpdated>((event, emit) async{
      await sharedPrefsService.writeInt(key: "tripViewOption", value: event.option);
      emit(TripViewOptionSelectedState(event.option));
    });
  }
}
