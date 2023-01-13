import 'package:flutter/material.dart';
import 'dart:math' as math;

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            SizedBox(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  CircleAvatar(
                    backgroundColor:
                        Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                            .withOpacity(1.0),
                    radius: 90,
                    child: const Text(
                      'JZ',
                      style: TextStyle(fontSize: 70, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Jose Jose Zambrano Zambrano',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Divider(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: TextButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.exit_to_app, color: Colors.red),
              Text('Cerrar Sesion'),
            ],
          )),
    );
  }
}
