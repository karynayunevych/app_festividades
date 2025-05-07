import 'package:app_festividades/firebase_options.dart';
import 'package:app_festividades/menu/menu_calendario.dart';
import 'package:app_festividades/menu/menu_favoritos.dart';
import 'package:app_festividades/menu/menu_paises.dart';
import 'package:app_festividades/menu/pantalla_menu.dart';
import 'package:app_festividades/pantallas_principales/pantalla_bienvenida.dart';
import 'package:app_festividades/pantallas_principales/pantalla_inicio.dart';
import 'package:app_festividades/pantallas_principales/pantalla_registro.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const PantallaBienvenida(),
        '/home': (context) => const PantallaInicio(),
        '/signup': (context) => const PantallaRegistro(),
        '/menu': (context) => const PantallaMenu(),
        '/paises': (context) => const PantallaPaises(),
        '/favoritos': (context) => const PantallaFavoritos(),
        '/calendario': (context) => const PantallaCalendario(),
      },
    );
  }
}
