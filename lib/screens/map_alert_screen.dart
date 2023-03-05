import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// ignore: constant_identifier_names
const MAPBOX_ACCESS_TOKEN =
    'pk.eyJ1IjoicGl0bWFjIiwiYSI6ImNsY3BpeWxuczJhOTEzbnBlaW5vcnNwNzMifQ.ncTzM4bW-jpq-hUFutnR1g';

class MapAlertScreen extends HookWidget {
  MapAlertScreen({super.key, required this.alertPosition});
  LatLng alertPosition;

  @override
  Widget build(BuildContext context) {
    final styleIndex = useState(0);

    final styles = [
      'mapbox/streets-v12',
      'mapbox/dark-v11',
      'mapbox/light-v11',
      'mapbox/outdoors-v12',
      'mapbox/satellite-v9',
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: const Text(
          'Alerta',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: alertPosition,
          minZoom: 5,
          maxZoom: 25,
          zoom: 18,
        ),
        nonRotatedChildren: [
          TileLayer(
            urlTemplate:
                'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
            additionalOptions: {
              'accessToken': MAPBOX_ACCESS_TOKEN,
              'id': styles[styleIndex.value],
            },
          ),
          MarkerLayer(
            markers: [
              Marker(
                width: 220,
                height: 220,
                point: alertPosition,
                builder: (context) {
                  return _alertLocation();
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}

Stack _alertLocation() {
  return Stack(
    children: [
      Container(
        height: 250,
        width: 250,
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      const Center(
        child: SizedBox(
          height: 25,
          width: 25,
          child: Icon(
            Icons.live_help,
            color: Colors.red,
          ),
        ),
      ),
    ],
  );
}
