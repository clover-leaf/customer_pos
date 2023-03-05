import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos/gen/colors.gen.dart';
import 'package:pos/menu/menu.dart';
import 'package:pos_server/server/server.dart';

class InvoiceDishCard extends StatelessWidget {
  const InvoiceDishCard(this.invoiceDish, {super.key});

  final InvoiceDish invoiceDish;

  @override
  Widget build(BuildContext context) {
    final dishView = context.select((MenuBloc bloc) => bloc.state.dishView);
    final dish = dishView[invoiceDish.dishId]!;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: SizedBox(
        height: 64,
        child: Row(
          mainAxisSize: MainAxisSize.min,
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
            NameAndQuantityLabel(
              dishName: dish.name,
              quantity: invoiceDish.quantity,
            ),
          ],
        ),
      ),
    );
  }
}

class NameAndQuantityLabel extends StatelessWidget {
  const NameAndQuantityLabel({
    super.key,
    required this.dishName,
    required this.quantity,
  });

  final String dishName;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dishName,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: ColorName.text100,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Quantity: $quantity',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: ColorName.text100,
            ),
          )
        ],
      ),
    );
  }
}
