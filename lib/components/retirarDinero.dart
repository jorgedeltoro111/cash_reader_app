import 'package:flutter/material.dart';
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
        final idUsuario = prefs.getInt('idUsuario'); // Obtener idUsuario de SharedPreferences

        final response = await http.post(
          Uri.parse('https://lavender-okapi-449526.hostingersite.com/access/gasto.php?action=registrarGasto'),
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
          if (data['mensaje'] == "Gasto registrado con éxito") {
            print("Gasto registrado con éxito");
            setState(() {
              _montoController.clear();
              _conceptoController.clear();
            });
          } else {
            print("Error al registrar el gasto");
          }
        }
      } catch (error) {
        print('Error al registrar el gasto: $error');
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
                retirarDinero(monto, concepto);
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
