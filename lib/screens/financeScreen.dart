import 'package:flutter/material.dart';
import '../components/login.dart'; // Importa el componente Login
import '../components/ingresarDinero.dart';
import '../components/retirarDinero.dart';
import '../components/consultarSaldo.dart';
class FinanceScreen extends StatefulWidget {
  @override
  _FinanceScreenState createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  bool isLogin = true;

  void onLogin() {
    setState(() {
      isLogin = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Finanzas'),
      ),
      body: Center(
        child: isLogin
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 10), // Agrega margen alrededor del botón
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => IngresarDinero()), // Navegación directa
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200, 50),
                  padding: EdgeInsets.all(16),
                  backgroundColor: Colors.green,
                ),
                child: Text(
                    'Ingresar dinero',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                    )
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RetirarDinero()), // Navegación directa
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200, 50),
                  padding: EdgeInsets.all(16),
                  backgroundColor: Colors.red,
                ),
                child: Text(
                    'Retirar dinero',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                    )
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ConsultarSaldo()), // Navegación directa
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200, 50),
                  padding: EdgeInsets.all(16),
                  backgroundColor: Colors.lightBlueAccent,
                ),
                child: Text(
                    'Consultar dinero',
                    style: TextStyle(
                    fontSize: 17,
                    color: Colors.black,
                  )
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isLogin = false; // Actualiza el estado de inicio de sesión a "false"
                  });
                  //Navigator.pushNamed(context, '/');
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200, 50),
                  padding: EdgeInsets.all(16),
                  backgroundColor: Colors.grey,
                ),
                child: Text(
                    'Cerrar sesión',
                    style: TextStyle(
                    fontSize: 17,
                    color: Colors.black,
                  )
                ),
              ),
            ),
          ],
        )
            : Login(onLogin: onLogin), // Renderiza el componente Login
      ),
    );
  }
}
