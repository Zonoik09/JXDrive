import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class MenuArchivos extends StatefulWidget {
  const MenuArchivos({Key? key}) : super(key: key);

  @override
  State<MenuArchivos> createState() => _MenuArchivosState();
}

class _MenuArchivosState extends State<MenuArchivos> {
  String currentPath = Directory.current.path; // Ruta actual
  List<FileSystemEntity> files = []; // Archivos en la ruta actual
  Map<int, bool> hoverStates = {}; // Estado de hover para cada elemento

  @override
  void initState() {
    super.initState();
    _listFiles();
  }

  void _listFiles() {
    final directory = Directory(currentPath);
    setState(() {
      files = directory.listSync();
      hoverStates = {for (int i = 0; i < files.length; i++) i: false};
    });
  }

  void _changeDirectory(String newPath) {
    setState(() {
      currentPath = newPath;
      _listFiles();
    });
  }

  Future<void> _addFile() async {
    ScaffoldMessenger.of(context as BuildContext).showSnackBar(
      const SnackBar(content: Text('Función para añadir archivos')),
    );
  }

  void _deleteFile(FileSystemEntity file) {
    if (file.existsSync()) {
      file.deleteSync();
      _listFiles();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const SizedBox.shrink(), 
        backgroundColor: Colors.purple.shade50,
        elevation: 0, 
        toolbarHeight: 0, 
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    _changeDirectory(Directory(currentPath).parent.path);
                  },
                ),
                Expanded(
                  child: Text(
                    '"${basename(currentPath)}"',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: _addFile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade100, 
                    foregroundColor: Colors.black, 
                  ),
                  child: const Text('Afegir arxius'),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('Ordenar segons: Nom', style: TextStyle(color: Colors.grey)),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: files.isEmpty
                ? const Center(child: Text('No hay archivos ni carpetas'))
                : ListView.builder(
                    itemCount: files.length,
                    itemBuilder: (context, index) {
                      FileSystemEntity file = files[index];
                      bool isDirectory = FileSystemEntity.isDirectorySync(file.path);

                      return MouseRegion(
                        onEnter: (_) {
                          setState(() {
                            hoverStates[index] = true;
                          });
                        },
                        onExit: (_) {
                          setState(() {
                            hoverStates[index] = false; 
                          });
                        },
                        child: ListTile(
                          leading: Icon(
                            isDirectory ? Icons.folder : Icons.insert_drive_file,
                            color: isDirectory ? Colors.blue : Colors.grey,
                          ),
                          title: Text(basename(file.path)), 
                          onTap: isDirectory
                              ? () => _changeDirectory(file.path)
                              : null,
                          trailing: hoverStates[index] ?? false
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (!isDirectory) ...[
                                      IconButton(
                                        icon: const Icon(Icons.download),
                                        onPressed: () {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Descargar ${basename(file.path)}')),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.info),
                                        onPressed: () {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Información de ${basename(file.path)}')),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.fullscreen),
                                        onPressed: () {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Expandir ${basename(file.path)}')),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () => _deleteFile(file),
                                      ),
                                    ],
                                  ],
                                )
                              : null,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
