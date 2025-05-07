import 'package:app_festividades/menu/pantalla_festividades.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app_festividades/menu/pantalla_menu.dart';
import 'package:app_festividades/menu/menu_account.dart';

class PantallaPaises extends StatelessWidget {
  const PantallaPaises({super.key});

  @override
  Widget build(BuildContext context) {
    final paisesref = FirebaseFirestore.instance.collection('countries');
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Países',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'CustomFont',
            fontSize: 35,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: -400,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/vector16.png',
              width: 600,
              height: 600,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(top: 200),
              child: StreamBuilder<QuerySnapshot>(
                stream: paisesref.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final paises = snapshot.data?.docs ?? [];

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: paises.length,
                    itemBuilder: (context, index) {
                      final pais = paises[index].data() as Map<String, dynamic>;
                      final nombre = pais['name'] ?? 'Sin nombre';

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: Color(0xFFF39F5A).withOpacity(0.7),
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          title: Text(
                            nombre,
                            style: const TextStyle(
                              fontSize: 22,
                              fontFamily: 'CustomFontBold',
                            ),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => PantallaFestividades(
                                      nombrePais: pais['name'],
                                    ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 70,
            height: 70,
            child: FloatingActionButton(
              heroTag: 'homeBtn',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PantallaMenu()),
                );
              },
              child: const Icon(Icons.home, size: 35),
            ),
          ),
          const SizedBox(width: 20),
          SizedBox(
            width: 70,
            height: 70,
            child: FloatingActionButton(
              heroTag: 'accountBtn',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PantallaAccount(),
                  ),
                );
              },
              child: const Icon(Icons.person, size: 35),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
