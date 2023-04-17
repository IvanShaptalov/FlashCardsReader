import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

enum NotificationStatus { success, error, warning, info }

class OverlayNotificationProvider {
  static Color _setColor(NotificationStatus status) {
    switch (status) {
      case NotificationStatus.success:
        return Colors.greenAccent;
      case NotificationStatus.error:
        return Colors.redAccent;
      case NotificationStatus.warning:
        return Colors.orangeAccent;
      case NotificationStatus.info:
        return Colors.blueAccent;
      default:
        return Colors.greenAccent;
    }
  }

  static void showOverlayNotification(String message,
      {NotificationStatus status = NotificationStatus.info}) {
    showSimpleNotification(
      Text(message),
      background: _setColor(status),
    );
  }
}
