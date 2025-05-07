import 'package:app_festividades/menu/menu_account.dart';
import 'package:app_festividades/menu/menu_calendario.dart';
import 'package:app_festividades/menu/menu_favoritos.dart';
import 'package:app_festividades/menu/menu_paises.dart';
import 'package:flutter/material.dart';

class PantallaMenu extends StatelessWidget {
  const PantallaMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Menu',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'CustomFont',
            fontSize: 35,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          // фон-картинка как в регистрации
          Positioned(
            top: -220,
            left: 0,
            right: 0,
            child: Image.asset('assets/vector9.png'),
          ),
          Positioned(
            bottom: -40, // смещаем вниз за пределы
            right: -290, // смещаем вправо за пределы
            child: Image.asset(
              'assets/vector12.png',
              width: 500, // размер как хочешь
              height: 500,
              // важно: не ограничивает размер
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 400,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PantallaPaises(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFAE445A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: const Text(
                      'Países',
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'CustomFontBold',
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 400,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PantallaCalendario(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF39F5A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: const Text(
                      'Calendario',
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'CustomFontBold',
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 400,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PantallaFavoritos(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE8BCB9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: const Text(
                      'Favoritos',
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'CustomFontBold',
                        color: Colors.black,
                      ),
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
