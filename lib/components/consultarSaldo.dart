import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
    obtenerDatos();
  }

  Future<void> obtenerDatos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        print('Error: token no encontrado');
        return;
      }

      final responseBalance = await http.get(
        Uri.parse('http://54.159.207.236/balance.php?action=obtenerBalance'),
        headers: {'Authorization': 'Bearer $token'},
      );
      print('Response Balance: ${responseBalance.body}');
      final dataBalance = jsonDecode(responseBalance.body);
      setState(() {
        saldo = (dataBalance['balance'] as num).toDouble();
      });

      final responseIngresos = await http.get(
        Uri.parse('http://54.159.207.236/ingreso.php?action=obtenerIngresos'),
        headers: {'Authorization': 'Bearer $token'},
      );
      final dataIngresos = jsonDecode(responseIngresos.body);
      if (dataIngresos['ingresos'] != null && dataIngresos['ingresos'] is List) {
        setState(() {
          ingresos = List<Map<String, dynamic>>.from(dataIngresos['ingresos']);
        });
      } else {
        print('Error: los ingresos devueltos no son un array');
      }

      final responseGastos = await http.get(
        Uri.parse('http://54.159.207.236/gasto.php?action=obtenerGastos'),
        headers: {'Authorization': 'Bearer $token'},
      );
      final dataGastos = jsonDecode(responseGastos.body);
      if (dataGastos['gastos'] != null && dataGastos['gastos'] is List) {
        setState(() {
          gastos = List<Map<String, dynamic>>.from(dataGastos['gastos']);
        });
      } else {
        print('Error: los gastos devueltos no son un array');
      }
    } catch (error) {
      print('Error al obtener los datos: $error');
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