import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapProvider with ChangeNotifier {
  LatLng? _myPosition;
  List alerts = [];
  List people = [];
  LinkedHashMap? currentUser;
  String? user;

  FirebaseFirestore db = FirebaseFirestore.instance;

  get myPosition => _myPosition;

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
