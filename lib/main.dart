import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:tempahanbilikadmin/authentication.dart';
import 'package:tempahanbilikadmin/buatbadge.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

//utk Authenticate
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:tempahanbilikadmin/pushnotify.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //step 1. Notification
  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      //'resource://drawable/res_notification_app_icon',
      'resource://drawable/ic_launcher',
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: const Color(0xFF9D50DD),
            channelShowBadge: true,
            importance: NotificationImportance.High,
            ledColor: Colors.red)
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupkey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationProvider>(
          create: (_) => AuthenticationProvider(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<AuthenticationProvider>().authState,
          initialData: null,
        ),
      ],
      child: const OverlaySupport(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Material App',
          home: PushNotify(),
          //home: Authenticate(returnClass: const Home(),),
        ),
      ),
    );
  }
}
