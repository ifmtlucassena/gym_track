import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/usuario_model.dart';
import '../core/constants/firebase_constants.dart';

class UsuarioService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UsuarioModel?> getUsuario(String uid) async {
    try {
      final doc = await _firestore
          .collection(FirebaseConstants.usuarios)
          .doc(uid)
          .get();

      if (doc.exists && doc.data() != null) {
        return UsuarioModel.fromFirestore(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      print('Erro ao buscar usuário: $e');
      throw Exception('Erro ao buscar dados do usuário');
    }
  }

  Future<void> salvarUsuario(UsuarioModel usuario) async {
    try {
      await _firestore
          .collection(FirebaseConstants.usuarios)
          .doc(usuario.id)
          .set(usuario.toFirestore());
    } catch (e) {
      print('Erro ao salvar usuário: $e');
      throw Exception('Erro ao salvar dados do usuário');
    }
  }

  Future<void> atualizarUsuario(UsuarioModel usuario) async {
    try {
      await _firestore
          .collection(FirebaseConstants.usuarios)
          .doc(usuario.id)
          .update(usuario.toFirestore());
    } catch (e) {
      print('Erro ao atualizar usuário: $e');
      throw Exception('Erro ao atualizar dados do usuário');
    }
  }
}
