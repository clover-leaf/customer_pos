part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class ChangeTab extends HomeEvent {
  const ChangeTab(this.tab);

  final HomeTab tab;
}

class SubscribeDelivering extends HomeEvent {
  const SubscribeDelivering();
}

class SubscribeDelivered extends HomeEvent {
  const SubscribeDelivered();
}
