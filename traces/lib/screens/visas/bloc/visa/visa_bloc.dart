import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../../../shared/state_types.dart';
import '../../model/visa.dart';
import '../../model/visa_tab.dart';
import '../../repository/visas_repository.dart';

part 'visa_event.dart';
part 'visa_state.dart';

class VisaBloc extends Bloc<VisaEvent, VisaState> {
  final VisasRepository _visasRepository;
  StreamSubscription _visasSubscription;

  VisaBloc({@required VisasRepository visasRepository})
      : assert(visasRepository != null),     
        _visasRepository = visasRepository,
        super(VisaState.empty());

  @override
  Stream<VisaState> mapEventToState(VisaEvent event) async* {
    if (event is GetAllVisas) {
      yield* _mapGetVisasToState(event);
    } else if (event is UpdateVisasList) {
      yield* _mapUpdateVisasListToState(event);
    }
  }

  Stream<VisaState> _mapUpdateVisasListToState(UpdateVisasList event) async* {
    yield VisaState.success(allVisas: event.allVisas);
  }

  Stream<VisaState> _mapGetVisasToState(GetAllVisas event) async* {
    yield VisaState.loading();

    _visasSubscription?.cancel();

    _visasSubscription = _visasRepository.visas().listen(
          (visas) => add(UpdateVisasList(visas)),
        );
  }
}
