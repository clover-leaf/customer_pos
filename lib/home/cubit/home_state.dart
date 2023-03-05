part of 'home_cubit.dart';

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

class HomeState extends Equatable {
  const HomeState({this.tab = HomeTab.breakfast});

  final HomeTab tab;

  @override
  List<Object> get props => [tab];
}
