// ignore_for_file: deprecated_member_use
// ignore_for_file:  deprecated_member_use_from_same_package

import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos/gen/assets.gen.dart';
import 'package:pos/gen/colors.gen.dart';
import 'package:pos/home/home.dart';

class NavbarButton extends StatelessWidget {
  const NavbarButton({
    super.key,
    required this.selectedTab,
    required this.tab,
    required this.svgGenImage,
    this.onPressed,
    this.badgeNumber,
  });

  final HomeTab selectedTab;
  final SvgGenImage svgGenImage;
  final HomeTab tab;
  final void Function()? onPressed;
  final int? badgeNumber;

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedTab == tab;
    final dynamicColor = isSelected ? ColorName.blue700 : ColorName.text100;

    return GestureDetector(
      onTap: () {
        onPressed?.call();
        context.read<HomeBloc>().add(ChangeTab(tab));
      },
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Container(
            width: 4,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(4),
                bottomRight: Radius.circular(4),
              ),
              color: isSelected ? ColorName.blue700 : Colors.transparent,
            ),
          ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.only(left: 24),
              height: 48,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : null,
              ),
              child: Row(
                children: [
                  svgGenImage.svg(
                    height: 40,
                    color: dynamicColor,
                  ),
                  const SizedBox(width: 8),
                  if (badgeNumber != null)
                    badges.Badge(
                      position: badges.BadgePosition.topEnd(end: -20, top: -12),
                      badgeStyle: badges.BadgeStyle(
                        badgeColor: dynamicColor,
                        elevation: 0,
                        // padding: const EdgeInsets.all(6),
                      ),
                      badgeContent: Text(
                        '$badgeNumber',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      showBadge: badgeNumber! > 0,
                      badgeAnimation:
                          const badges.BadgeAnimation.slide(toAnimate: false),
                      child: Text(
                        tab.value,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  else
                    Text(
                      tab.value,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: dynamicColor,
                      ),
                    ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
