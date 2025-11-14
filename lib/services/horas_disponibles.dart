import 'package:flutter/material.dart';
//esta clase muestra los horarios solo del dia actual
//
class HorasDisponibles extends StatelessWidget {
  const HorasDisponibles({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Regresa a la pantalla anterior
          },
        ),
        title: const Row(
          children: [
            Icon(Icons.bloodtype, color: Colors.redAccent),
            SizedBox(width: 8),
            Text('HematoLab', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}