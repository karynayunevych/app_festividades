import 'package:app_festividades/pantallas_principales/pantalla_bienvenida.dart';
import 'package:flutter/material.dart';
import 'package:app_festividades/menu/pantalla_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PantallaAccount extends StatelessWidget {
  const PantallaAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Mi cuenta',
          style: TextStyle(
            fontFamily: 'CustomFont',
            fontSize: 35,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: -50,
            left: 150,
            child: Image.asset('assets/vector14.png'),
          ),
          Positioned(
            top: -210,
            right: 10,
            child: Image.asset('assets/vector13.png'),
          ),
          Positioned(
            bottom: -100,
            left: -90,
            child: Image.asset('assets/vector15.png'),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 400,
                  height: 60,
                  padding: const EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                    color: Color(0xFFE8BCB9).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    FirebaseAuth.instance.currentUser?.email ??
                        'No estás conectado',
                    style: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'CustomFontBold',
                      color: Colors.black,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PantallaBienvenida(),
                      ),
                    ); //quiestion
                  },
                  child: Container(
                    width: 400,
                    height: 60,
                    margin: const EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      color: Color(0xFFE8BCB9).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: Colors.black),
                        SizedBox(width: 12),
                        Text(
                          'Salir',
                          style: TextStyle(
                            fontFamily: 'CustomFontBold',
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    try {
                      await FirebaseAuth.instance.currentUser?.delete();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Has eliminado tu cuenta con éxito'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PantallaBienvenida(),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Error al eliminar la cuenta. Reautenticación requirida.',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: 400,
                    height: 60,
                    margin: const EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8BCB9).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: const [
                        Icon(Icons.delete, color: Colors.black),
                        SizedBox(width: 12),
                        Text(
                          'Eliminar cuenta',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'CustomFontBold',
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
