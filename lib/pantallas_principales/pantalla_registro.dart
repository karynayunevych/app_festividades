import 'package:app_festividades/pantallas_principales/pantalla_inicio.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PantallaRegistro extends StatefulWidget {
  const PantallaRegistro({super.key});

  @override
  State<PantallaRegistro> createState() => _PantallaRegistroState();
}

class _PantallaRegistroState extends State<PantallaRegistro> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool isEmailValid(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  Future<void> signUp() async {
    if (!isEmailValid(_emailController.text.trim())) {
      _showErrorDialog("Correo inválido", "Por favor usa un correo como ejemplo@correo.com");
      return;
    }

    if (_passwordController.text.trim() != _confirmPasswordController.text.trim()) {
      _showErrorDialog("Oops", "Las contraseñas no coinciden. Intenta de nuevo 🙂");
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await userCredential.user?.sendEmailVerification();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("¡Registro exitoso! 🎉"),
          content: const Text("Hemos enviado un correo de verificación. ¡Revisa tu bandeja de entrada! 📩"),
          actions: [
            TextButton(
              child: const Text("Entendido"),
              onPressed: () {
                _emailController.clear();
                _passwordController.clear();
                _confirmPasswordController.clear();
                Navigator.pop(context);
                Navigator.pop(context);  // Возвращаемся на экран входа
              },
            ),
          ],
        ),
      );
    } on FirebaseAuthException catch (e) {
      String mensaje = switch (e.code) {
        'email-already-in-use' => "Ya existe una cuenta con este correo 😊",
        'weak-password' => "Tu contraseña debe tener al menos 6 caracteres.",
        'invalid-email' => "Ese correo no parece válido...",
        _ => "Ocurrió un error. Intenta de nuevo más tarde.",
      };

      _showErrorDialog("Error al registrarse", mensaje);
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: Stack(
        children: [
          Positioned(top: -220, child: Image.asset('assets/vector9.png')),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 130),
              child: Container(
                width: 380,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Crear cuenta', style: TextStyle(fontSize: 35, fontFamily: 'CustomFont')),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Correo', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Contraseña', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Confirmar contraseña', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: signUp,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 12),
                        backgroundColor: const Color(0xFF662549),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      ),
                      child: const Text('Registrarse', style: TextStyle(fontSize: 18, fontFamily: 'CustomFont', color: Colors.white)),
                    ),
                    const SizedBox(height: 20),
                    const Divider(thickness: 1, color: Colors.grey),
                    const SizedBox(height: 2),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PantallaInicio()));
                      },
                      child: const Text('¿Ya tienes cuenta? Entrar', style: TextStyle(color: Colors.black54)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
