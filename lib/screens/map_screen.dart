import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:latlong2/latlong.dart';

const MAPBOX_ACCESS_TOKEN =
    'pk.eyJ1IjoicGl0bWFjIiwiYSI6ImNsY3BpeWxuczJhOTEzbnBlaW5vcnNwNzMifQ.ncTzM4bW-jpq-hUFutnR1g';

final _myLocation = LatLng(-1.0601653, -80.4661612);
final _myLocation2 = LatLng(-1.0604826, -80.4667615);
final _myLocation3 = LatLng(-1.0596077, -80.468792);

class MapScreen extends HookWidget {
  const MapScreen({super.key});

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
      body: FlutterMap(
        options: MapOptions(
          center: _myLocation,
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
                point: _myLocation,
                builder: (context) {
                  return const _MyLocationMarker();
                },
              ),
              Marker(
                point: _myLocation2,
                builder: (context) {
                  return const _MyLocationMarker2();
                },
              ),
              Marker(
                point: _myLocation3,
                builder: (context) {
                  return const _MyLocationMarker2();
                },
              ),
            ],
          )
        ],
      ),
      floatingActionButton: SpeedDial(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        children: [
          SpeedDialChild(
            labelBackgroundColor:
                styleIndex.value == 0 ? Colors.blueAccent[100] : null,
            label: 'Calle',
            onTap: () => styleIndex.value = 0,
          ),
          SpeedDialChild(
            labelBackgroundColor:
                styleIndex.value == 1 ? Colors.blueAccent[100] : null,
            label: 'Oscuro',
            onTap: () => styleIndex.value = 1,
          ),
          SpeedDialChild(
            labelBackgroundColor:
                styleIndex.value == 2 ? Colors.blueAccent[100] : null,
            label: 'Claro',
            onTap: () => styleIndex.value = 2,
          ),
          SpeedDialChild(
            labelBackgroundColor:
                styleIndex.value == 3 ? Colors.blueAccent[100] : null,
            label: 'Fuera',
            onTap: () => styleIndex.value = 3,
          ),
          SpeedDialChild(
            labelBackgroundColor:
                styleIndex.value == 4 ? Colors.blueAccent[100] : null,
            label: 'Satelite',
            onTap: () => styleIndex.value = 4,
          ),
        ],
        activeChild: const Icon(Icons.close),
        child: const Icon(Icons.swap_horiz_sharp),
      ),
    );
  }
}

class _MyLocationMarker extends StatelessWidget {
  const _MyLocationMarker();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration:
          const BoxDecoration(color: Colors.blueAccent, shape: BoxShape.circle),
    );
  }
}

class _MyLocationMarker2 extends StatelessWidget {
  const _MyLocationMarker2();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration:
          const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
    );
  }
}
