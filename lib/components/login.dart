import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Login extends StatefulWidget {
  final VoidCallback onLogin;

  Login({required this.onLogin});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController numeroCelularController = TextEditingController();
  TextEditingController contraseniaController = TextEditingController();
  bool isModalOpen = false;

  void handleButtonPress() async {
    final numeroCelular = numeroCelularController.text;
    final contrasenia = contraseniaController.text;

    try {
      final response = await http.post(
        Uri.parse('https://cashviewer.000webhostapp.com/access/usuario.php?action=iniciarSesion'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'numeroCelular': numeroCelular, 'contrasenia': contrasenia}),
      );
      final data = jsonDecode(response.body);

      if (data['mensaje'] == "Inicio de sesión exitoso") {
        widget.onLogin();
      } else {
        print("Usuario no existe");
      }
    } catch (error) {
      print('Error al iniciar sesión: $error');
    }
  }

  void openModal() {
    setState(() {
      isModalOpen = true;
    });
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Registro',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Ingrese su número telefónico",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 15),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Ingrese su contraseña",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 15),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Confirme su contraseña",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Lógica para registrar al usuario
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(color: Colors.black, width: 2),
                    ),
                  ),
                  child: Text("Registrar", style: TextStyle(fontSize: 17)),
                ),
              ],
            ),
          ),
        );
      },
    ).whenComplete(() {
      setState(() {
        isModalOpen = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Celular", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        TextField(
          controller: numeroCelularController,
          decoration: InputDecoration(
            hintText: "Ingrese su número telefónico",
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          ),
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: 15),
        Text("Contraseña", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        TextField(
          controller: contraseniaController,
          decoration: InputDecoration(
            hintText: "Ingrese su contraseña",
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          ),
          obscureText: true,
        ),
        SizedBox(height: 30),
        ElevatedButton(
          onPressed: handleButtonPress,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: Colors.black, width: 2),
            ),
          ),
          child: Text("Ingresar", style: TextStyle(fontSize: 17)),
        ),
        ElevatedButton(
          onPressed: openModal, // Aquí abrimos el modal
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: Colors.black, width: 2),
            ),
          ),
          child: Text("Registrarse", style: TextStyle(fontSize: 17)),
        ),
      ],
    );
  }
}
