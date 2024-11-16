import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  FirebaseStorage storage = FirebaseStorage.instance;

  // Obtener URLs de descarga de los archivos de música
  Future<List<String>> getMusicFiles() async {
    List<String> musicFiles = [];

    try {
      // Referencia a la carpeta de música en Firebase Storage
      final ListResult result = await storage.ref('musica').listAll(); // No necesitas gs://, solo el nombre de la carpeta
      for (var ref in result.items) {
        // Obtener el URL de descarga para cada archivo
        String downloadUrl = await ref.getDownloadURL();
        musicFiles.add(downloadUrl);
      }
    } catch (e) {
      print('Error al obtener archivos de música: $e');
    }

    return musicFiles;
  }
}
