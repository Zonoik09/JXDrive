import 'package:flutter/material.dart';
import 'package:jxdrive/SaveServer.dart';
import 'mainCanvas.dart';
import 'connection.dart';
import 'SaveServer.dart';

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

  bool isConnected = false;
  List<UserData> userDataList = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    userDataList = await Storage.loadUserData();
    setState(() {});
  }

  // Función para manejar la conexión
  void connect() {
    String name = _nameController.text.trim();
    String server = _serverController.text.trim();
    String port = _portController.text.trim();
    String key = _keyController.text.trim();

    if (name.isEmpty || server.isEmpty || port.isEmpty || key.isEmpty) {
      _showErrorDialog("Faltan datos", "Por favor, rellena todos los campos.");
      return;
    }

    setState(() {
      isConnected = true;
    });

    _showSuccessDialog("Conexión exitosa", "Todos los datos están completos.");
  }

  void addUserToFavorites() {
    String name = _nameController.text.trim();
    String server = _serverController.text.trim();
    String port = _portController.text.trim();
    String key = _keyController.text.trim();

    final newUser = UserData(name: name, server: server, port: port, key: key);
    userDataList.add(newUser);

    Storage.saveUserData(userDataList);
    _loadUserData(); // Recargar los datos
  }

  // Función para mostrar un mensaje de error
  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // Función para mostrar un mensaje de éxito
  void _showSuccessDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
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
                                  FilePickerFieldWidget(
                                    labelText: "Clau:",
                                    onFileSelected: (path) {
                                      setState(() {
                                        _keyController.text = path;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 50),
                                  // Botones adicionales en la misma fila
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Botón de borrar de favoritos (papelera)
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          // Acción para borrar de favoritos
                                        },
                                      ),
                                      const SizedBox(width: 20), // Espaciado
                                      // Botón de añadir a favoritos (estrella)
                                      CustomButton(
                                        label: "Afegir a favorits",
                                        onPressed: addUserToFavorites,
                                      ),
                                      const SizedBox(width: 20), // Espaciado
                                      // Botón de conectar
                                      CustomButton(
                                        label: "Conectar",
                                        onPressed: connect,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // ListView debajo de "SERVIDORS FAVORITS"
                            Padding(
                              padding: const EdgeInsets.only(top: 30),
                              child: SizedBox(
                                height: 200, // Ajusta la altura del ListView
                                child: ListView.builder(
                                  itemCount: userDataList.length,
                                  itemBuilder: (context, index) {
                                    final user = userDataList[index];
                                    return ListTile(
                                      title: Text(user.name),
                                      subtitle:
                                          Text('${user.server}:${user.port}'),
                                    );
                                  },
                                ),
                              ),
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
