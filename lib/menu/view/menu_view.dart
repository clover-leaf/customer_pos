import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos/gen/colors.gen.dart';
import 'package:pos/menu/menu.dart';
import 'package:pos/utils/utils.dart';

class MenuView extends StatelessWidget {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    final status = context.select((MenuBloc bloc) => bloc.state.status);

    if (status.isLoading()) {
      return const Center(
        child: CircularProgressIndicator(
          color: ColorName.blue700,
        ),
      );
    }

    if (status.isFailure()) {
      return const Center(
        child: Text(
          'Something wrong has happened!',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: ColorName.text100,
          ),
        ),
      );
    }

    return ColoredBox(
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Flexible(flex: 5, fit: FlexFit.tight, child: Menu()),
          Flexible(flex: 3, fit: FlexFit.tight, child: Cart()),
        ],
      ),
    );
  }
}

class Menu extends StatelessWidget {
  const Menu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final showDishes = context.select((MenuBloc bloc) => bloc.state.showDishes);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: SingleChildScrollView(
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: showDishes.map(DishCard.new).toList(),
        ),
      ),
    );
  }
}

class Cart extends StatelessWidget {
  const Cart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final invoiceDishes =
        context.select((MenuBloc bloc) => bloc.state.invoiceDishes);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [ColorName.blue100, Colors.white],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          stops: [0.1, 1],
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'MY ORDER',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: ColorName.text100,
                  ),
                ),
                const SizedBox(height: 8),
                if (invoiceDishes.isEmpty)
                  const EmptyCartLabel()
                else
                  Expanded(
                    child: ListView.separated(
                      itemCount: invoiceDishes.length,
                      itemBuilder: (context, index) {
                        return InvoiceDishCard(invoiceDishes[index]);
                      },
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                    ),
                  ),
                if (invoiceDishes.isNotEmpty) const CostLabel()
              ],
            ),
          ),
          CheckOutButton(isEnable: invoiceDishes.isNotEmpty),
        ],
      ),
    );
  }
}

class EmptyCartLabel extends StatelessWidget {
  const EmptyCartLabel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Your order list is empty',
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: ColorName.text100,
      ),
    );
  }
}

class CostLabel extends StatelessWidget {
  const CostLabel({super.key});

  @override
  Widget build(BuildContext context) {
    final subtotal = context.select((MenuBloc bloc) => bloc.state.total);
    final tax = (subtotal * 0.1).roundTo(2);
    final discount = 0.0.roundTo(2);
    final total = subtotal + tax - discount;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PriceLabel(
            label: 'SUBTOTAL',
            value: subtotal.toUsd(),
          ),
          PriceLabel(
            label: 'TAX (10%)',
            value: tax.toUsd(),
          ),
          PriceLabel(
            label: 'DISCOUNT',
            isNegative: true,
            value: discount.toUsd(),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
            child: Divider(
              height: 1.2,
              indent: 4,
              endIndent: 8,
              color: ColorName.grey100,
            ),
          ),
          PriceLabel(
            label: 'TOTAL',
            value: total.toUsd(),
            emphasize: true,
          ),
        ],
      ),
    );
  }
}

class PriceLabel extends StatelessWidget {
  const PriceLabel({
    super.key,
    required this.label,
    required this.value,
    this.isNegative = false,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final bool isNegative;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final priceFontSize = emphasize ? 18.0 : 14.0;
    final priceValue = isNegative ? '- $value' : value;
    final priceValueColor = isNegative ? ColorName.red100 : ColorName.text100;

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 12, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: ColorName.grey100,
            ),
          ),
          Text(
            priceValue,
            style: TextStyle(
              fontSize: priceFontSize,
              fontWeight: FontWeight.w500,
              color: priceValueColor,
            ),
          )
        ],
      ),
    );
  }
}

class CheckOutButton extends StatelessWidget {
  const CheckOutButton({super.key, required this.isEnable});

  final bool isEnable;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 8, 0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: isEnable ? ColorName.blue700 : ColorName.grey100,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          minimumSize: const Size(double.infinity, 20),
        ),
        onPressed: isEnable
            ? () {
                context.read<MenuBloc>().add(const CheckOut());
                showNotification(
                  context,
                  title: 'order successfully',
                  description: 'Your order will be delivered shortly.',
                  iconData: Icons.check,
                );
              }
            : null,
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text(
            'CHECKOUT',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
