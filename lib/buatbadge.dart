import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

//change to stateful
class BuatBadge extends StatefulWidget {
  const BuatBadge({super.key});

  @override
  State<BuatBadge> createState() => _BuatBadgeState();
}

class _BuatBadgeState extends State<BuatBadge> {
  @override
  void initState() {
    super.initState();

    //step 2. pop-up pemission
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        //alertbox
        AlertDialog alert = AlertDialog(
          title: const Text('Allow Notification'),
          content: const Text('Do you Allow?'),
          actions: [
            TextButton(
                onPressed: () => AwesomeNotifications()
                    .requestPermissionToSendNotifications()
                    .then((_) => Navigator.pop(context)),
                child: const Text('Yes')),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('No')),
          ],
        );
        showDialog(
            context: context,
            builder: (context) {
              return alert;
            });
      }
    });

    //utk dengar Notification kita
    AwesomeNotifications()
        .actionStream
        .listen((ReceivedNotification receivedNotification) {
      //code
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Badge'),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () async {
              //code
              await AwesomeNotifications().createNotification(
                  content: NotificationContent(
                      id: 19,
                      channelKey: 'basic_channel',
                      title: 'Ini Simple Notification',
                      body: 'Ini content utk Notification saya',
                      notificationLayout: NotificationLayout.Default,
                      ));
                      
            },
            child: const Text('Buat Badge')),
      ),
    );
  }
}
