import 'dart:io';
import 'package:dartssh2/dartssh2.dart'; // Usamos solo dartssh2

class SSHConnection {
  SSHClient? _client;

  bool get isConnected => _client != null;

  Future<void> connect({
    required String hostWithUsername,
    required String port,
    required String privateKeyPath,
    required Function(String) onError,
    required Function onSuccess,
  }) async {
    try {
      print('Intentando conectar con $hostWithUsername en el puerto $port...');

      // Dividir el username y el host
      final parts = hostWithUsername.split('@');
      if (parts.length != 2) {
        onError('Formato incorrecto para host. Debe ser username@host.');
        print('Error: Formato incorrecto para el host');
        return;
      }
      final username = parts[0];
      final host = parts[1];

      // Verificar si la clave privada existe
      if (!File(privateKeyPath).existsSync()) {
        onError('La clave privada no existe en la ruta proporcionada.');
        print('Error: La clave privada no se encuentra en: $privateKeyPath');
        return;
      }

      // Leer la clave privada
      final privateKey = await File(privateKeyPath).readAsString();

      // Crear un par de claves SSH a partir de la clave privada
      final keyPair = SSHKeyPair.fromPem(privateKey);

      // Intentar conectar al servidor SSH
      final client = SSHClient(
        await SSHSocket.connect(host, int.parse(port)),
        username: username,
        identities: keyPair,
      );

      _client = client;
      print('Conexión SSH establecida con éxito.');
      onSuccess();
    } catch (e, stackTrace) {
      print('Error durante la conexión SSH: $e');
      print('Traza de la pila: $stackTrace');
      onError('Error al conectarse por SSH: $e');
    }
  }

  Future<void> disconnect() async {
    try {
      _client?.close();
      _client = null;
      print('Conexión SSH cerrada.');
    } catch (e) {
      print('Error al cerrar la conexión SSH: $e');
    }
  }
}
