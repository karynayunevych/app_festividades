import 'package:app_festividades/menu/pantalla_menu.dart';
import 'package:app_festividades/pantallas_principales/pantalla_registro.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PantallaInicio extends StatefulWidget {
  const PantallaInicio({super.key});

  @override
  State<PantallaInicio> createState() => _PantallaInicioState();
}

class _PantallaInicioState extends State<PantallaInicio> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isEmailValid(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  Future<void> signIn() async {
    // Проверка на правильность email
    if (!isEmailValid(_emailController.text.trim())) {
      _showErrorDialog(
        "Correo inválido",
        "Por favor ingresa un correo válido, como ejemplo@correo.com",
      );
      return;
    }

    // Проверка на пустой пароль
    if (_passwordController.text.trim().isEmpty) {
      _showErrorDialog(
        "Contraseña vacía",
        "Por favor ingresa una contraseña.",
      );
      return;
    }

    try {
      // Попытка войти в систему
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = FirebaseAuth.instance.currentUser;

      // Если пользователь не подтвердил email
      if (user != null && !user.emailVerified) {
        await FirebaseAuth.instance.signOut();
        _showErrorDialog(
          "¡Ups!",
          "Parece que aún no has verificado tu correo. Revisa tu bandeja de entrada 😊",
        );
        return;
      }

      // Переход на главный экран
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PantallaMenu()),
      );
    } on FirebaseAuthException catch (e) {
      String mensaje;

      // Обработка ошибок авторизации
      if (e.code == 'user-not-found') {
        mensaje = "No encontramos una cuenta con ese correo 😥";
      } else if (e.code == 'wrong-password') {
        mensaje = "La contraseña parece incorrecta. Intenta nuevamente 💡";
      } else if (e.code == 'invalid-email') {
        mensaje = "Ese formato de correo no parece válido 🙈";
      } else {
        mensaje = "¡Algo salió mal! Intenta de nuevo o más tarde.";
      }

      // Показываем ошибку
      _showErrorDialog("Error al iniciar sesión", mensaje);
    } catch (e) {
      // Ловим другие ошибки, если они есть
      print("Otro error ocurrió: $e");
      _showErrorDialog(
        "Error inesperado",
        "Parece que hubo un problema con tus credenciales 😕\nVerifica tu correo y contraseña.",
      );
    }
  }

  // Функция для отображения ошибки в диалоговом окне
  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text("Entendido"),
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
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: Stack(
        children: [
          Positioned(top: -190, left: 10, child: Image.asset('assets/vector9.png')),
          Positioned(top: -120, right: 200, child: Image.asset('assets/vector10.png')),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 150),
              child: Container(
                width: 380,
                height: 410,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Entrar a mi cuenta',
                      style: TextStyle(fontSize: 35, fontFamily: 'CustomFont'),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Correo',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Contraseña',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: signIn,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 135, vertical: 12),
                        backgroundColor: const Color(0xFF662549),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      ),
                      child: const Text(
                        'Entrar',
                        style: TextStyle(fontSize: 18, fontFamily: 'CustomFont', color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(thickness: 1, color: Colors.grey),
                    const SizedBox(height: 2),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PantallaRegistro()));
                      },
                      child: const Text('¿No tienes cuenta? Crear cuenta', style: TextStyle(color: Colors.black54)),
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
