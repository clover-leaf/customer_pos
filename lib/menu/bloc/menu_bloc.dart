import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:client_repository/client_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:pos/utils/utils.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc({
    required ClientRepository clientRepository,
    required this.tableNumber,
  })  : _clientRepository = clientRepository,
        super(MenuState()) {
    on<StartMenu>(_onStart);
    on<ChangeCategory>(_onChangeCategory);
    on<AddToOrder>(_onAddToOrder);
    on<ChangeDishQuantity>(_onChangeDishQuantity);
    on<CheckOut>(_onCheckOut);
  }

  final ClientRepository _clientRepository;
  final int tableNumber;

  Future<void> _onStart(StartMenu event, Emitter<MenuState> emit) async {
    if (state.status.isSuccess()) return;
    try {
      final res = await _clientRepository.requestMenu();
      final categories = fromJson(Category.fromJson, res['category']);
      final dishes = fromJson(Dish.fromJson, res['dish']);

      emit(
        state.copyWith(
          categories: categories,
          dishes: dishes,
          status: LoadingStatus.success,
          selectedCategoryId: categories.first.id,
        ),
      );
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(status: LoadingStatus.failure));
    }
  }

  void _onChangeCategory(ChangeCategory event, Emitter<MenuState> emit) {
    emit(state.copyWith(selectedCategoryId: event.categoryId));
  }

  void _onAddToOrder(AddToOrder event, Emitter<MenuState> emit) {
    if (state.invoice == null) {
      final invoice = Invoice(tableId: tableNumber, time: DateTime.now());
      final invoiceDish =
          InvoiceDish(invoiceId: invoice.id, dishId: event.dishId, quantity: 1);
      emit(
        state.copyWith(
          invoice: () => invoice,
          invoiceDishes: [invoiceDish],
        ),
      );
      return;
    }
    final invoiceDishes = List<InvoiceDish>.from(state.invoiceDishes);
    final index = invoiceDishes
        .lastIndexWhere((invoiceDish) => invoiceDish.dishId == event.dishId);
    if (index != -1) {
      final curQuantity = invoiceDishes[index].quantity;
      invoiceDishes[index] =
          invoiceDishes[index].copyWith(quantity: curQuantity + 1);
    } else {
      final invoiceDish = InvoiceDish(
        invoiceId: state.invoice!.id,
        dishId: event.dishId,
        quantity: 1,
      );
      invoiceDishes.add(invoiceDish);
    }
    emit(state.copyWith(invoiceDishes: invoiceDishes));
  }

  void _onChangeDishQuantity(
    ChangeDishQuantity event,
    Emitter<MenuState> emit,
  ) {
    final invoiceDishes = List<InvoiceDish>.from(state.invoiceDishes);
    final index = invoiceDishes
        .indexWhere((invoiceDish) => invoiceDish.id == event.invoiceDishId);
    if (index == -1) return;

    final curQuantity = invoiceDishes[index].quantity;
    final nxtQuantity = curQuantity + event.changedQuantity;
    if (nxtQuantity == 0) {
      invoiceDishes.removeAt(index);
    } else {
      invoiceDishes[index] =
          invoiceDishes[index].copyWith(quantity: nxtQuantity);
    }

    emit(state.copyWith(invoiceDishes: invoiceDishes));
  }

  void _onCheckOut(CheckOut event, Emitter<MenuState> emit) {
    final order = {
      'invoice': state.invoice!.toJson(),
      'invoice_dishes': state.invoiceDishes
          .map((invoiceDish) => invoiceDish.toJson())
          .toList(),
    };
    _clientRepository.checkout(order);
    // reset invoice panel info
    emit(
      state.copyWith(
        invoice: () => null,
        invoiceDishes: [],
      ),
    );
  }
}
