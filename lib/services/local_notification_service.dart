import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file/open_file.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/jci_logo"),
      iOS: IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification,
      ),
    );
    _notificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: onSelectNotification,
    );
  }

  static Future<dynamic> onDidReceiveLocalNotification(
      int id, title, body, payload) async {
    // display a dialog with the notification details, tap ok to go to another page
  }

  static void display(var message, var progress, var name) async {
    try {
      if (message != null) {
        final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
            "JciGreenCity", //id
            "JciGreenCity channel",

            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
          ),
        );

        var firebaseNotification = message.notification;
        if (firebaseNotification != null) {
          await _notificationsPlugin.show(
            message.hashCode,
            firebaseNotification.title,
            firebaseNotification.body,
            notificationDetails,
          );
        }
      } else {
        final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
            "JciGreenCity", //id
            "JciGreenCity channel",

            importance: Importance.max,
            priority: Priority.high,
            showProgress: true,
            maxProgress: 100,
            progress: progress,
            playSound: true,
          ),
        );

        await _notificationsPlugin.show(0, "Download Complete",
            "File downloaded in download folder", notificationDetails,
            payload: name);
      }
    } on Exception catch (e) {
      // print(e);
    }
  }

  static Future<void> onSelectNotification(String? name) async {
    OpenFile.open("/storage/emulated/0/Download/$name");
  }
}
