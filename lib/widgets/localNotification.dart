import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService{

  final FlutterLocalNotificationsPlugin notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async{
    print("notification is hiting");
   final AndroidInitializationSettings intializationSettingsAndroid =
        const AndroidInitializationSettings("@mipmap/launcher_icon");

    var initializationSettingIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (
      int id, String? title, String? body, String? payload
      ) async{});

    var initializationSettings = InitializationSettings(
      android: intializationSettingsAndroid,
      iOS: initializationSettingIOS);

    await notificationsPlugin.initialize(initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async{}
    );

  }
  noticationDetails(){
    return const NotificationDetails(
      android: AndroidNotificationDetails('channelId', 'channelName', importance: Importance.max ),
      iOS: DarwinNotificationDetails()
    );
  }

  Future showNotification(
  {int id = 0, String? title, String? body, String? payLoad})async{
    return notificationsPlugin.show(id, title, body, await noticationDetails());
  }

}