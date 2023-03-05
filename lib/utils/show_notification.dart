import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:pos/gen/colors.gen.dart';

void showNotification(
  BuildContext context, {
  required String title,
  required String description,
  required IconData iconData,
}) {
  return ElegantNotification(
    radius: 8,
    width: 256,
    icon: Icon(
      iconData,
      color: ColorName.blue700,
    ),
    shadowColor: Colors.transparent,
    showProgressIndicator: false,
    autoDismiss: false,
    notificationPosition: NotificationPosition.bottomRight,
    title: Text(
      title.toUpperCase(),
      style: const TextStyle(
        fontSize: 12,
        color: ColorName.blue900,
        fontWeight: FontWeight.w600,
      ),
    ),
    description: Text(
      description,
      style: const TextStyle(
        fontSize: 12,
        color: ColorName.text100,
        fontWeight: FontWeight.w500,
      ),
    ),
  ).show(context);
}
