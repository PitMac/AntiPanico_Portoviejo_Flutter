import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationProvider extends ChangeNotifier {
  String? mtoken;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final StreamController<List<String>> _messageStreamController =
      StreamController.broadcast();

  Stream<List<String>> get messagesStream => _messageStreamController.stream;

  static Future _backgroundHandler(RemoteMessage message) async {
    // print('onBackground Handler ${message.messageId}');
    _messageStreamController.add([message.data['latitud'] ?? 'No title']);
    _messageStreamController.add([message.data['longitud'] ?? 'No title']);
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    // print('_onMessageHandler Handler ${message.messageId}');
    print(message.data);
    _messageStreamController.add([message.data['latitud'] ?? 'No title']);
    _messageStreamController.add([message.data['longitud'] ?? 'No title']);
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    // print('_onMessageOpenApp Handler ${message.messageId}');
    print('WTID');
    _messageStreamController.add([message.data['latitud'] ?? 'No title']);
    _messageStreamController.add([message.data['longitud'] ?? 'No title']);
  }

  NotificationProvider() {
    initializeApp();
  }

  static closeStreams() {
    _messageStreamController.close();
  }

  static Future initializeApp() async {
    // Hnadlers
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);
    //LocalNotification
  }

  requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging
        .subscribeToTopic('all')
        .then((value) => print('Subscribed'));
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

  mostrarNotificacion() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channelId', 'channelName');
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      1,
      'Antipanico-Portoviejo',
      'Toca la notificacion si estas en peligro',
      notificationDetails,
    );
  }

  saveToken(String token, String? user) async {
    await FirebaseFirestore.instance
        .collection("UserTokens")
        .doc(user)
        .set({'token': token});
  }

  getToken(String? user) async {
    await FirebaseMessaging.instance.getToken().then(
          (value) => {mtoken = value, saveToken(value!, user), print(value)},
        );

    notifyListeners();
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
      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
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
      await flutterLocalNotificationsPlugin.show(0, message.notification!.title,
          message.notification!.body, platformChannerSpecifics,
          payload: message.data['body']);
    });
  }
}
