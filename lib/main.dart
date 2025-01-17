import 'package:flutter/material.dart';
import 'mainCanvas.dart';
import 'connection.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final bool _isHovered = false;
  bool _isFocused = false;

  // Agregar una referencia para la conexión
  late final Connection? _connection;

  @override
  void initState() {
    super.initState();

    // Inicializar la conexión automáticamente
    _connection = Connection();

    // Detectar el enfoque del TextField
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    // Cerrar la conexión si fue creada
    _connection?.disconnect();

    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
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
                                height:
                                    20), // Espaciado entre el título y el lienzo
                            // Usamos Stack para superponer CustomPaint y el TextField
                            Stack(
                              children: [
                                const Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 20, top: 10),
                                    child: Text(
                                      "NOM:",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                // CustomPaint con MainCanvas
                                SizedBox(
                                  width: double.infinity,
                                  height: 100,
                                  child: CustomPaint(
                                    painter: MainCanvas(
                                      isHovered: _isHovered,
                                      isFocused: _isFocused,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  left: 200,
                                  right: 10,
                                  bottom: 10,
                                  child: GestureDetector(
                                    onTap: () {
                                      // Dar foco al TextField cuando el usuario haga clic sobre él
                                      FocusScope.of(context)
                                          .requestFocus(_focusNode);
                                    },
                                    child: TextField(
                                      controller: _controller,
                                      focusNode: _focusNode,
                                      style: const TextStyle(fontSize: 16),
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Introduce tu nombre',
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                      ),
                                      onChanged: (text) {
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ),
                              ],
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
