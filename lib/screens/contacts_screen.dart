import 'package:antipanico_portoviejo_flutter/providers/map_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mapProvider = Provider.of<MapProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Lista de amigos',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/people');
            },
            icon: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: 50,
                itemBuilder: (context, i) {
                  return Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: listTileAvatar(i, () {
                      Navigator.pushNamed(context, '/student');
                    }),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  ListTile listTileAvatar(int i, VoidCallback callback) {
    return ListTile(
      tileColor: Colors.white,
      trailing: const Icon(Icons.arrow_forward_ios_rounded),
      subtitle: Text('Hellooooo $i'),
      leading: const CircleAvatar(
        backgroundColor: Colors.red,
      ),
      onTap: callback,
      title: Text('Hello $i'),
    );
  }
}
