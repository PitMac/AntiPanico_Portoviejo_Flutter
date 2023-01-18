import 'dart:collection';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MapProvider with ChangeNotifier {
  LatLng? _myPosition;
  List alerts = [];
  List people = [];
  List tokens = [];
  LinkedHashMap? currentUser;
  String? user;

  FirebaseFirestore db = FirebaseFirestore.instance;

  get myPosition => _myPosition;

  Future<List> getTokens() async {
    tokens = [];
    CollectionReference collectionReference = db.collection('UserTokens');
    QuerySnapshot querySnapshot = await collectionReference.get();
    for (var token in querySnapshot.docs) {
      tokens.add(token.data());
    }
    notifyListeners();
    return tokens;
  }

  void sendPushMessage() async {
    try {
      await http.post(Uri.parse('https://fcm.googleapis.com/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':
                'Bearer ya29.a0AX9GBdUbaWSbNa27gAMN3OHk54KB-1nl5kqL40ROaMQOQLWKOVcBoOO8DMv04bRb3DKeO-cVemNF4lPoHrWW06U-wfkONvRil31SFkTriyxtfKLMaoMEqQZwEEMzJcL71wQ0wYqUL4kNxyi6EaSJ2EAoIWL6N-EaCgYKAfYSAQASFQHUCsbCXvlFMDf8nXHWlGti-0GrIg0166'
          },
          body: jsonEncode({
            {
//     "message": {
//         "token": "esSMJTJeRTie0tVs3aeYU_:APA91bFTTkLpEe1lmxrFo42amC7R0wIrJaM9RvIjMP2mCDqAKJRVXmh3UxOfZ5qI_WLGDshIGbh-eIg2djGNxXFjQzDxRARe1ZNoCyDN2kjZb1nf4qkb8yBkaGsd4aC2kBgwi8ylPiAZ",
//         "data": {
//             "body": "Body of Your Notification in data",
//             "title": "Title of Your Notification in data"
//         }
//     }
            }
          }));
    } catch (e) {}
  }

  Future<Position> determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('error');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  void getCurrentLocation() async {
    Position position = await determinePosition();
    _myPosition = LatLng(position.latitude, position.longitude);
    notifyListeners();
  }

  Future<List> getAlerts() async {
    alerts = [];
    CollectionReference collectionReference = db.collection('alertas');
    QuerySnapshot querySnapshot = await collectionReference.get();
    for (var alert in querySnapshot.docs) {
      alerts.add(alert.data());
    }

    return alerts;
  }

  Future<List> getPeople() async {
    people = [];
    CollectionReference collectionReference = db.collection('usuario');
    QuerySnapshot querySnapshot = await collectionReference.get();
    for (var person in querySnapshot.docs) {
      people.add(person.data());
    }
    findUser();
    notifyListeners();
    return people;
  }

  void findUser() {
    currentUser = null;
    for (var element in people) {
      if (element['correo'] == user) {
        currentUser = element;
      }
    }
  }

  Future<void> logOut() async {
    user = null;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
  }
}
