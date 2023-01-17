import 'package:antipanico_portoviejo_flutter/providers/map_provider.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends HookWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mapProvider = Provider.of<MapProvider>(context);
    useEffect(() {
      // mapProvider.findUser();
      print(mapProvider.user);
      print(mapProvider.currentUser);
      return null;
    }, []);
    return Scaffold(
      appBar: appBarWidget(),
      body: mapProvider.currentUser != null
          ? SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                  SizedBox(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        circleAvatar(mapProvider),
                        const SizedBox(height: 10),
                        Text(
                          '${mapProvider.currentUser!['nombres']} ${mapProvider.currentUser!['apellidos']}',
                          style: const TextStyle(fontSize: 20),
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: logOutButton(mapProvider, context),
    );
  }

  CircleAvatar circleAvatar(MapProvider mapProvider) {
    return CircleAvatar(
      backgroundColor: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
          .withOpacity(1.0),
      radius: 90,
      child: Text(
        '${mapProvider.currentUser!['nombres'][0]}${mapProvider.currentUser!['apellidos'][0]}',
        style: const TextStyle(fontSize: 70, color: Colors.white),
      ),
    );
  }

  TextButton logOutButton(MapProvider mapProvider, BuildContext context) {
    return TextButton(
      onPressed: () {
        mapProvider.logOut();
        Navigator.pushReplacementNamed(context, '/login');
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.exit_to_app, color: Colors.red),
          Text('Cerrar Sesion'),
        ],
      ),
    );
  }

  AppBar appBarWidget() {
    return AppBar(
      centerTitle: true,
      leading: const Icon(
        Icons.crisis_alert_rounded,
        color: Colors.white,
      ),
      backgroundColor: Colors.blueAccent,
      title: const Text(
        'Anti-pánico Portoviejo',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.share,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}
