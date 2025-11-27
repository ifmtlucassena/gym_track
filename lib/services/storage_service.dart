import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadProfileImage(String userId, File imageFile) async {
    try {
      final ref = _storage.ref().child('profile_images').child('$userId.jpg');
      
      // Upload file
      await ref.putFile(imageFile);
      
      // Get download URL
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      print('Erro no upload da imagem: $e');
      throw Exception('Erro ao fazer upload da imagem');
    }
  }
}
