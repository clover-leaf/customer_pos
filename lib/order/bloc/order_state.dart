part of 'order_bloc.dart';

enum ConnectionStatus { connected, disconnected }

class OrderState extends Equatable {
  const OrderState({
    this.status = OrderStatus.prepare,
    this.invoices = const <Invoice>[],
    this.prepareDishes = const <InvoiceDish>[],
    this.deliveryDishes = const <InvoiceDish>[],
    this.reviewDishes = const <InvoiceDish>[],
    this.connectionStatus = ConnectionStatus.disconnected,
  });

  final OrderStatus status;
  final List<Invoice> invoices;
  final List<InvoiceDish> prepareDishes;
  final List<InvoiceDish> deliveryDishes;
  final List<InvoiceDish> reviewDishes;
  final ConnectionStatus connectionStatus;

  int get prepareDishesNumber => prepareDishes.length;
  int get deliveryDishesNumber => deliveryDishes.length;
  int get reviewDishesNumber => reviewDishes.length;

  List<InvoiceDish> get showedDishes {
    switch (status) {
      case OrderStatus.prepare:
        return prepareDishes;
      case OrderStatus.delivery:
        return deliveryDishes;
      case OrderStatus.review:
        return reviewDishes;
    }
  }

  Map<String, Invoice> get invoiceView =>
      {for (final invoice in invoices) invoice.id: invoice};

  Map<String, Iterable<InvoiceDish>> get showedInvoiceView {
    final view = <String, Iterable<InvoiceDish>>{};
    for (final invoice in invoices) {
      final itsDish =
          showedDishes.where((dish) => dish.invoiceId == invoice.id);
      if (itsDish.isNotEmpty) {
        view[invoice.id] = itsDish;
      }
    }
    return view;
  }

  @override
  List<Object> get props => [
        status,
        invoices,
        prepareDishes,
        deliveryDishes,
        reviewDishes,
        connectionStatus
      ];

  OrderState copyWith({
    OrderStatus? status,
    List<Invoice>? invoices,
    List<InvoiceDish>? prepareDishes,
    List<InvoiceDish>? deliveryDishes,
    List<InvoiceDish>? reviewDishes,
    ConnectionStatus? connectionStatus,
  }) {
    return OrderState(
      status: status ?? this.status,
      invoices: invoices ?? this.invoices,
      prepareDishes: prepareDishes ?? this.prepareDishes,
      deliveryDishes: deliveryDishes ?? this.deliveryDishes,
      reviewDishes: reviewDishes ?? this.reviewDishes,
      connectionStatus: connectionStatus ?? this.connectionStatus,
    );
  }
}

enum OrderStatus { prepare, delivery, review }
