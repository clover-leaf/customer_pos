// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:client_repository/client_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos/app/app.dart';

import 'package:pos/home/home.dart';
import 'package:pos/menu/bloc/menu_bloc.dart';
import 'package:pos/menu/view/menu_view.dart';
import 'package:pos/order/bloc/order_bloc.dart';
import 'package:pos/order/view/order_view.dart';
import 'package:pos/utils/show_notification.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => HomeBloc(
            clientRepository: context.read<ClientRepository>(),
          )
            ..add(const SubscribeDelivering())
            ..add(const SubscribeDelivered()),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => MenuBloc(
            clientRepository: context.read<ClientRepository>(),
            tableNumber: context.read<AppCubit>().state.tableNumber,
          )..add(const StartMenu()),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => OrderBloc(
            clientRepository: context.read<ClientRepository>(),
            tableNumber: context.read<AppCubit>().state.tableNumber,
          )..add(const StartOrder()),
        ),
      ],
      child: const HomeMediator(),
    );
  }
}

class HomeMediator extends StatelessWidget {
  const HomeMediator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final shouldShowDeliveringNotify = context
        .select((HomeBloc bloc) => bloc.state.shouldShowDeliveringNotify);
    final shouldShowDeliveredNotify =
        context.select((HomeBloc bloc) => bloc.state.shouldShowDeliveredNotify);

    return HomeView(
      shouldShowDeliveringNotify: shouldShowDeliveringNotify.value,
      shouldShowDeliveredNotify: shouldShowDeliveredNotify.value,
    );
  }
}

class HomeView extends StatefulWidget {
  HomeView({
    super.key,
    required this.shouldShowDeliveringNotify,
    required this.shouldShowDeliveredNotify,
  });

  final bool shouldShowDeliveringNotify;
  final bool shouldShowDeliveredNotify;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final menuPage = const MenuView();

  final orderPage = const OrderView();

  @override
  void didUpdateWidget(covariant HomeView oldWidget) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.shouldShowDeliveringNotify) {
        buildNotification(
          title: 'Delivering',
          description: 'Dishes are being delivering!',
          iconData: Icons.check,
        ).show(context);
      } else if (widget.shouldShowDeliveredNotify) {
        buildNotification(
          title: 'Delivered',
          description: 'Dishes are delivered!',
          iconData: Icons.check,
        ).show(context);
      }
    });

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final selectTab = context.select((HomeBloc cubit) => cubit.state.tab);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HomeNavbar(selectTab),
          Expanded(
            child: (selectTab.index < 5) ? menuPage : orderPage,
          ),
        ],
      ),
    );
  }
}
