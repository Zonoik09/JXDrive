import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jxdrive/menuArchivos.dart';
import 'package:jxdrive/conection.dart'; // Importar la clase de conexión

class MenuConectado extends StatelessWidget {
  final ServerConnectionManager connection; // Recibe la conexión SSH

  const MenuConectado({super.key, required this.connection});

  @override
  Widget build(BuildContext context) {
    final double topPadding =
        MediaQuery.of(context).padding.top + kMinInteractiveDimensionCupertino;
    final double large = MediaQuery.of(context).size.width / 4;

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        leading: Text('JXDrive'),
        border: null,
        backgroundColor: Colors.white,
        trailing: SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: null,
                child: Icon(CupertinoIcons.power),
              ),
              ElevatedButton(
                onPressed: null,
                child: Icon(CupertinoIcons.arrow_clockwise),
              ),
            ],
          ),
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
                          Expanded(child: MyList()),
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
            child: MenuArchivos(connection: connection), // Pasar conexión SSH
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
