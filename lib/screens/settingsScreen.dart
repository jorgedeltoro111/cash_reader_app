import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Map<String, dynamic>? usuario;
  bool isLoading = true;
  final TextEditingController numeroCelularController = TextEditingController();
  final TextEditingController nuevaContraseniaController = TextEditingController();
  final TextEditingController confirmarContraseniaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  Future<void> fetchUserInfo() async {
    setState(() {
      isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.post(
        Uri.parse('https://cashviewer.000webhostapp.com/access/usuario.php?action=mostrarInformacionUsuario'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['mensaje'] == "Información del usuario obtenida con éxito") {
          setState(() {
            usuario = data['usuario'];
          });
        } else {
          print('Inicie sesión');
        }
      } else {
        throw Exception('Error al hacer la solicitud: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al hacer la solicitud: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> actualizarUsuario() async {
    final numeroCelular = numeroCelularController.text;
    final nuevaContrasenia = nuevaContraseniaController.text;
    final confirmarContrasenia = confirmarContraseniaController.text;

    if (nuevaContrasenia != confirmarContrasenia) {
      print('Las contraseñas no coinciden');
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final idUsuario = prefs.getInt('idUsuario'); // Obtener idUsuario de SharedPreferences

      final response = await http.post(
        Uri.parse('https://lavender-okapi-449526.hostingersite.com/access/usuario.php?action=actualizarUsuario'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'idUsuario': idUsuario,
          'numeroCelular': numeroCelular,
          'contrasenia': nuevaContrasenia,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['mensaje'] == "Usuario actualizado con éxito") {
          print("Usuario modificado con éxito");
          Navigator.pop(context); // Cierra el modal
          fetchUserInfo(); // Actualiza la información del usuario
        } else {
          print("Error al modificar el usuario");
        }
      }
    } catch (error) {
      print('Error al modificar el usuario: $error');
    }
  }

  void abrirModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text('Cambiar Información', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                TextField(
                  controller: numeroCelularController,
                  decoration: InputDecoration(
                    hintText: "Ingrese el nuevo número telefónico",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: nuevaContraseniaController,
                  decoration: InputDecoration(
                    hintText: "Ingrese la nueva contraseña",
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: confirmarContraseniaController,
                  decoration: InputDecoration(
                    hintText: "Confirme la nueva contraseña",
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: actualizarUsuario,
                  child: Text("Actualizar"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuración'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : usuario != null
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Información de usuario',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text('ID de usuario: ${usuario!['idUsuario']}'),
                      Text('Número de celular: ${usuario!['numeroCelular']}'),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: abrirModal, // Botón para abrir el modal
                        child: Text("Cambiar correo y contraseña"),
                      ),
                    ],
                  ),
                )
              : Center(child: Text('Inicie sesión para ver la información.')),
    );
  }
}
