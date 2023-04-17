import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

enum NotificationStatus { success, error, warning, info }

class OverlayNotificationProvider {
  static Color _setColor(NotificationStatus status) {
    switch (status) {
      case NotificationStatus.success:
        return Colors.green;
      case NotificationStatus.error:
        return Colors.deepPurple;
      case NotificationStatus.warning:
        return Colors.deepPurple;
      case NotificationStatus.info:
        return Colors.blueAccent;
      default:
        return Colors.greenAccent;
    }
  }

  static void showOverlayNotification(String message,
      {NotificationStatus status = NotificationStatus.info}) {
    showSimpleNotification(
      Text(message, style: const TextStyle(fontSize: 20),),
      slideDismissDirection : DismissDirection.up,
      background: _setColor(status),
      duration: const Duration(milliseconds: 800)
    );
  }
}
