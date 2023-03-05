import 'package:antipanico_portoviejo_flutter/providers/map_provider.dart';
import 'package:antipanico_portoviejo_flutter/screens/map_alert_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class AlertsScreen extends HookWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mapProvider = Provider.of<MapProvider>(context);
    useEffect(() {
      mapProvider.getAlerts();
      return null;
    }, []);
    return mapProvider.alerts.isNotEmpty
        ? Scaffold(
            body: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: ListView.builder(
                itemCount: mapProvider.alerts.length,
                itemBuilder: (_, i) {
                  final alert = mapProvider.alerts[i];
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapAlertScreen(
                              alertPosition:
                                  LatLng(alert['latitud'], alert['longitud'])),
                        ),
                      );
                    },
                    leading: const Icon(Icons.add_alert_rounded),
                    title: Text('${alert['nombres']} ${alert['apellidos']}'),
                    subtitle: Text(
                        "Latitud: ${alert['latitud']} ~ Longitud: ${alert['longitud']}"),
                  );
                },
              ),
            ),
          )
        : const Center(
            child: CircularProgressIndicator(
              color: Colors.blueAccent,
            ),
          );
  }
}
