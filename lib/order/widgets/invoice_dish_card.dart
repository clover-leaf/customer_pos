import 'package:cached_network_image/cached_network_image.dart';
import 'package:client_repository/client_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pos/gen/colors.gen.dart';
import 'package:pos/menu/menu.dart';
import 'package:pos/order/bloc/order_bloc.dart';

class InvoiceDishCard extends StatelessWidget {
  const InvoiceDishCard(this.invoiceDish, {super.key});

  final InvoiceDish invoiceDish;

  @override
  Widget build(BuildContext context) {
    final dishView = context.select((MenuBloc bloc) => bloc.state.dishView);
    final status = context.select((OrderBloc bloc) => bloc.state.status);
    final dish = dishView[invoiceDish.dishId]!;

    if (status == OrderStatus.review) {
      return Column(
        children: [
          DecoratedBox(
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
          ),
          Rating(dishId: dish.id)
        ],
      );
    } else {
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
}

class Rating extends StatefulWidget {
  const Rating({
    super.key,
    required this.dishId,
  });

  final String dishId;

  @override
  State<Rating> createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  late bool isReview;

  @override
  void initState() {
    super.initState();
    isReview = false;
  }

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      minRating: 1,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      ignoreGestures: isReview,
      onRatingUpdate: (rating) {
        setState(() {
          isReview = true;
        });
        context
            .read<OrderBloc>()
            .add(Review(dishId: widget.dishId, rating: rating.toInt()));
      },
      updateOnDrag: true,
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
