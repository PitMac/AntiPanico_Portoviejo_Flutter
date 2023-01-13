import 'package:antipanico_portoviejo_flutter/providers/map_provider.dart';
import 'package:antipanico_portoviejo_flutter/screens/contacts_screen.dart';
import 'package:antipanico_portoviejo_flutter/screens/map_screen.dart';
import 'package:antipanico_portoviejo_flutter/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mapProvider = Provider.of<MapProvider>(context);
    useEffect(() {
      mapProvider.getCurrentLocation();
      mapProvider.getAlerts();
      return null;
    }, []);
    final currentIndex = useState(0);
    final screens = [
      const PrincipalScreen(),
      const MapScreen(),
      const ContactsScreen(),
      const SettingsScreen()
    ];
    return Scaffold(
      body: screens[currentIndex.value],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        margin: const EdgeInsets.only(bottom: 2, top: 2),
        child: GNav(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          color: Colors.blueAccent,
          gap: 5,
          tabBackgroundColor: Colors.blueAccent,
          selectedIndex: currentIndex.value,
          tabBorderRadius: 10,
          onTabChange: (value) => {
            mapProvider.getCurrentLocation(),
            currentIndex.value = value,
          },
          tabs: const [
            GButton(
              icon: Icons.crisis_alert_rounded,
              text: 'Inicio',
              iconActiveColor: Colors.white,
              textColor: Colors.white,
            ),
            GButton(
              icon: Icons.map,
              text: 'Mapa',
              iconActiveColor: Colors.white,
              textColor: Colors.white,
            ),
            GButton(
              icon: Icons.contacts_rounded,
              text: 'Contactos',
              iconActiveColor: Colors.white,
              textColor: Colors.white,
            ),
            GButton(
              icon: Icons.settings,
              text: 'Ajustes',
              iconActiveColor: Colors.white,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class PrincipalScreen extends StatelessWidget {
  const PrincipalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blueAccent,
        label: const Text('Alertas'),
        onPressed: () {},
        icon: const Icon(Icons.notification_important),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Pulsa el botón si existe una emergencia:'),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                  padding: MaterialStateProperty.resolveWith(
                    (states) => const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 50),
                  ),
                  backgroundColor: MaterialStateColor.resolveWith(
                    (states) => Colors.redAccent,
                  )),
              onPressed: () {},
              child: const Text(
                'ALERTAR!',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
