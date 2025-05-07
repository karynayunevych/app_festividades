import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void agregarACalendario(String pais, String nombre, String fecha) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    print('Usuario no autentificado');
    return;
  }

  final docID = '${nombre}_$pais';
  await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('calendar')
      .doc(docID)
      .set({'name': nombre, 'date': fecha, 'country': pais});

  print('Añadido al calendario');
}

void agregarAFavoritos(String pais, String nombre, String fecha) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    print('Usuario no autentificado');
    return;
  }

  final docID = '${nombre}_$pais';
  await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('favorites')
      .doc(docID)
      .set({'name': nombre, 'date': fecha, 'country': pais});

  print('Añadido a favoritos');
}

class PantallaFestividades extends StatelessWidget {
  String normalizar(String nombre) {
    final Map<String, String> reemplazos = {
      'á': 'a',
      'é': 'e',
      'í': 'i',
      'ó': 'o',
      'ú': 'u',
      'ñ': 'n',
      'Á': 'a',
      'É': 'e',
      'Í': 'i',
      'Ó': 'o',
      'Ú': 'u',
      'Ñ': 'n',
    };
    return nombre.split('').map((c) => reemplazos[c] ?? c).join().toLowerCase().replaceAll(' ', '_');
  }

  final String nombrePais;

  const PantallaFestividades({super.key, required this.nombrePais});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Festividades de $nombrePais',
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

          Padding(
            padding: const EdgeInsets.only(top: 200),
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('countries')
                      .doc(normalizar(nombrePais))
                      .collection('holidays')
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No hay festividades.'));
                }
                final festividades = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: festividades.length,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  itemBuilder: (context, index) {
                    final fest = festividades[index];
                    final nombre = fest['name'] ?? 'Sin nombre';
                    final fecha = fest['date'] ?? 'Sin fecha';

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: const Color(0xFFEBBCB9),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        title: Text(
                          nombre,
                          style: const TextStyle(
                            fontSize: 22,
                            fontFamily: 'CustomFontBold',
                          ),
                        ),
                        subtitle: Text(
                          fecha,
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'CustomFontBold',
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                agregarAFavoritos(nombrePais, nombre, fecha);
                              },
                              icon: const Icon(
                                Icons.favorite_border,
                                color: Colors.red,
                              ),
                            ),
                            SizedBox(width: 10),
                            IconButton(
                              onPressed: () {
                                agregarACalendario(nombrePais, nombre, fecha);
                              },
                              icon: const Icon(Icons.calendar_today, color: Colors.blue,),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
