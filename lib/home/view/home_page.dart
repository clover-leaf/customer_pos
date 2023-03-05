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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => HomeCubit(),
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
      child: HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final menuPage = const MenuView();
  final orderPage = const OrderView();

  @override
  Widget build(BuildContext context) {
    final selectTab = context.select((HomeCubit cubit) => cubit.state.tab);

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
