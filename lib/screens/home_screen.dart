import 'dart:async';

import 'package:antipanico_portoviejo_flutter/providers/map_provider.dart';
import 'package:antipanico_portoviejo_flutter/screens/contacts_screen.dart';
import 'package:antipanico_portoviejo_flutter/screens/map_screen.dart';
import 'package:antipanico_portoviejo_flutter/screens/settings_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mapProvider = Provider.of<MapProvider>(context);
    final isDeviceConnected = useState<bool>(false);
    final isAlertSet = useState<bool>(false);
    final subscription = useState<StreamSubscription?>(null);
    final mtoken = useState<String?>(null);
    late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    showDialogBox() {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('No tiene conexión'),
            content: const Text('Por favor verificar su conexión a Internet'),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  isAlertSet.value = false;
                  isDeviceConnected.value =
                      await InternetConnectionChecker().hasConnection;
                  if (!isDeviceConnected.value) {
                    showDialogBox();
                    isAlertSet.value = true;
                  } else {
                    mapProvider.getPeople();
                  }
                },
                child: const Text('Ok'),
              )
            ],
          );
        },
      );
    }

    getConnectivity() =>
        subscription.value = Connectivity().onConnectivityChanged.listen(
          ((event) async {
            isDeviceConnected.value =
                await InternetConnectionChecker().hasConnection;
            if (!isDeviceConnected.value && isAlertSet.value == false) {
              showDialogBox();
              isAlertSet.value = true;
            }
          }),
        );

    requestPermission() async {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: false,
        criticalAlert: true,
        provisional: false,
        sound: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted permission');
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        print('User granted provisional permission');
      } else {
        print('User declined or has not accepted permission');
      }
    }

    saveToken(String token) async {
      await FirebaseFirestore.instance
          .collection("UserTokens")
          .doc(mapProvider.user)
          .set({'token': token});
    }

    getToken() async {
      await FirebaseMessaging.instance.getToken().then(
            (value) => {
              mtoken.value = value,
              print("My token is ${mtoken.value}"),
              print(mapProvider.tokens),
              saveToken(value!)
            },
          );
    }

    initInfo() {
      var androidInitialize =
          const AndroidInitializationSettings('@mipmap/ic_launcher');
      var initializationSettings =
          InitializationSettings(android: androidInitialize);
      flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onSelectNotification: (payload) async {
          try {
            if (payload != null && payload.isNotEmpty) {
            } else {}
          } catch (e) {}
          return;
        },
      );

      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        BigTextStyleInformation bigTextStyleInformation =
            BigTextStyleInformation(
          message.notification!.body.toString(),
          htmlFormatBigText: true,
          contentTitle: message.notification!.title.toString(),
          htmlFormatContentTitle: true,
        );
        AndroidNotificationDetails androidNotificationDetails =
            AndroidNotificationDetails(
          'panico',
          'panico',
          importance: Importance.max,
          styleInformation: bigTextStyleInformation,
          priority: Priority.max,
          playSound: true,
        );

        NotificationDetails platformChannerSpecifics =
            NotificationDetails(android: androidNotificationDetails);
        await flutterLocalNotificationsPlugin.show(
            0,
            message.notification!.title,
            message.notification!.body,
            platformChannerSpecifics,
            payload: message.data['body']);
      });
    }

    useEffect(() {
      mapProvider.getCurrentLocation();
      mapProvider.getAlerts();
      mapProvider.getPeople();
      mapProvider.getTokens();
      requestPermission();
      getToken();
      initInfo();
      getConnectivity();
      return () {
        subscription.value?.cancel();
      };
    }, [mapProvider.myPosition]);

    final currentIndex = useState(0);
    final screens = [
      const PrincipalScreen(),
      const MapScreen(),
      const ContactsScreen(),
      const SettingsScreen()
    ];
    return mapProvider.myPosition != null && mapProvider.tokens.isNotEmpty
        ? Scaffold(
            body: screens[currentIndex.value],
            bottomNavigationBar: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              margin: const EdgeInsets.only(bottom: 2, top: 2),
              child: GNav(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                color: Colors.blueAccent,
                gap: 5,
                tabBackgroundColor: Colors.blueAccent,
                selectedIndex: currentIndex.value,
                tabBorderRadius: 10,
                onTabChange: (value) => {
                  currentIndex.value = value,
                },
                tabs: const [
                  GButton(
                    icon: Icons.crisis_alert_rounded,
                    text: 'Inicio',
                    iconActiveColor: Colors.white,
                    textColor: Colors.white,
                  ),
                  GButton(
                    icon: Icons.map,
                    text: 'Mapa',
                    iconActiveColor: Colors.white,
                    textColor: Colors.white,
                  ),
                  GButton(
                    icon: Icons.contacts_rounded,
                    text: 'Contactos',
                    iconActiveColor: Colors.white,
                    textColor: Colors.white,
                  ),
                  GButton(
                    icon: Icons.settings,
                    text: 'Ajustes',
                    iconActiveColor: Colors.white,
                    textColor: Colors.white,
                  ),
                ],
              ),
            ),
          )
        : const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}

class PrincipalScreen extends HookWidget {
  const PrincipalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mapProvider = Provider.of<MapProvider>(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blueAccent,
        label: const Text('Alertas'),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return mapProvider.alerts.isNotEmpty
                  ? SizedBox(
                      height: 600,
                      child: ListView.builder(
                        itemCount: mapProvider.alerts.length,
                        itemBuilder: (_, i) {
                          final alert = mapProvider.alerts[i];
                          return ListTile(
                            leading: const Icon(Icons.add_alert_rounded),
                            title: Text(
                                '${alert['nombres']} ${alert['apellidos']}'),
                            subtitle: Text(
                                "Latitud: ${alert['latitud']} ~ Longitud: ${alert['longitud']}"),
                          );
                        },
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    );
            },
          );
        },
        icon: const Icon(Icons.notification_important),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Pulsa el botón si existe una emergencia:'),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                  padding: MaterialStateProperty.resolveWith(
                    (states) => const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 50),
                  ),
                  backgroundColor: MaterialStateColor.resolveWith(
                    (states) => Colors.redAccent,
                  )),
              onPressed: () {},
              child: const Text(
                'ALERTAR!',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
