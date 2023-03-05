import 'package:antipanico_portoviejo_flutter/providers/map_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

// ignore: constant_identifier_names
const MAPBOX_ACCESS_TOKEN =
    'pk.eyJ1IjoicGl0bWFjIiwiYSI6ImNsY3BpeWxuczJhOTEzbnBlaW5vcnNwNzMifQ.ncTzM4bW-jpq-hUFutnR1g';

class MapScreen extends HookWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mapProvider = Provider.of<MapProvider>(context);
    final myPosition = mapProvider.myPosition;
    final marker = useState<List<Marker>>([]);
    final styleIndex = useState(0);

    void addMarkers() {
      for (var i = -1; i < mapProvider.alerts.length; i++) {
        if (i == -1) {
          final mark = Marker(
            point: myPosition,
            builder: (context) {
              return _myLocationMarker();
            },
          );
          marker.value.add(mark);
        } else {
          final mark = Marker(
            height: 250,
            width: 250,
            point: LatLng(mapProvider.alerts[i]['latitud'],
                mapProvider.alerts[i]['longitud']),
            builder: (context) {
              return _alertLocation();
            },
          );
          marker.value.add(mark);
        }
      }
    }

    useEffect(() {
      addMarkers();
      return null;
    }, []);

    final styles = [
      'mapbox/streets-v12',
      'mapbox/dark-v11',
      'mapbox/light-v11',
      'mapbox/outdoors-v12',
      'mapbox/satellite-v9',
    ];

    return Scaffold(
      body: myPosition != null
          ? FlutterMap(
              options: MapOptions(
                center: myPosition,
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
                  markers: marker.value,
                )
              ],
            )
          : const Center(child: CircularProgressIndicator()),
      floatingActionButton: myPosition == null
          ? null
          : SpeedDial(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
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
              activeChild: const Icon(
                Icons.close,
                color: Colors.white,
              ),
              child: const Icon(
                Icons.swap_horiz_sharp,
                color: Colors.white,
              ),
            ),
    );
  }
}

SizedBox _myLocationMarker() {
  return const SizedBox(
    child: Icon(
      Icons.person_pin_circle,
      color: Colors.blueAccent,
      size: 40,
    ),
  );
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
