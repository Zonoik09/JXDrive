import 'package:socket_io_client/socket_io_client.dart' as IO;

class Connection {
  late IO.Socket _socket;
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  Connection();

  void connect({
    required String server,
    required String port,
    String? key,
    required Function(String) onError, // Callback para errores
    required Function onSuccess, // Callback para éxito
  }) {
    if (server.isEmpty || port.isEmpty) {
      onError("El servidor y el puerto son obligatorios.");
      return;
    }

    final url = '$server:$port';

    try {
      _socket = IO.io(
        url,
        IO.OptionBuilder()
            .setTransports(['websocket']) // Usar solo WebSocket
            .enableForceNew() // Crear una nueva conexión
            .setExtraHeaders({'Authorization': key ?? ''}) // opcional
            .build(),
      );

      // Evento de conexión exitosa
      _socket.onConnect((_) {
        _isConnected = true;
        onSuccess(); // Llamar al callback de éxito
        print('Conectado al servidor: $url');
      });
    } catch (e) {
      onError('Error al intentar conectarse: $e');
    }
  }

  void disconnect() {
    if (_isConnected) {
      _socket.disconnect();
      print('Conexión cerrada');
    } else {
      print('No hay conexión activa para cerrar');
    }
  }
}
