part of 'menu_bloc.dart';

class MenuEvent {
  const MenuEvent();
}

class StartMenu extends MenuEvent {
  const StartMenu();
}

class ChangeCategory extends MenuEvent {
  const ChangeCategory({required this.categoryId});

  final int categoryId;
}

class AddToOrder extends MenuEvent {
  const AddToOrder(this.dishId);

  final String dishId;
}

class ChangeDishQuantity extends MenuEvent {
  const ChangeDishQuantity({
    required this.invoiceDishId,
    required this.changedQuantity,
  });

  final String invoiceDishId;
  final int changedQuantity;
}

class CheckOut extends MenuEvent {
  const CheckOut();
}
