import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit({required SharedPreferences prefs})
      : _prefs = prefs,
        super(const AppState(tableNumber: 0));

  final SharedPreferences _prefs;

  Future<void> initial() async {
    final tableNumber = _prefs.getInt('tableNumber') ?? 0;
    emit(state.copyWith(tableNumber: tableNumber));
  }

  Future<void> setTableNumber(int tableNumber) async {
    await _prefs.setInt('tableNumber', tableNumber);
    emit(state.copyWith(tableNumber: tableNumber));
  }
}
