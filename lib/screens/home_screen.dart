import 'package:antipanico_portoviejo_flutter/screens/contacts_screen.dart';
import 'package:antipanico_portoviejo_flutter/screens/map_screen.dart';
import 'package:antipanico_portoviejo_flutter/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          onTabChange: (value) => {currentIndex.value = value},
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
    return const Scaffold(
      body: Center(
        child: Text('Home'),
      ),
    );
  }
}
