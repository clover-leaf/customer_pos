import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos/gen/colors.gen.dart';
import 'package:pos/menu/menu.dart';
import 'package:pos/utils/utils.dart';
import 'package:pos_server/server/server.dart';

class InvoiceDishCard extends StatelessWidget {
  const InvoiceDishCard(this.invoiceDish, {super.key});

  final InvoiceDish invoiceDish;

  @override
  Widget build(BuildContext context) {
    final dishView = context.select((MenuBloc bloc) => bloc.state.dishView);
    final dish = dishView[invoiceDish.dishId]!;
    final price = (dish.price * invoiceDish.quantity).roundTo(2);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
      ),
      child: SizedBox(
        height: 64,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
              child: AspectRatio(
                aspectRatio: 1.6,
                child: CachedNetworkImage(
                  imageUrl: dish.url,
                  fit: BoxFit.cover,
                  placeholder: (context, _) => Container(
                    color: ColorName.grey100,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: NameAndPriceLabel(dishName: dish.name, price: price),
            ),
            DecoratedBox(
              decoration: const BoxDecoration(
                color: ColorName.blue600,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Row(
                children: [
                  QuantityButton(
                    onPressed: () => context.read<MenuBloc>().add(
                          ChangeDishQuantity(
                            invoiceDishId: invoiceDish.id,
                            changedQuantity: -1,
                          ),
                        ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Text(
                      '${invoiceDish.quantity}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  QuantityButton(
                    isRightSide: true,
                    onPressed: () => context.read<MenuBloc>().add(
                          ChangeDishQuantity(
                            invoiceDishId: invoiceDish.id,
                            changedQuantity: 1,
                          ),
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}

class NameAndPriceLabel extends StatelessWidget {
  const NameAndPriceLabel({
    super.key,
    required this.dishName,
    required this.price,
  });

  final String dishName;
  final double price;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                dishName,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: ColorName.text100,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '\$ $price',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: ColorName.blue900,
          ),
        )
      ],
    );
  }
}

class QuantityButton extends StatelessWidget {
  const QuantityButton({
    super.key,
    this.radius = 8,
    this.isRightSide = false,
    required this.onPressed,
  });

  final double radius;
  final bool isRightSide;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    late final IconData iconData;
    if (isRightSide) {
      iconData = Icons.add;
    } else {
      iconData = Icons.remove;
    }
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(
          iconData,
          color: Colors.white,
          size: 16,
        ),
      ),
    );
  }
}
