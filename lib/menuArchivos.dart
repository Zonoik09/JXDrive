import 'package:flutter/material.dart';
import 'package:jxdrive/conection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class MenuArchivos extends StatefulWidget {
  final ServerConnectionManager connection;

  const MenuArchivos({Key? key, required this.connection}) : super(key: key);

  @override
  State<MenuArchivos> createState() => _MenuArchivosState();
}

class _MenuArchivosState extends State<MenuArchivos> {
  String currentPath = "/";
  List<Map<String, String>> files = [];
  Map<int, bool> hoverStates = {};

  @override
  void initState() {
    super.initState();
    _listFiles();
  }

  void _listFiles() async {
    try {
      List<Map<String, String>> remoteFiles = await widget.connection.listFiles(currentPath);
      setState(() {
        files = remoteFiles;
        hoverStates = {for (int i = 0; i < files.length; i++) i: false};
      });
    } catch (e) {
      print("Error al obtener archivos: $e");
    }
  }

  void _changeDirectory(String newPath) {
    if (newPath != "/") {
      setState(() {
        currentPath = newPath;
        _listFiles();
      });
    }
  }

  void _goBack() {
    if (currentPath != "/") {
      String parentPath = currentPath.substring(0, currentPath.lastIndexOf("/"));
      if (parentPath.isEmpty) parentPath = "/";
      _changeDirectory(parentPath);
    }
  }

  Future<void> _deleteFile(String fileName) async {
    try {
      await widget.connection.deleteFile("$currentPath/$fileName");
      _listFiles();
    } catch (e) {
      print("Error al eliminar archivo: $e");
    }
  }

  Future<void> _downloadFile(String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      String localPath = "${directory.path}/$fileName";
      await widget.connection.downloadFile("$currentPath/$fileName", localPath);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Archivo $fileName descargado en $localPath')),
      );
    } catch (e) {
      print("Error durante la descarga del archivo: $e");
    }
  }

  Future<void> _uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      String filePath = result.files.single.path!;
      String fileName = result.files.single.name;
      try {
        await widget.connection.uploadFile(filePath, "$currentPath/$fileName");
        _listFiles();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Archivo $fileName subido')),
        );
      } catch (e) {
        print("Error al subir archivo: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _goBack,
            ),
            Text("Archivos en $currentPath"),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: _uploadFile,
          ),
        ],
      ),
      body: files.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: files.length,
              itemBuilder: (context, index) {
                String name = files[index]["name"] ?? "Desconocido";
                bool isDirectory = files[index]["type"] == "directory";

                return MouseRegion(
                  onEnter: (_) => setState(() => hoverStates[index] = true),
                  onExit: (_) => setState(() => hoverStates[index] = false),
                  child: Container(
                    color: hoverStates[index] ?? false ? Color.fromARGB(255, 235, 215, 238) : Colors.transparent,
                    child: ListTile(
                      leading: Icon(
                        isDirectory ? Icons.folder : Icons.insert_drive_file,
                        color: isDirectory ? Colors.blue : Colors.grey,
                      ),
                      title: Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: isDirectory ? () => _changeDirectory("$currentPath/$name") : null,
                      trailing: hoverStates[index] ?? false
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (!isDirectory) ...[
                                  IconButton(
                                    icon: const Icon(Icons.download),
                                    onPressed: () => _downloadFile(name),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => _deleteFile(name),
                                  ),
                                ],
                              ],
                            )
                          : null,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
