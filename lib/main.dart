import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    // 1/4 de pantalla con el flex
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: const Color(0xFFF9F2FA),
                      ),
                    ),
                    Container( // Línea negra de separación
                      width: 3,
                      color: Colors.black,
                    ),
                    // Resto de la pantalla
                    Expanded(
                      flex: 3,
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
