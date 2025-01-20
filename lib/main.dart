import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jxdrive/SaveServer.dart';
import 'package:jxdrive/conection.dart';
import 'mainCanvas.dart';

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
  String? _message;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    userDataList = await Storage.loadUserData();
    setState(() {});
  }

  void connect() {
    String name = _nameController.text.trim();
    String server = _serverController.text.trim();
    String port = _portController.text.trim();
    String key = _keyController.text.trim();

    if (name.isEmpty) {
      _showMessage("Error", "El nombre es obligatorio.", true);
      return;
    }

    if (server.isEmpty || port.isEmpty) {
      _showMessage("Error", "Servidor y puerto son obligatorios.", true);
      return;
    }
    print('(main connect) Ruta de la clave privada: ${_keyController.text}');
    // Aquí creamos la cadena con el formato "nom@servidor"
    String hostWithUsername = '$name@$server';

    final connection = SSHConnection();
    connection.connect(
      hostWithUsername: hostWithUsername,
      port: port,
      privateKeyPath: key,
      onError: (error) {
        _showMessage("Error de conexión", error, true);
      },
      onSuccess: () {
        setState(() {
          isConnected = true;
        });
        _showMessage(
            "Conexión exitosa", "Te has conectado correctamente.", false);
        //CupertinoPageRoute(builder: (context) => menuconectado());
      },
    );
  }

  void addUserToFavorites() {
    String name = _nameController.text.trim();
    String server = _serverController.text.trim();
    String port = _portController.text.trim();
    String key = _keyController.text.trim();

    if (name.isEmpty || server.isEmpty || port.isEmpty) {
      _showMessage("Faltan datos",
          "Por favor, rellena todos los campos obligatorios.", true);
      return;
    }

    final newUser = UserData(name: name, server: server, port: port, key: key);

    if (userDataList.any(
        (user) => user.name == newUser.name && user.server == newUser.server)) {
      _showMessage("Duplicado", "Este servidor ya está en favoritos.", true);
      return;
    }

    userDataList.add(newUser);
    Storage.saveUserData(userDataList);
    _loadUserData();
    _showMessage(
        "Guardado", "El servidor se agregó a favoritos correctamente.", false);
  }

  void removeUserFromFavorites(int index) {
    userDataList.removeAt(index);
    Storage.saveUserData(userDataList);
    _loadUserData();
  }

  // Función para mostrar el mensaje de éxito o error
  void _showMessage(String title, String message, bool isError) {
    setState(() {
      _message = message;
      _isError = isError;
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
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: const Color(0xFFF9F2FA),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                "SERVIDORS FAVORITS",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: userDataList.length,
                                itemBuilder: (context, index) {
                                  final user = userDataList[index];
                                  return ListTile(
                                    title: Text(user.name),
                                    subtitle:
                                        Text('${user.server}:${user.port}'),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () =>
                                          removeUserFromFavorites(index),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _nameController.text = user.name;
                                        _serverController.text = user.server;
                                        _portController.text = user.port;
                                        _keyController.text = user.key;
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 3,
                      color: Colors.black,
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                            const SizedBox(height: 80),
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
                                      print(
                                          '(main) Ruta de la clave seleccionada: $path');
                                    },
                                  ),
                                  const SizedBox(height: 50),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomButton(
                                        label: "Afegir a favorits",
                                        onPressed: addUserToFavorites,
                                      ),
                                      const SizedBox(width: 20),
                                      CustomButton(
                                        label: "Conectar",
                                        onPressed: connect,
                                      ),
                                    ],
                                  ),
                                  // Mostrar el mensaje debajo de los botones
                                  if (_message != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Text(
                                        _message!,
                                        style: TextStyle(
                                          color: _isError
                                              ? Colors.red
                                              : Colors.green,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
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
