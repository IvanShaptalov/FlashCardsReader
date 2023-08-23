import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

enum NotificationStatus { success, error, warning, info }

class OverlayNotificationProvider {
  static Color _setColor(NotificationStatus status) {
    switch (status) {
      case NotificationStatus.success:
        return Palette.green;
      case NotificationStatus.error:
        return Palette.blueGrey;
      case NotificationStatus.warning:
        return Palette.blueGrey;
      case NotificationStatus.info:
        return Palette.teal;
      default:
        return Palette.green;
    }
  }

  static void showOverlayNotification(String message,
      {NotificationStatus status = NotificationStatus.info,
      Duration duration = const Duration(milliseconds: 1600)}) {
    showSimpleNotification(
        Text(
          message,
          style: const TextStyle(fontSize: 20),
        ),
        slideDismissDirection: DismissDirection.up,
        background: _setColor(status),
        duration: duration);
  }

  static void showInternetError() {
    showSimpleNotification(
        const Text(
          'No internet connection',
          style: TextStyle(fontSize: 20),
        ),
        slideDismissDirection: DismissDirection.up,
        background: Palette.blueGrey,
        duration: const Duration(seconds: 2));
  }

  static void backOnline() {
    showSimpleNotification(
        const Text(
          'Back online',
          style: TextStyle(fontSize: 20),
        ),
        slideDismissDirection: DismissDirection.up,
        background: Palette.green,
        duration: const Duration(seconds: 2));
  }
}
