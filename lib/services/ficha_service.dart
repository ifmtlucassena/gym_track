import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/firebase_constants.dart';
import '../models/ficha_model.dart';

class FichaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<FichaModel?> buscarFichaAtiva(String usuarioId) async {
    try {
      final query = await _firestore
          .collection(FirebaseConstants.fichas)
          .where('usuario_id', isEqualTo: usuarioId)
          .where('ativa', isEqualTo: true)
          .limit(1)
          .get();

      if (query.docs.isEmpty) return null;

      return FichaModel.fromMap(query.docs.first.data(), query.docs.first.id);
    } catch (e) {
      // Se a collection não existir ou não tiver índice, retorna null
      if (e.toString().contains('failed-precondition') || 
          e.toString().contains('index')) {
        return null;
      }
      throw Exception('Erro ao buscar ficha ativa: $e');
    }
  }

  Future<List<FichaModel>> buscarFichasUsuario(String usuarioId) async {
    try {
      final query = await _firestore
          .collection(FirebaseConstants.fichas)
          .where('usuario_id', isEqualTo: usuarioId)
          .orderBy('data_criacao', descending: true)
          .get();

      return query.docs
          .map((doc) => FichaModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      // Se a collection não existir ou não tiver índice, retorna lista vazia
      if (e.toString().contains('failed-precondition') || 
          e.toString().contains('index')) {
        return [];
      }
      throw Exception('Erro ao buscar fichas do usuário: $e');
    }
  }

  Future<String> criarFicha(FichaModel ficha) async {
    try {
      final docRef =
          await _firestore.collection(FirebaseConstants.fichas).add(ficha.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Erro ao criar ficha: $e');
    }
  }

  Future<void> atualizarFicha(FichaModel ficha) async {
    try {
      await _firestore
          .collection(FirebaseConstants.fichas)
          .doc(ficha.id)
          .update(ficha.toMap());
    } catch (e) {
      throw Exception('Erro ao atualizar ficha: $e');
    }
  }

  Future<void> deletarFicha(String fichaId) async {
    try {
      await _firestore.collection(FirebaseConstants.fichas).doc(fichaId).delete();
    } catch (e) {
      throw Exception('Erro ao deletar ficha: $e');
    }
  }

  Future<void> desativarFichasAnteriores(String usuarioId, String fichaIdAtual) async {
    try {
      final batch = _firestore.batch();
      final fichas = await _firestore
          .collection(FirebaseConstants.fichas)
          .where('usuario_id', isEqualTo: usuarioId)
          .where('ativa', isEqualTo: true)
          .get();

      for (var doc in fichas.docs) {
        if (doc.id != fichaIdAtual) {
          batch.update(doc.reference, {
            'ativa': false,
            'data_fim': FieldValue.serverTimestamp(),
          });
        }
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Erro ao desativar fichas anteriores: $e');
    }
  }

  Future<void> ativarFicha(String fichaId, String usuarioId) async {
    try {
      // Primeiro desativa todas as fichas do usuário
      await desativarTodasFichas(usuarioId);

      // Depois ativa a ficha selecionada
      await _firestore.collection(FirebaseConstants.fichas).doc(fichaId).update({
        'ativa': true,
        'data_inicio': FieldValue.serverTimestamp(),
        'data_fim': null,
      });
    } catch (e) {
      throw Exception('Erro ao ativar ficha: $e');
    }
  }

  Future<void> desativarFicha(String fichaId) async {
    try {
      await _firestore.collection(FirebaseConstants.fichas).doc(fichaId).update({
        'ativa': false,
        'data_fim': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Erro ao desativar ficha: $e');
    }
  }

  Future<void> desativarTodasFichas(String usuarioId) async {
    try {
      final batch = _firestore.batch();
      final fichas = await _firestore
          .collection(FirebaseConstants.fichas)
          .where('usuario_id', isEqualTo: usuarioId)
          .where('ativa', isEqualTo: true)
          .get();

      for (var doc in fichas.docs) {
        batch.update(doc.reference, {
          'ativa': false,
          'data_fim': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Erro ao desativar todas as fichas: $e');
    }
  }
}
