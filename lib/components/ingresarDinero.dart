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
  void agregarDinero() async {
    final monto = double.tryParse(_montoController.text);
    final concepto = _conceptoController.text;

    if (monto != null && monto != 0) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final idUsuario = prefs.getInt('idUsuario'); // Obtener idUsuario de SharedPreferences

        final response = await http.post(
          Uri.parse('https://lavender-okapi-449526.hostingersite.com/access/ingreso.php?action=registrarIngreso'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'idUsuario': idUsuario,
            'concepto': concepto,
            'monto': monto,
          }),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['mensaje'] == "Ingreso registrado con éxito") {
            print("Ingreso registrado con éxito");
            setState(() {
              _montoController.clear();
              _conceptoController.clear();
            });
          } else {
            print("Error al registrar el ingreso");
          }
        }
      } catch (error) {
        print('Error al registrar el ingreso: $error');
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
