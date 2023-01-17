import 'package:antipanico_portoviejo_flutter/providers/map_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class PeopleScreen extends HookWidget {
  const PeopleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mapProvider = Provider.of<MapProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Lista de personas',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: mapProvider.people.isNotEmpty
              ? Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search, color: Colors.white),
                          prefixIconColor: Colors.white,
                          filled: true,
                          fillColor: Colors.blueAccent,
                          focusColor: Colors.blueAccent,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Colors.blueAccent),
                          ),
                          hintStyle: TextStyle(color: Colors.white60),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: mapProvider.people.length,
                        itemBuilder: (context, i) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: listTileAvatar2(
                                mapProvider.people[i]['nombres'],
                                mapProvider.people[i]['apellidos'], () {
                              Navigator.pushNamed(context, '/student');
                            }),
                          );
                        },
                      ),
                    )
                  ],
                )
              : const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  ListTile listTileAvatar2(
      String nombres, String apellidos, VoidCallback callback) {
    return ListTile(
      tileColor: Colors.white,
      trailing: const Icon(Icons.add),
      leading: CircleAvatar(
        backgroundColor: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
            .withOpacity(1.0),
        child: Text(
          '${nombres[0]}${apellidos[0]}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      onTap: callback,
      title: Text('$nombres $apellidos'),
    );
  }
}
