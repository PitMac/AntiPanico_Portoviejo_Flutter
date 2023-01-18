import 'package:antipanico_portoviejo_flutter/providers/map_provider.dart';
import 'package:antipanico_portoviejo_flutter/providers/validation_provider.dart';
import 'package:antipanico_portoviejo_flutter/routes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroungHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroungHandler);
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? user = prefs.getString('user');
  runApp(MyApp(user: user));
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  String? user;
  MyApp({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ValidationProvider()),
        ChangeNotifierProvider(
          create: (context) => MapProvider(),
        ),
      ],
      child: Builder(
        builder: (context) {
          final mapProvider = Provider.of<MapProvider>(context);
          mapProvider.user = user;
          return MaterialApp(
            title: 'Antipanico Portoviejo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(useMaterial3: true),
            initialRoute: user == null ? '/login' : '/home',
            routes: routes,
          );
        },
      ),
    );
  }
}
