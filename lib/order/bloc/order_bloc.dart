import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:client_repository/client_repository.dart';
import 'package:equatable/equatable.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc({
    required ClientRepository clientRepository,
    required this.tableNumber,
  })  : _clientRepository = clientRepository,
        super(const OrderState()) {
    on<StartOrder>(_onStart);
    on<ChangeStatus>(_onChangeStatus);
    on<Review>(_onReview);
    on<_InvoiceChange>(_onInvoiceChange);
    on<_PrepareDishChange>(_onPrepareDishChange);
    on<_DeliveryDishChange>(_onDeliveryDishChange);
    on<_ReviewDishChange>(_onReviewDishChange);
    on<_ConnectionStateChanged>(_onConnectionStateChanged);
  }

  final int tableNumber;
  final ClientRepository _clientRepository;
  StreamSubscription<Invoice?>? _invoiceSubscription;
  StreamSubscription<List<InvoiceDish>>? _prepareDishesSubscription;
  StreamSubscription<List<InvoiceDish>>? _deliveryDishesSubscription;
  StreamSubscription<List<String>>? _reviewDishesSubscription;
  StreamSubscription<ConnectionState>? _connectionSubscription;

  void _onStart(StartOrder event, Emitter<OrderState> emit) {
    _invoiceSubscription = _clientRepository.invoice
        .listen((invoice) => add(_InvoiceChange(invoice)));
    _prepareDishesSubscription = _clientRepository.prepareDishes
        .listen((state) => add(_PrepareDishChange(state)));
    _deliveryDishesSubscription = _clientRepository.deliveryDishes
        .listen((state) => add(_DeliveryDishChange(state)));
    _reviewDishesSubscription = _clientRepository.reviewDishes
        .listen((state) => add(_ReviewDishChange(state)));
    _connectionSubscription = _clientRepository.connection.listen((state) {
      add(_ConnectionStateChanged(state));
    });
  }

  void _onConnectionStateChanged(
    _ConnectionStateChanged event,
    Emitter<OrderState> emit,
  ) {
    emit(state.copyWith(connectionStatus: event.state.toStatus()));
  }

  void _onChangeStatus(ChangeStatus event, Emitter<OrderState> emit) {
    emit(state.copyWith(status: event.status));
  }

  void _onReview(Review event, Emitter<OrderState> emit) {
    _clientRepository.review(event.dishId, event.rating);
  }

  void _onInvoiceChange(_InvoiceChange event, Emitter<OrderState> emit) {
    if (event.invoice == null) return;
    if (event.invoice!.tableId == tableNumber) {
      final invoices = List<Invoice>.from(state.invoices)..add(event.invoice!);
      emit(state.copyWith(invoices: invoices));
    }
  }

  void _onPrepareDishChange(
    _PrepareDishChange event,
    Emitter<OrderState> emit,
  ) {
    final myInvoiceIds = state.invoices.map((invoice) => invoice.id);
    final myPrepareDishes = event.invoiceDishes
        .where((dish) => myInvoiceIds.contains(dish.invoiceId))
        .toList();
    final updatePrepareDishes = [...state.prepareDishes, ...myPrepareDishes];
    emit(state.copyWith(prepareDishes: updatePrepareDishes));
  }

  void _onDeliveryDishChange(
    _DeliveryDishChange event,
    Emitter<OrderState> emit,
  ) {
    final myInvoiceIds = state.invoices.map((invoice) => invoice.id);
    final newDeliveryDishes = event.invoiceDishes
        .where((dish) => myInvoiceIds.contains(dish.invoiceId))
        .toList();

    if (newDeliveryDishes.isNotEmpty) {
      _clientRepository.updateShouldNotifyDelivering(shouldNotify: true);
    }

    final updateDeliveryDishes = [
      ...state.deliveryDishes,
      ...newDeliveryDishes
    ];

    final newDeliveryDishId = newDeliveryDishes.map((dish) => dish.id);
    final updatePrepareDishes = List<InvoiceDish>.from(state.prepareDishes)
      ..removeWhere((dish) => newDeliveryDishId.contains(dish.id));

    emit(
      state.copyWith(
        prepareDishes: updatePrepareDishes,
        deliveryDishes: updateDeliveryDishes,
      ),
    );
  }

  void _onReviewDishChange(
    _ReviewDishChange event,
    Emitter<OrderState> emit,
  ) {
    final reviewDishes = state.deliveryDishes
        .where((dish) => event.invoiceDishesId.contains(dish.id))
        .toList();
    final updateReviewDishes = [...state.reviewDishes, ...reviewDishes];
    if (reviewDishes.isNotEmpty) {
      _clientRepository.updateShouldNotifyDelivered(shouldNotify: true);
    }

    final updateDeliveryDishes = List<InvoiceDish>.from(state.deliveryDishes)
      ..removeWhere((dish) => event.invoiceDishesId.contains(dish.id));
    emit(
      state.copyWith(
        deliveryDishes: updateDeliveryDishes,
        reviewDishes: updateReviewDishes,
      ),
    );
  }

  @override
  Future<void> close() {
    _invoiceSubscription?.cancel();
    _prepareDishesSubscription?.cancel();
    _deliveryDishesSubscription?.cancel();
    _reviewDishesSubscription?.cancel();
    _connectionSubscription?.cancel();
    return super.close();
  }
}

extension on ConnectionState {
  ConnectionStatus toStatus() {
    return this is Connected || this is Reconnected
        ? ConnectionStatus.connected
        : ConnectionStatus.disconnected;
  }
}
