import 'package:cash_reader_app/components/retirarDinero.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'consultarSaldo.dart';
import 'ingresarDinero.dart';

import 'package:cash_reader_app/screens/settingsScreen.dart';
import 'package:cash_reader_app/screens/financeScreen.dart';

class Login extends StatefulWidget {
  final VoidCallback onLogin;
  Login({required this.onLogin});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController numeroCelularController = TextEditingController();
  TextEditingController contraseniaController = TextEditingController();
  TextEditingController confirmarContraseniaController = TextEditingController();
  bool isModalOpen = false;

  void handleButtonPress() async {
    // Aquí se puede validar la longitud
    final numeroCelular = numeroCelularController.text;
    final contrasenia = contraseniaController.text;
    // Try catch para manejar errores
    try {
      final response = await http.post(
        Uri.parse('http://54.159.207.236/usuario.php?action=iniciarSesion'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({ // Se toman los datos ingresados para añadir a la petición
          'numeroCelular': numeroCelular,
          'contrasenia': contrasenia,
        }),
      );

      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data['token']); // Debug
        if (data['mensaje'] == "Inicio de sesion exitoso") {
          // Guardar idUsuario y token en SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          prefs.setInt('idUsuario', data['idUsuario']);
          prefs.setString('token', data['token']);
          print('Inicio de sesion exitoso, ID y token guardados en SharedPreferences');
          print(data['token']);

          Navigator.push(context, MaterialPageRoute(builder: (context) => FinanceScreen()));

          // Navigator.push(context, MaterialPageRoute(builder: (context) => ConsultarSaldo()));
          // Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
          // Navigator.push(context, MaterialPageRoute(builder: (context) => IngresarDinero()));
          // Navigator.push(context, MaterialPageRoute(builder: (context) => RetirarDinero()));

        } else {
          print('Error al iniciar sesión token: ${data['mensaje']}');
        }
      } else {
        print('Error al iniciar sesión backend: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al iniciar sesión app: $error');
    }
  }

  void registrarUsuario() async {
    final numeroCelular = numeroCelularController.text;
    final contrasenia = contraseniaController.text;
    final confirmarContrasenia = confirmarContraseniaController.text;

    if (numeroCelular.isNotEmpty && contrasenia.isNotEmpty && contrasenia == confirmarContrasenia) {
      try {
        final response = await http.post(
          Uri.parse('http://54.159.207.236/usuario.php?action=registrarUsuario'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'numeroCelular': numeroCelular,
            'contrasenia': confirmarContrasenia,
          }),
        );

        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['mensaje'] == "Usuario agregado con exito") {
            print("Usuario registrado con éxito");
            Navigator.pop(context); // Cierra el modal
          } else {
            print("Error al registrar el usuario: ${data['mensaje']}");
          }
        } else {
          print("Error al registrar el usuario backend: ${response.statusCode}");
        }
      } catch (error) {
        print('Error al registrar el usuario app: $error');
      }
    } else {
      print('Los campos no deben estar vacíos y las contraseñas deben coincidir');
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
                  controller: numeroCelularController,
                  decoration: InputDecoration(
                    hintText: "Ingrese su número telefónico",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 15),
                TextField(
                  controller: contraseniaController,
                  decoration: InputDecoration(
                    hintText: "Ingrese su contraseña",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 15),
                TextField(
                  controller: confirmarContraseniaController,
                  decoration: InputDecoration(
                    hintText: "Confirme su contraseña",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: registrarUsuario,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(200, 50),
                    padding: EdgeInsets.all(16),
                    backgroundColor: Colors.green, // Padding para el botón
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(color: Colors.black, width: 2),
                    ),
                  ),
                  child: Text(
                      "Registrar",
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                      )
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Lógica para cerrar el modal
                    Navigator.pop(context);
                    isModalOpen = false;
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(200, 50),
                    padding: EdgeInsets.all(16),
                    backgroundColor: Colors.red,// Padding para el botón
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(color: Colors.black, width: 2),
                    ),
                  ),
                  child: Text(
                      "Cerrar",
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                      )
                  ),
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
            minimumSize: Size(200, 50),
            padding: EdgeInsets.all(16),
            backgroundColor: Colors.green,// Padding para el botón
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: Colors.black, width: 2),
            ),
          ),
          child: Text(
              "Ingresar",
              style: TextStyle(
                fontSize: 17,
                color: Colors.black,
              )
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: openModal, // Aquí abrimos el modal
          style: ElevatedButton.styleFrom(
            minimumSize: Size(200, 50),
            padding: EdgeInsets.all(16),
            backgroundColor: Colors.blueAccent, // Padding para el botón
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: Colors.black, width: 2),
            ),
          ),
          child: Text(
            "Registrarse",
            style: TextStyle(
              fontSize: 17,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

