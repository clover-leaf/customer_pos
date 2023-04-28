import 'package:cached_network_image/cached_network_image.dart';
import 'package:client_repository/client_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos/gen/colors.gen.dart';
import 'package:pos/menu/bloc/menu_bloc.dart';

class DishCard extends StatelessWidget {
  const DishCard(this.dish, {super.key});

  final Dish dish;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<MenuBloc>().add(AddToOrder(dish.id)),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: ColorName.blue100.withAlpha(106),
        ),
        child: SizedBox(
          width: 204,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        dish.name,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: ColorName.text100,
                        ),
                      ),
                    ),
                    Text(
                      '\$${dish.price}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: ColorName.blue900,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
