import 'package:antipanico_portoviejo_flutter/providers/map_provider.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

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
          ? SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
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
                          Text(
                            '${mapProvider.currentUser!['cedula']}',
                            style: const TextStyle(
                              color: Colors.black38,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            '${mapProvider.currentUser!['correo']}',
                            style: const TextStyle(
                              color: Colors.black26,
                              fontSize: 15,
                            ),
                          ),
                          const Divider(),
                          Column(
                            children: [
                              ListTile(
                                title: Row(
                                  children: const [
                                    Icon(Icons.verified),
                                    SizedBox(width: 10),
                                    Text('Versión de la aplicación'),
                                  ],
                                ),
                                trailing: const Text('1.0.0'),
                              ),
                              ListTile(
                                title: Row(
                                  children: const [
                                    Icon(Icons.info_rounded),
                                    SizedBox(width: 10),
                                    Text('Acerca de...'),
                                  ],
                                ),
                                subtitle: const Text(
                                  'Anti-pánico Portoviejo es una aplicación desarrollada por el grupo de estudiantes de la facultad de ciencias informáticas de la universidad tecnica de Manabí, con el propósito de alerta a los usuarios, dando la seguridad de enviar alertas a personas a su alrededor, teniendo advertida a los usuarios registrados en nuestra aplicación.',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              ListTile(
                                title: Row(
                                  children: const [
                                    Icon(Icons.exit_to_app),
                                    SizedBox(width: 10),
                                    Text('Cerrar sesión'),
                                  ],
                                ),
                                onTap: () {
                                  mapProvider.logOut();
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/login',
                                  );
                                },
                              ),
                              ListTile(
                                title: Row(
                                  children: const [
                                    Icon(Icons.dangerous_rounded),
                                    SizedBox(width: 10),
                                    Text('Eliminar cuenta'),
                                  ],
                                ),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Eliminar cuenta'),
                                        content: const Text(
                                            'Estás seguro de querer eliminar la cuenta?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('No'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Si'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  CircleAvatar circleAvatar(MapProvider mapProvider) {
    return CircleAvatar(
      backgroundColor: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
          .withOpacity(1.0),
      radius: 100,
      child: Text(
        '${mapProvider.currentUser!['nombres'][0]}${mapProvider.currentUser!['apellidos'][0]}',
        style: const TextStyle(fontSize: 70, color: Colors.white),
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
          onPressed: () async {
            await Share.share(
              'Descarga la aplicacion de anti-panico Portoviejo!\nLink: www.anti-panico-Portoviejo.com',
            );
          },
          icon: const Icon(
            Icons.share,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}
