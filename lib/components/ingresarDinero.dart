import 'package:flutter/material.dart';
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
  void agregarDinero(double monto, String concepto) {
    if (monto != 0) {
      print('Monto de $monto agregado');
      print('Concepto: $concepto');
      setState(() {
        _isOpen = true;
        _montoController.clear();
        _conceptoController.clear();
      });
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
                double monto = double.tryParse(_montoController.text) ?? 0;
                String concepto = _conceptoController.text;
                agregarDinero(monto, concepto);
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
