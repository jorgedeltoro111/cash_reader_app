import 'package:flutter/material.dart';
import '../components/login.dart'; // Importa el componente Login

class FinanceScreen extends StatefulWidget {
  @override
  _FinanceScreenState createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  bool isLogin = false;

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
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/ingresarDinero');
                    },
                    child: Text('Ingresar dinero'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/retirarDinero');
                    },
                    child: Text('Retirar dinero'),
                  ),
                ],
              )
            : Login(onLogin: onLogin), // Renderiza el componente Login
      ),
    );
  }
}
