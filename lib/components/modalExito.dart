import 'package:flutter/material.dart';

class ModalExito extends StatelessWidget {
  final Function(bool) isOpenFunction;

  ModalExito({required this.isOpenFunction});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.black, width: 2),
        ),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(top: 350, left: 10, right: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                '¡Realizado con éxito!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                isOpenFunction(false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF61c26a), // Cambiado de 'primary' a 'backgroundColor'
                padding: EdgeInsets.all(10),
                side: BorderSide(color: Colors.black, width: 2),
              ),
              child: Text(
                'Aceptar',
                style: TextStyle(fontSize: 25),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
