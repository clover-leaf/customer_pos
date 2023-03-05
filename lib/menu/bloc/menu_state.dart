part of 'menu_bloc.dart';

enum LoadingStatus { loading, success, failure }

extension LoadingStatusX on LoadingStatus {
  bool isLoading() => this == LoadingStatus.loading;
  bool isSuccess() => this == LoadingStatus.success;
  bool isFailure() => this == LoadingStatus.failure;
}

class MenuState extends Equatable {
  MenuState({
    this.categories = const <Category>[],
    this.dishes = const <Dish>[],
    this.status = LoadingStatus.loading,
    this.selectedCategoryId = 0,
    this.invoice,
    this.invoiceDishes = const <InvoiceDish>[],
  });

  // Data got from server
  final List<Category> categories;
  final List<Dish> dishes;
  final LoadingStatus status;

  // Selected info from UI
  final int selectedCategoryId;

  // Cart data
  final Invoice? invoice;
  final List<InvoiceDish> invoiceDishes;

  double get total {
    final prices = invoiceDishes.map(
      (invoiceDish) =>
          (dishView[invoiceDish.dishId]!.price * invoiceDish.quantity)
              .roundTo(2),
    );
    if (prices.isNotEmpty) {
      return prices.reduce((prv, cur) => prv + cur).roundTo(2);
    }

    return 0;
  }

  late final showDishes =
      dishes.where((dish) => dish.categoryId == selectedCategoryId).toList();

  late final dishView = {for (final dish in dishes) dish.id: dish};

  @override
  List<Object?> get props => [
        categories,
        dishes,
        status,
        selectedCategoryId,
        invoice,
        invoiceDishes,
      ];

  MenuState copyWith({
    List<Category>? categories,
    List<Dish>? dishes,
    LoadingStatus? status,
    int? selectedCategoryId,
    Invoice? Function()? invoice,
    List<InvoiceDish>? invoiceDishes,
  }) {
    return MenuState(
      categories: categories ?? this.categories,
      dishes: dishes ?? this.dishes,
      status: status ?? this.status,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      invoice: invoice != null ? invoice() : this.invoice,
      invoiceDishes: invoiceDishes ?? this.invoiceDishes,
    );
  }
}
