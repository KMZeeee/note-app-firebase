import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:note_app/pages/home_page.dart';
import 'package:note_app/pages/login_page.dart';
import 'package:note_app/pages/register_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: 'basic_channel',
      channelName: 'Basic Notifications',
      channelDescription: 'Notification channel for basic tests',
      defaultColor: Colors.white,
      importance: NotificationImportance.Max,
      channelShowBadge: true,
      playSound: true,
      criticalAlerts: true,
    ),
  ], debug: true);

  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textSelectionTheme: const TextSelectionThemeData(
          selectionHandleColor: Colors.blue,
        ),
      ),
      initialRoute: 'login',
      routes: {
        'home': (context) => const HomePage(),
        'login': (context) => const LoginPage(),
        'register': (context) => const RegisterPage(),
      },
    );
  }
}
