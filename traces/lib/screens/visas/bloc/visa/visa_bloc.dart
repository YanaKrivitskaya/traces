import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:traces/screens/visas/model/visa.dart';
import 'package:equatable/equatable.dart';
import 'package:traces/screens/visas/repository/visas_repository.dart';

part 'visa_event.dart';

part 'visa_state.dart';

class VisaBloc extends Bloc<VisaEvent, VisaState> {
  final VisasRepository _visasRepository;
  StreamSubscription _visasSubscription;

  VisaBloc({@required VisasRepository visasRepository})
      : assert(visasRepository != null),
        _visasRepository = visasRepository;

  @override
  VisaState get initialState => VisaState.empty();

  @override
  Stream<VisaState> mapEventToState(VisaEvent event) async* {
    // TODO: Add your event logic
  }

  Stream<VisaState> _mapUpdateVisasListToState(UpdateVisasList event) async* {
    yield VisaState.success(allVisas: event.allVisas);
  }

  Stream<VisaState> _mapGetVisasToState(GetAllVisas event) async*{
    yield VisaState.loading();

    _visasSubscription?.cancel();

    _visasSubscription = _visasRepository.visas().listen(
          (visas) => add(UpdateVisasList(visas)),
    );
  }
}
