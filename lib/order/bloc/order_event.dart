part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class StartOrder extends OrderEvent {
  const StartOrder();
}

class ChangeStatus extends OrderEvent {
  const ChangeStatus(this.status);

  final OrderStatus status;
}

class Review extends OrderEvent {
  const Review({required this.dishId, required this.rating});

  final String dishId;
  final int rating;
}

class _InvoiceChange extends OrderEvent {
  const _InvoiceChange(this.invoice);

  final Invoice? invoice;
}

class _PrepareDishChange extends OrderEvent {
  const _PrepareDishChange(this.invoiceDishes);

  final List<InvoiceDish> invoiceDishes;
}

class _DeliveryDishChange extends OrderEvent {
  const _DeliveryDishChange(this.invoiceDishes);

  final List<InvoiceDish> invoiceDishes;
}

class _ReviewDishChange extends OrderEvent {
  const _ReviewDishChange(this.invoiceDishesId);

  final List<String> invoiceDishesId;
}

class _ConnectionStateChanged extends OrderEvent {
  const _ConnectionStateChanged(this.state);

  final ConnectionState state;
}
