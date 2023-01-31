import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';

class Notify {


  static Future<void> createNewNotification() async {

    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: -1, // -1 is replaced by a random number
            channelKey: 'alerts',
            title: 'Remainders',
            body: "New Remainder",
            largeIcon: Emojis.icon_bomb,
            notificationLayout: NotificationLayout.Default,
            payload: {'notificationId': '1234567890'}),
);
  }

  static Future<void> scheduleNewNotification() async {

    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: -1, // -1 is replaced by a random number
            channelKey: 'alerts',
            title: 'Remainders',
            body:'New Remainder',
            largeIcon: Emojis.icon_bomb,
            notificationLayout: NotificationLayout.Default,
            payload: {
              'notificationId': '1234567890'
            }),
        schedule: NotificationCalendar.fromDate(
            date: ,
        )
    );
  }


  static Future<void> retrieveScheduledNotifications() async {
    final AwesomeNotifications awesomeNotifications = AwesomeNotifications();
    List<NotificationModel> scheduledNotifications =
    await awesomeNotifications.listScheduledNotifications();
    print(scheduledNotifications);
  }
}



//                  await Notify.instantNotify();
//                  await Notify.scheduleNotification();
//                  await Notify.retrieveScheduledNotifications();



