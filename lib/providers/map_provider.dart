import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapProvider with ChangeNotifier {
  LatLng? _myPosition;
  List alerts = [];
  List people = [];

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
    notifyListeners();
    return alerts;
  }

  Future<List> getPeople() async {
    people = [];
    CollectionReference collectionReference = db.collection('usuario');
    QuerySnapshot querySnapshot = await collectionReference.get();
    for (var person in querySnapshot.docs) {
      people.add(person.data());
    }
    notifyListeners();
    return people;
  }
}
