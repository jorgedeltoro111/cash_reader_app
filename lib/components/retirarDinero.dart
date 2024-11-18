import 'dart:convert';
import 'package:http/http.dart' as http;


import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'modalExito.dart'; // Componente ModalExito

class RetirarDinero extends StatefulWidget {
  @override
  _RetirarDineroState createState() => _RetirarDineroState();
}

class _RetirarDineroState extends State<RetirarDinero> {
  final TextEditingController _montoController = TextEditingController();
  final TextEditingController _conceptoController = TextEditingController();
  bool _isOpen = false;

  // Función para manejar la apertura y cierre del modal
  void isOpenFunction(bool valor) {
    setState(() {
      _isOpen = valor;
    });
    if (!valor) {
      Navigator.pop(context);
    }
  }

  // Cascarón de la función para manejar el retiro de dinero (sin lógica de backend)
  void retirarDinero() async {
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
          Uri.parse('http://54.159.207.236/gasto.php?action=registrarGasto'),
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
          if (data['mensaje'] == "Gasto registrado con exito") {
            print("Gasto registrado con éxito");
            setState(() {
              _montoController.clear();
              _conceptoController.clear();
            });
          } else {
            print("Error al registrar el gasto respuesta: ${data['mensaje']}");
          }
        } else {
          print("Error al registrar el gasto backend: ${response.statusCode}");
        }
      } catch (error) {
        print('Error al registrar el gasto app: $error');
      }
    } else {
      print('No hay dinero que gastar');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Retirar Dinero'),
      ),
      body: Padding(
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
                hintText: 'Ingrese el monto a retirar',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {});
              },
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
              onChanged: (value) {
                setState(() {});
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                double monto = double.tryParse(_montoController.text) ?? 0;
                String concepto = _conceptoController.text;
                retirarDinero();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              child: Text('Retirar dinero'),
            ),
            if (_isOpen)
              Center(
                child: ModalExito(
                  isOpenFunction: isOpenFunction,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
