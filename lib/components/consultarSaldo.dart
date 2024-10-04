import 'package:flutter/material.dart';

class ConsultarSaldo extends StatefulWidget {
  @override
  _ConsultarSaldoState createState() => _ConsultarSaldoState();
}

class _ConsultarSaldoState extends State<ConsultarSaldo> {
  double saldo = 0.0;
  List<Map<String, dynamic>> ingresos = [];
  List<Map<String, dynamic>> gastos = [];

  @override
  void initState() {
    super.initState();
    // Aquí se puede llamar la lógica de obtener datos del backend en el futuro
    obtenerDatos();
  }

  // Función temporal para simular la obtención de datos (sin backend)
  void obtenerDatos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final idUsuario = prefs.getInt('idUsuario'); // Obtener idUsuario de SharedPreferences

      final response = await http.get(
        Uri.parse('https://lavender-okapi-449526.hostingersite.com/access/balance.php?action=obtenerBalance'),
        headers: {
          'Content-Type': 'application/json',
          'idUsuario': idUsuario.toString(), // Enviar idUsuario en los headers
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['mensaje'] == "Balance obtenido con éxito") {
          setState(() {
            saldo = data['balance'];
            ingresos = data['ingresos'] ?? [];
            gastos = data['gastos'] ?? [];
          });
        } else {
          print("Error al obtener el balance");
        }
      }
    } catch (error) {
      print('Error al obtener el balance: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFdee7e7),
      appBar: AppBar(
        title: Text('Consultar Saldo'),
        // El botón de retroceso se agregará automáticamente
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.only(top: 100),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0), // Reemplazo de marginBottom
                child: Text(
                  'Saldo actual de $saldo pesos',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                'Historial de ingresos',
                style: TextStyle(
                  fontSize: 25,
                  fontStyle: FontStyle.italic,
                  decoration: TextDecoration.underline,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: ingresos.map((item) {
                  return Text(
                    'Concepto: ${item['concepto']} - monto: ${item['monto']}',
                    style: TextStyle(fontSize: 20),
                  );
                }).toList(),
              ),
              SizedBox(height: 10),
              Text(
                'Historial de gastos',
                style: TextStyle(
                  fontSize: 25,
                  fontStyle: FontStyle.italic,
                  decoration: TextDecoration.underline,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: gastos.map((item) {
                  return Text(
                    'Concepto: ${item['concepto']} - monto: ${item['monto']}',
                    style: TextStyle(fontSize: 20),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
