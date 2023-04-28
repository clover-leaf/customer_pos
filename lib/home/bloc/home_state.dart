part of 'home_bloc.dart';

enum HomeTab {
  breakfast('Breakfasts'),
  side('Sides'),
  main('Mains'),
  salad('Salads'),
  drink('Drinks'),
  prepare('To Prepare'),
  delivery('To Delivery'),
  review('To Review');

  const HomeTab(this.value);
  final String value;
}

class HomeState {
  HomeState({
    this.tab = HomeTab.breakfast,
    required this.shouldShowDeliveringNotify,
    required this.shouldShowDeliveredNotify,
  });

  final HomeTab tab;
  final ShouldShowNotify shouldShowDeliveringNotify;
  final ShouldShowNotify shouldShowDeliveredNotify;

  // @override
  // List<Object> get props => [tab, isShowDeliveryNotify];

  HomeState copyWith({
    HomeTab? tab,
    ShouldShowNotify? shouldShowDeliveringNotify,
    ShouldShowNotify? shouldShowDeliveredNotify,
  }) =>
      HomeState(
        tab: tab ?? this.tab,
        shouldShowDeliveringNotify:
            shouldShowDeliveringNotify ?? this.shouldShowDeliveringNotify,
        shouldShowDeliveredNotify:
            shouldShowDeliveredNotify ?? this.shouldShowDeliveredNotify,
      );
}

class ShouldShowNotify {
  const ShouldShowNotify({required this.value});
  final bool value;
}
