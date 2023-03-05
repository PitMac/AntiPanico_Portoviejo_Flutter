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
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':
                'key=AAAAJ9iKEI8:APA91bHMpoujnkWsa9d-BfbHr3k5p_2vtCbCTf1qEFwWrdDCfPP1pXQNM45LHi3WppGfjK485brp6StRK7wKyOfIaLhWAqDUR8RpblKtNgCkeYIAiQ-iYrWx9812E746emtegXbvitA4'
          },
          body: jsonEncode({
            "notification": {"title": "Alerta!", "body": "Alerta de Panico"},
            "priority": "high",
            "data": {
              "latitud": _myPosition?.latitude,
              "longitud": _myPosition?.longitude
            },
            "to": "/topics/all"
          }));
    } catch (e) {
      print(e);
    }
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
      notifyListeners();
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

  Future<void> sendAlert(
    String names,
    String lastnames,
  ) async {
    await db.collection("alertas").add({
      "nombres": names,
      "apellidos": lastnames,
      "latitud": _myPosition?.latitude,
      "longitud": _myPosition?.longitude
    });
  }
}
