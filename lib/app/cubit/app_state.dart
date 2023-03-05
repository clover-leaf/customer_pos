part of 'app_cubit.dart';

class AppState extends Equatable {
  const AppState({required this.tableNumber});

  final int tableNumber;

  @override
  List<Object> get props => [tableNumber];

  AppState copyWith({
    int? tableNumber,
  }) {
    return AppState(
      tableNumber: tableNumber ?? this.tableNumber,
    );
  }
}
