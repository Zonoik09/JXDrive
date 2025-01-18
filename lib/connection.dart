import 'package:socket_io_client/socket_io_client.dart' as IO;

class Connection {
  late IO.Socket _socket;
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  Connection();

  // Método para inicializar la conexión
  void connect({
    required String server,
    required String port,
    String? key,
  }) {
    if (server.isEmpty || port.isEmpty) {
      throw ArgumentError("El servidor y el puerto son obligatorios.");
    }

    final url = 'http://$server:$port';

    try {
      _socket = IO.io(
        url,
        IO.OptionBuilder()
            .setTransports(['websocket']) // Usar WebSocket
            .enableForceNew() // Crear una nueva conexión
            .setExtraHeaders(
                {'Authorization': key ?? ''}) // Enviar clave si existe
            .build(),
      );

      _socket.onConnect((_) {
        _isConnected = true;
        print('Conectado al servidor $url');
      });

      _socket.onDisconnect((_) {
        _isConnected = false;
        print('Desconectado del servidor $url');
      });

      _socket.on('error', (data) {
        print('Error del servidor: $data');
      });
    } catch (e) {
      print('Error al intentar conectarse al servidor: $e');
      _isConnected = false;
    }
  }

  // Método para enviar un mensaje al servidor
  void sendMessage(String event, dynamic data) {
    if (_isConnected) {
      _socket.emit(event, data);
      print('Mensaje enviado: $data');
    } else {
      print('No se puede enviar el mensaje: No conectado al servidor');
    }
  }

  // Método para escuchar eventos personalizados
  void onEvent(String event, Function(dynamic) handler) {
    if (_isConnected) {
      _socket.on(event, handler);
    } else {
      print('No se puede registrar el evento: No conectado al servidor');
    }
  }

  // Método para desconectarse del servidor
  void disconnect() {
    if (_isConnected) {
      _socket.disconnect();
      print('Conexión cerrada');
    } else {
      print('No hay conexión activa para cerrar');
    }
  }
}
