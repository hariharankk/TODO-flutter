import 'package:splashscreen/splashscreen.dart';
import 'package:todolist/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotifications extends StatefulWidget {


  @override
  _LocalNotificationsState createState() => _LocalNotificationsState();
}

class _LocalNotificationsState extends State<LocalNotifications> {

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    requestPermissions();
    var androidSettings = AndroidInitializationSettings('app_icon');

    var initSetttings = InitializationSettings();
    flutterLocalNotificationsPlugin.initialize(initSetttings, onDidReceiveNotificationResponse: (details) =>
        onClickNotification(details.payload));

  }

  void requestPermissions() {
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> onClickNotification(String? payload) {
    return Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreen()));
  }

  showSimpleNotification() async {
    var androidDetails = AndroidNotificationDetails('id', 'channel ', priority: Priority.high, importance: Importance.max);

    var platformDetails = new NotificationDetails();
    await flutterLocalNotificationsPlugin.show(0, 'Flutter Local Notification', 'Flutter Simple Notification',
        platformDetails, payload: 'Destination Screen (Simple Notification)');
  }

  Future<void> showScheduleNotification() async {
    var scheduledNotificationDateTime = DateTime.now().add(Duration(seconds: 5));
    var androidDetails = AndroidNotificationDetails(
      'channel_id',
      'Channel Name',

      icon: 'app_icon',
      largeIcon: DrawableResourceAndroidBitmap('app_icon'),
    );
    var platformDetails = NotificationDetails();
    await flutterLocalNotificationsPlugin.schedule(0, 'Flutter Local Notification', 'Flutter Schedule Notification',
        scheduledNotificationDateTime, platformDetails, payload: 'Destination Screen(Schedule Notification)');
  }

  Future<void> showPeriodicNotification() async {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails('channel_id', 'Channel Name');
    const NotificationDetails notificationDetails = NotificationDetails();
    await flutterLocalNotificationsPlugin.periodicallyShow(0, 'Flutter Local Notification', 'Flutter Periodic Notification',
        RepeatInterval.daily, notificationDetails, payload: 'Destination Screen(Periodic Notification)');
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('')),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                child: Text('Simple Notification'),
                onPressed: () => showSimpleNotification(),
              ),
              SizedBox(height: 15),
              RaisedButton(
                child: Text('Schedule Notification'),
                onPressed: () => showScheduleNotification(),
              ),
              SizedBox(height: 15),
              RaisedButton(
                child: Text('Periodic Notification'),
                onPressed: () => showPeriodicNotification(),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
