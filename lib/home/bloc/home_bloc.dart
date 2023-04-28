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
            shouldShowDeliveringNotify: const ShouldShowNotify(value: false),
            shouldShowDeliveredNotify: const ShouldShowNotify(value: false),
          ),
        ) {
    on<ChangeTab>(_onChangeTab);
    on<SubscribeDelivering>(_onSubscribeDelivering);
    on<SubscribeDelivered>(_onSubscribeDelivered);
  }
  final ClientRepository _clientRepository;

  void _onChangeTab(ChangeTab event, Emitter<HomeState> emit) {
    emit(state.copyWith(tab: event.tab));
  }

  Future<void> _onSubscribeDelivering(
    SubscribeDelivering event,
    Emitter<HomeState> emit,
  ) async {
    await emit.forEach<bool>(
      _clientRepository.getShouldNotifyDelivering(),
      onData: (should) {
        // if (shouldNotify) {
        //   _clientRepository.updateShouldNotifyDelivery(shouldNotify: false);
        // }
        return state.copyWith(
          shouldShowDeliveringNotify: ShouldShowNotify(value: should),
        );
      },
    );
  }

  Future<void> _onSubscribeDelivered(
    SubscribeDelivered event,
    Emitter<HomeState> emit,
  ) async {
    await emit.forEach<bool>(
      _clientRepository.getShouldNotifyDelivered(),
      onData: (should) {
        return state.copyWith(
          shouldShowDeliveredNotify: ShouldShowNotify(value: should),
        );
      },
    );
  }
}
