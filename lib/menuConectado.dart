import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jxdrive/menuArchivos.dart';

class menuconectado extends StatelessWidget {
  const menuconectado({super.key});

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
          // La columna principal
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
                          Expanded(
                            child: MyList(),
                          ),
                          Container(
                            width: 2, // Ancho de la línea
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
          // La subvista Menuarchivos
          Expanded(
            child: MenuArchivos(),
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
    final items = elementos;

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(items[index]),
          hoverColor: const Color.fromARGB(255, 235, 215, 238),
          onTap: () {
            print('object');
          },
        );
      },
    );
  }
}
