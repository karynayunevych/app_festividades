import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PantallaFavoritos extends StatelessWidget {
  const PantallaFavoritos({super.key});

  @override
  Widget build(BuildContext context) {
    final String uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Favoritos',
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
              'assets/vector17.png',
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
                      .collection('users')
                      .doc(uid)
                      .collection('favorites')
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No hay festividades favoritas.'),
                  );
                }
                final favorites = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: favorites.length,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  itemBuilder: (context, index) {
                    final fest = favorites[index];
                    final nombre = fest['name'] ?? 'Sin nombre';
                    final fecha = fest['date'] ?? 'Sin fecha';
                    final pais = fest['country'] ?? 'Sin pais';

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: const Color(0xFF662549),
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
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          '$fecha - $pais',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'CustomFontBold',
                            color: Colors.white,
                          ),
                        ),
                        trailing: SizedBox(
                          width: 80,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Icon(Icons.favorite, color: Colors.red),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(uid)
                                      .collection('favorites')
                                      .doc(fest.id)
                                      .delete();
                                },
                                child: const Icon(Icons.delete, color: Colors.black,),
                              ),
                            ],
                          ),
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
