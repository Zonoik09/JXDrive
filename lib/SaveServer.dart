import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart'; // Asegúrate de importar esto

class UserData {
  final String name;
  final String server;
  final String port;
  final String key;

  UserData({
    required this.name,
    required this.server,
    required this.port,
    required this.key,
  });

  // Convertir un objeto UserData en un mapa (JSON)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'server': server,
      'port': port,
      'key': key,
    };
  }

  // Crear un objeto UserData a partir de un mapa (JSON)
  static UserData fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['name'],
      server: json['server'],
      port: json['port'],
      key: json['key'],
    );
  }
}

class Storage {
  // Obtiene la ruta del archivo en el directorio de documentos de la aplicación
  static Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/user_data.json';
  }

  // Cargar los datos de usuario desde el archivo JSON
  static Future<List<UserData>> loadUserData() async {
    final filePath = await _getFilePath();
    final file = File(filePath);

    if (!file.existsSync()) {
      return []; // Si no existe el archivo, retornamos una lista vacía
    }

    final content = await file.readAsString();
    final List<dynamic> jsonData = jsonDecode(content);

    return jsonData.map((data) => UserData.fromJson(data)).toList();
  }

  // Guardar los datos de usuario en el archivo JSON
  static Future<void> saveUserData(List<UserData> users) async {
    final filePath = await _getFilePath();
    final file = File(filePath);

    final List<Map<String, dynamic>> jsonData =
        users.map((user) => user.toJson()).toList();

    await file.writeAsString(jsonEncode(jsonData));
  }
}
