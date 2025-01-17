import 'package:flutter/material.dart';
import 'mainCanvas.dart';
import 'connection.dart'; // Asegúrate de importar la clase Connection

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _serverController = TextEditingController();
  final TextEditingController _portController = TextEditingController();
  final TextEditingController _keyController = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _serverFocusNode = FocusNode();
  final FocusNode _portFocusNode = FocusNode();
  final FocusNode _keyFocusNode = FocusNode();

  // Instancia de la clase Connection
  late Connection connection;
  bool isConnected = false;

  @override
  void dispose() {
    // Limpiar los controladores y focus nodes al cerrar la app
    _nameController.dispose();
    _serverController.dispose();
    _portController.dispose();
    _keyController.dispose();
    _nameFocusNode.dispose();
    _serverFocusNode.dispose();
    _portFocusNode.dispose();
    _keyFocusNode.dispose();
    super.dispose();
  }

  // Función para manejar la conexión
  void connect() {
    setState(() {
      connection = Connection(); // Iniciar la conexión
      isConnected = true;
    });
  }

  // Función para manejar la desconexión
  void disconnect() {
    setState(() {
      connection.disconnect(); // Desconectar
      isConnected = false;
      _nameController.clear();
      _serverController.clear();
      _portController.clear();
      _keyController.clear();
    });
  }

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
                    // Panel izquierdo (1/4 de pantalla)
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: const Color(0xFFF9F2FA),
                        child: const Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding:
                                EdgeInsets.only(top: 10), // Espaciado superior
                            child: Text(
                              "SERVIDORS FAVORITS",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Línea negra de separación
                    Container(
                      width: 3,
                      color: Colors.black,
                    ),
                    // Panel derecho (3/4 de pantalla)
                    Expanded(
                      flex: 3,
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Título "CONFIGURACIÓ SSH"
                            const Padding(
                              padding: EdgeInsets.only(top: 10, left: 40),
                              child: Text(
                                "CONFIGURACIÓ SSH",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 80,
                            ), // Espaciado entre el título y los elementos
                            // CustomWidgets debajo del título
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 160.0),
                              child: Column(
                                children: [
                                  CustomTextFieldWidget(
                                    labelText: "Nom:",
                                    controller: _nameController,
                                    focusNode: _nameFocusNode,
                                  ),
                                  const SizedBox(height: 30),
                                  CustomTextFieldWidget(
                                    labelText: "Servidor:",
                                    controller: _serverController,
                                    focusNode: _serverFocusNode,
                                  ),
                                  const SizedBox(height: 30),
                                  CustomTextFieldWidget(
                                    labelText: "Port:",
                                    controller: _portController,
                                    focusNode: _portFocusNode,
                                  ),
                                  const SizedBox(height: 30),
                                  CustomTextFieldWidget(
                                    labelText: "Clau:",
                                    controller: _keyController,
                                    focusNode: _keyFocusNode,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            // Botón para conectar
                            ElevatedButton(
                              onPressed: isConnected
                                  ? null
                                  : connect, // Siempre se puede conectar
                              child: const Text("Connectar"),
                            ),
                            const SizedBox(height: 10),
                            // Botón para desconectar
                            ElevatedButton(
                              onPressed: isConnected
                                  ? disconnect
                                  : null, // Se puede desconectar si está conectado
                              child: const Text("Desconnectar"),
                            ),
                          ],
                        ),
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
