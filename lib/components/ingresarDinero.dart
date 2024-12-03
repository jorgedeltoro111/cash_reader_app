import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'modalExito.dart'; // Componente ModalExito

class IngresarDinero extends StatefulWidget {
  @override
  _IngresarDineroState createState() => _IngresarDineroState();
}

class _IngresarDineroState extends State<IngresarDinero> {
  final TextEditingController _montoController = TextEditingController();
  final TextEditingController _conceptoController = TextEditingController();
  bool _isOpen = false;

  // Función temporal sin lógica de backend
  void agregarDinero() async {
    final monto = double.tryParse(_montoController.text);
    final concepto = _conceptoController.text;

    if (monto != null && monto != 0) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token'); // Obtener el token de SharedPreferences

        if (token == null) {
          print('Error: token no encontrado');
          return;
        }

        final response = await http.post(
          Uri.parse('http://54.159.207.236/ingreso.php?action=registrarIngreso'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token', // Asegúrate de incluir el token en las cabeceras
          },
          body: jsonEncode({
            'concepto': concepto,
            'monto': monto,
          }),
        );

        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['mensaje'] == "Ingreso registrado con exito") {
            print("Ingreso registrado con éxito");
<<<<<<< HEAD
            setState(() {
              _montoController.clear();
              _conceptoController.clear();
            });
=======
            //mostrar un pop al usuario
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Exito'),
                  content: Text('Ingreso registrado con éxito'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('OK'),
                      onPressed: (){
                        Navigator.of(context).pop();
                        setState(() {
                          _montoController.clear();
                          _conceptoController.clear();
                        });
                      }
                    )
                  ]
                );
              }
            );
>>>>>>> b103f83 (Final version)
          } else {
            print("Error al registrar el ingreso respuesta: ${data['mensaje']}");
          }
        } else {
          print("Error al registrar el ingreso backend: ${response.statusCode}");
        }
      } catch (error) {
        print('Error al registrar el ingreso app: $error');
      }
    } else {
      print('No hay dinero que ingresar');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Agregar Dinero'),
      ),
      body: SingleChildScrollView( // Permite que el contenido sea desplazable si es necesario
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Monto',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _montoController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Ingrese el monto',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Concepto',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _conceptoController,
              decoration: InputDecoration(
                hintText: 'Ingrese el concepto',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                double  monto = double.tryParse(_montoController.text) ?? 0;
                String concepto = _conceptoController.text;
                agregarDinero();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF61c26a),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              child: Text('Agregar dinero'),
            ),
            if (_isOpen)
              Center(
                child: ModalExito(
                  isOpenFunction: (valor) {
                    setState(() {
                      _isOpen = valor;
                    });
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
