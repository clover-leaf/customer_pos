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
    required this.isShowDeliveryNotify,
  });

  final HomeTab tab;
  final ShouldNotify isShowDeliveryNotify;

  // @override
  // List<Object> get props => [tab, isShowDeliveryNotify];

  HomeState copyWith({
    HomeTab? tab,
    ShouldNotify? isShowDeliveryNotify,
  }) =>
      HomeState(
        tab: tab ?? this.tab,
        isShowDeliveryNotify: isShowDeliveryNotify ?? this.isShowDeliveryNotify,
      );
}

class ShouldNotify {
  const ShouldNotify({required this.should});
  final bool should;
}
