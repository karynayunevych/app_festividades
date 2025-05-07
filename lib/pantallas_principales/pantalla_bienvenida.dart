import 'package:app_festividades/pantallas_principales/pantalla_inicio.dart';
import 'package:app_festividades/pantallas_principales/pantalla_registro.dart';
import 'package:flutter/material.dart';


class PantallaBienvenida extends StatelessWidget {
  const PantallaBienvenida({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -100,
            right: 130,
            child: Image.asset('assets/vector1.png'),
          ),
          Positioned(
            top: 300,
            left: 270,
            child: Image.asset('assets/vector3.png'),
          ),
          Positioned(
            top: 220,
            right: 310,
            child: Image.asset('assets/vector2.png'),
          ),
          Positioned(
            top: -110,
            left: 330,
            child: Image.asset('assets/vector8.png'),
          ),
          Positioned(top: 300, left: 210, child: Image.asset('assets/im1.png')),
          Positioned(
            top: 300,
            left: 270,
            child: Image.asset('assets/vector4.png'),
          ),
          Positioned(
            top: 320,
            left: 330,
            child: Image.asset('assets/vector6.png'),
          ),
          Positioned(
            top: 320,
            left: 200,
            child: Image.asset('assets/vector5.png'),
          ),
          Positioned(
            top: 370,
            left: 240,
            child: Image.asset('assets/vector7.png'),
          ),

          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: 70, right: 180),
              child: Text(
                'Hola!',
                style: TextStyle(
                  fontSize: 108,
                  fontFamily: 'CustomFont',
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 270),
              child: Text(
                'Tienes cuenta?',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'CustomFont',
                  fontSize: 42,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 180),
              child: ElevatedButton(
                onPressed: () {
                  
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PantallaInicio()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 170, vertical: 12),
                  backgroundColor: Color(0xFF662549),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: Text(
                  'Sí',
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'CustomFont',
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 100),
              child: ElevatedButton(
                onPressed: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PantallaRegistro()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 170, vertical: 12),
                  backgroundColor: Color(0xFFC97E87),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: Text(
                  'No',
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'CustomFont',
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
