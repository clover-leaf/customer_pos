import 'package:bloc/bloc.dart';
import 'package:client_repository/client_repository.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required ClientRepository clientRepository,
  })  : _clientRepository = clientRepository,
        super(
          HomeState(
            isShowDeliveryNotify: const ShouldNotify(should: false),
          ),
        ) {
    on<ChangeTab>(_onChangeTab);
    on<Subscribe>(_onSubscribe);
  }
  final ClientRepository _clientRepository;

  void _onChangeTab(ChangeTab event, Emitter<HomeState> emit) {
    emit(state.copyWith(tab: event.tab));
  }

  Future<void> _onSubscribe(Subscribe event, Emitter<HomeState> emit) async {
    await emit.forEach<bool>(
      _clientRepository.getShouldNotifyDelivery(),
      onData: (should) {
        // if (shouldNotify) {
        //   _clientRepository.updateShouldNotifyDelivery(shouldNotify: false);
        // }
        return state.copyWith(
            isShowDeliveryNotify: ShouldNotify(should: should));
      },
    );
  }
}
