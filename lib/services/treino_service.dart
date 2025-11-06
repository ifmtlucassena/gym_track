import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/firebase_constants.dart';
import '../models/treino_model.dart';

class TreinoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<TreinoRealizadoModel?> buscarUltimoTreino(String usuarioId) async {
    try {
      final query = await _firestore
          .collection(FirebaseConstants.treinos)
          .where('usuario_id', isEqualTo: usuarioId)
          .orderBy('data_fim', descending: true)
          .limit(1)
          .get();

      if (query.docs.isEmpty) return null;

      return TreinoRealizadoModel.fromMap(query.docs.first.data(), query.docs.first.id);
    } catch (e) {
      // Se a collection não existir ou não tiver índice, retorna null
      if (e.toString().contains('failed-precondition') || 
          e.toString().contains('index')) {
        return null;
      }
      throw Exception('Erro ao buscar último treino: $e');
    }
  }

  Future<List<TreinoRealizadoModel>> buscarHistoricoTreinos(
    String usuarioId, {
    int limite = 30,
  }) async {
    try {
      final query = await _firestore
          .collection(FirebaseConstants.treinos)
          .where('usuario_id', isEqualTo: usuarioId)
          .orderBy('data_fim', descending: true)
          .limit(limite)
          .get();

      return query.docs
          .map((doc) => TreinoRealizadoModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      // Se a collection não existir ou não tiver índice, retorna lista vazia
      if (e.toString().contains('failed-precondition') || 
          e.toString().contains('index')) {
        return [];
      }
      throw Exception('Erro ao buscar histórico de treinos: $e');
    }
  }

  Future<List<TreinoRealizadoModel>> buscarTreinosPorPeriodo(
    String usuarioId,
    DateTime inicio,
    DateTime fim,
  ) async {
    try {
      final query = await _firestore
          .collection(FirebaseConstants.treinos)
          .where('usuario_id', isEqualTo: usuarioId)
          .where('data_fim', isGreaterThanOrEqualTo: Timestamp.fromDate(inicio))
          .where('data_fim', isLessThanOrEqualTo: Timestamp.fromDate(fim))
          .orderBy('data_fim', descending: true)
          .get();

      return query.docs
          .map((doc) => TreinoRealizadoModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      // Se a collection não existir ou não tiver índice, retorna lista vazia
      if (e.toString().contains('failed-precondition') || 
          e.toString().contains('index')) {
        return [];
      }
      throw Exception('Erro ao buscar treinos por período: $e');
    }
  }

  Future<String> salvarTreino(TreinoRealizadoModel treino) async {
    try {
      final docRef = await _firestore
          .collection(FirebaseConstants.treinos)
          .add(treino.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Erro ao salvar treino: $e');
    }
  }

  Future<void> atualizarTreino(TreinoRealizadoModel treino) async {
    try {
      await _firestore
          .collection(FirebaseConstants.treinos)
          .doc(treino.id)
          .update(treino.toMap());
    } catch (e) {
      throw Exception('Erro ao atualizar treino: $e');
    }
  }

  Future<void> deletarTreino(String treinoId) async {
    try {
      await _firestore
          .collection(FirebaseConstants.treinos)
          .doc(treinoId)
          .delete();
    } catch (e) {
      throw Exception('Erro ao deletar treino: $e');
    }
  }

  Future<int> contarTreinosRealizados(String usuarioId) async {
    try {
      final query = await _firestore
          .collection(FirebaseConstants.treinos)
          .where('usuario_id', isEqualTo: usuarioId)
          .count()
          .get();

      return query.count ?? 0;
    } catch (e) {
      // Se a collection não existir, retorna 0
      if (e.toString().contains('failed-precondition') || 
          e.toString().contains('index')) {
        return 0;
      }
      throw Exception('Erro ao contar treinos: $e');
    }
  }
}
