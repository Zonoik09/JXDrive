import 'package:flutter/material.dart';
import 'package:jxdrive/conection.dart'; // Asegúrate de importar correctamente tu conexión SSH

class PortRedirectWidget extends StatefulWidget {
  final ServerConnectionManager connection;

  const PortRedirectWidget({Key? key, required this.connection})
      : super(key: key);

  @override
  _PortRedirectWidgetState createState() => _PortRedirectWidgetState();
}

class _PortRedirectWidgetState extends State<PortRedirectWidget> {
  final TextEditingController _portController = TextEditingController();
  bool _isRedirected = false;

  Future<void> _toggleRedirection() async {
    final port = _portController.text.trim();
    if (port.isEmpty) {
      _showMessage("Introduce un puerto válido.", Colors.red);
      return;
    }

    try {
      if (_isRedirected) {
        // Eliminar la redirección del puerto 80
        await widget.connection.executeCommand(
            "sudo iptables -t nat -D PREROUTING -p tcp --dport 80 -j REDIRECT --to-port $port");
        _showMessage("Redirección eliminada.", Colors.green);
      } else {
        // Configurar la redirección del puerto 80
        await widget.connection.executeCommand(
            "sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port $port");
        _showMessage("Redirección configurada al puerto $port.", Colors.green);
      }

      setState(() {
        _isRedirected = !_isRedirected;
      });
    } catch (e) {
      _showMessage("Error: $e", Colors.red);
    }
  }

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black, // Fondo negro
      margin: const EdgeInsets.all(1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Bordes redondeados
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Redirección de Puerto 80",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white, // Texto en blanco
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _portController,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                  color: Colors.white), // Texto del input en blanco
              decoration: InputDecoration(
                labelText: "Puerto de destino",
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.grey[900], // Color de fondo del input
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.blueAccent),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _isRedirected ? Colors.red : Colors.blueAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _toggleRedirection,
              child: Text(
                _isRedirected
                    ? "Desactivar Redirección"
                    : "Activar Redirección",
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
