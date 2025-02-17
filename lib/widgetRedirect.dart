import 'package:flutter/material.dart';
import 'package:jxdrive/conection.dart'; // Asegúrate de importar correctamente tu conexión SSH

class PortRedirectWidget extends StatefulWidget {
  final ServerConnectionManager connection;

  const PortRedirectWidget({Key? key, required this.connection}) : super(key: key);

  @override
  _PortRedirectWidgetState createState() => _PortRedirectWidgetState();
}

class _PortRedirectWidgetState extends State<PortRedirectWidget> {
  final TextEditingController _portController = TextEditingController();
  bool _isRedirected = false;

  Future<void> _toggleRedirection() async {
    final port = _portController.text.trim();
    if (port.isEmpty) {
      _showMessage("Introduce un puerto válido.");
      return;
    }

    try {
      if (_isRedirected) {
        // Eliminar la redirección del puerto 80
        await widget.connection.executeCommand("sudo iptables -t nat -D PREROUTING -p tcp --dport 80 -j REDIRECT --to-port $port");
        _showMessage("Redirección eliminada.");
      } else {
        // Configurar la redirección del puerto 80
        await widget.connection.executeCommand("sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port $port");
        _showMessage("Redirección configurada al puerto $port.");
      }

      setState(() {
        _isRedirected = !_isRedirected;
      });
    } catch (e) {
      _showMessage("Error: $e");
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Redirección de Puerto 80", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            TextField(
              controller: _portController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Puerto de destino",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _toggleRedirection,
              child: Text(_isRedirected ? "Desactivar Redirección" : "Activar Redirección"),
            ),
          ],
        ),
      ),
    );
  }
}
