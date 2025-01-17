import 'package:socket_io_client/socket_io_client.dart' as IO;

class Connection {
  late IO.Socket _socket;

  // Constructor para inicializar la conexión
  Connection() {
    _initializeConnection();
  }

  // Inicializa la conexión con el servidor
  void _initializeConnection() {
    _socket = IO.io(
      'http://localhost:3000',
      IO.OptionBuilder().setTransports(['websocket']) // Usar WebSocket
          .build(),
    );

    // Escuchar cuando se establece la conexión
    _socket.onConnect((_) {
      print('Conectado al servidor');
    });

    // Escuchar eventos de desconexión
    _socket.onDisconnect((_) {
      print('Desconectado del servidor');
    });

    // Escuchar un evento de ejemplo llamado 'response'
    _socket.on('response', (data) {
      print('Respuesta del servidor: $data');
    });
  }

  // Método para enviar un mensaje al servidor
  void sendMessage(String event, dynamic data) {
    if (_socket.connected) {
      _socket.emit(event, data);
      print('Mensaje enviado: $data');
    } else {
      print('No se puede enviar el mensaje: No conectado al servidor');
    }
  }

  // Método para desconectarse del servidor
  void disconnect() {
    _socket.disconnect();
    print('Conexión cerrada');
  }
}
