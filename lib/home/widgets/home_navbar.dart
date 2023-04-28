import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos/gen/assets.gen.dart';
import 'package:pos/gen/colors.gen.dart';
import 'package:pos/home/home.dart';
import 'package:pos/menu/menu.dart';
import 'package:pos/order/bloc/order_bloc.dart';
import 'package:window_manager/window_manager.dart';

class HomeNavbar extends StatelessWidget {
  const HomeNavbar(this.selectTab, {super.key});

  final HomeTab selectTab;

  @override
  Widget build(BuildContext context) {
    final menuBloc = context.read<MenuBloc>();
    final orderBloc = context.read<OrderBloc>();

    final prepareDishesNumber =
        context.select((OrderBloc bloc) => bloc.state.prepareDishesNumber);
    final deliveryDishesNumber =
        context.select((OrderBloc bloc) => bloc.state.deliveryDishesNumber);
    final reviewDishesNumber =
        context.select((OrderBloc bloc) => bloc.state.reviewDishesNumber);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanStart: (details) {
        windowManager.startDragging();
      },
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ColorName.blue100,
              Colors.white,
            ],
            stops: [0.1, 1],
          ),
        ),
        width: 196,
        child: Column(
          children: [
            const LogoText(),
            const NavbarLabel('MAIN MENU'),
            NavbarButton(
              selectedTab: selectTab,
              tab: HomeTab.breakfast,
              onPressed: () => menuBloc
                  .add(ChangeCategory(categoryId: HomeTab.breakfast.index)),
              svgGenImage: Assets.images.icons.breakfast,
            ),
            NavbarButton(
              selectedTab: selectTab,
              tab: HomeTab.side,
              onPressed: () =>
                  menuBloc.add(ChangeCategory(categoryId: HomeTab.side.index)),
              svgGenImage: Assets.images.icons.side,
            ),
            NavbarButton(
              selectedTab: selectTab,
              tab: HomeTab.main,
              onPressed: () =>
                  menuBloc.add(ChangeCategory(categoryId: HomeTab.main.index)),
              svgGenImage: Assets.images.icons.main,
            ),
            NavbarButton(
              selectedTab: selectTab,
              tab: HomeTab.salad,
              onPressed: () =>
                  menuBloc.add(ChangeCategory(categoryId: HomeTab.salad.index)),
              svgGenImage: Assets.images.icons.salad,
            ),
            NavbarButton(
              selectedTab: selectTab,
              tab: HomeTab.drink,
              onPressed: () =>
                  menuBloc.add(ChangeCategory(categoryId: HomeTab.drink.index)),
              svgGenImage: Assets.images.icons.drink,
            ),
            const SizedBox(height: 16),
            const NavbarLabel('MY ORDERS'),
            NavbarButton(
              selectedTab: selectTab,
              tab: HomeTab.prepare,
              onPressed: () =>
                  orderBloc.add(const ChangeStatus(OrderStatus.prepare)),
              badgeNumber: prepareDishesNumber,
              svgGenImage: Assets.images.icons.prepare,
            ),
            NavbarButton(
              selectedTab: selectTab,
              tab: HomeTab.delivery,
              onPressed: () =>
                  orderBloc.add(const ChangeStatus(OrderStatus.delivery)),
              badgeNumber: deliveryDishesNumber,
              svgGenImage: Assets.images.icons.delivery,
            ),
            NavbarButton(
              selectedTab: selectTab,
              tab: HomeTab.review,
              onPressed: () =>
                  orderBloc.add(const ChangeStatus(OrderStatus.review)),
              badgeNumber: reviewDishesNumber,
              svgGenImage: Assets.images.icons.review,
            ),
            const Spacer(),
            const TableIDText(),
          ],
        ),
      ),
    );
  }
}

class LogoText extends StatelessWidget {
  const LogoText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 0, 8),
          child: Text(
            'Clover Cafe',
            style: GoogleFonts.sriracha(
              fontSize: 24,
              color: ColorName.blue800,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class TableIDText extends StatelessWidget {
  const TableIDText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final tableNumber = context.select((MenuBloc bloc) => bloc.tableNumber);

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 0, 24),
          child: Text(
            'Table Number: $tableNumber'.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              color: ColorName.text100,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class NavbarLabel extends StatelessWidget {
  const NavbarLabel(this.label, {super.key});

  final String label;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 16, 0, 8),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: ColorName.text100,
            ),
          ),
        ),
      ],
    );
  }
}
