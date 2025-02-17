import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jxdrive/menuArchivos.dart';
import 'package:jxdrive/conection.dart';

class MenuConectado extends StatefulWidget {
  final ServerConnectionManager connection;

  const MenuConectado({super.key, required this.connection});

  @override
  State<MenuConectado> createState() => _MenuConectadoState();
}

class _MenuConectadoState extends State<MenuConectado> {
  final GlobalKey<MenuArchivosState> _menuArchivosKey = GlobalKey(); // Permite acceder al estado

  void _reloadPage() {
    _menuArchivosKey.currentState?.listFiles(); // Recarga archivos sin cambiar de ruta
  }

  @override
  Widget build(BuildContext context) {
    final double large = MediaQuery.of(context).size.width / 4;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: const Text('JXDrive'),
        border: null,
        backgroundColor: Colors.white,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Icon(CupertinoIcons.power, color: Colors.black),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: _reloadPage,
              child: const Icon(CupertinoIcons.arrow_clockwise, color: Colors.black),
            ),
          ],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: large,
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Material(
                      child: Row(
                        children: [
                          const Expanded(child: MyList()),
                          Container(
                            width: 2,
                            color: Colors.black,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: MenuArchivos(key: _menuArchivosKey, connection: widget.connection),
          ),
        ],
      ),
    );
  }
}


class MyList extends StatelessWidget {
  const MyList({super.key});

  @override
  Widget build(BuildContext context) {
    final elementos = ['Recientes', 'Carpetas', 'Eliminados'];

    return ListView.builder(
      itemCount: elementos.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(elementos[index]),
          hoverColor: const Color.fromARGB(255, 235, 215, 238),
          onTap: () {
            print('Seleccionado: ${elementos[index]}');
          },
        );
      },
    );
  }
}
