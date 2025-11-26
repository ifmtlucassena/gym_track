import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/firebase_constants.dart';
import '../models/treino_model.dart';
import '../models/evolucao_models.dart';
import '../models/exercicio_model.dart';
import '../models/serie_model.dart';

class EvolucaoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<TreinoRealizadoModel>> buscarTreinosPorPeriodo(
    String userId,
    DateTime inicio,
    DateTime fim,
  ) async {
    try {
      // Ensure fim is at the end of the day
      final fimAjustado = DateTime(fim.year, fim.month, fim.day, 23, 59, 59);
      final inicioAjustado = DateTime(inicio.year, inicio.month, inicio.day, 0, 0, 0);

      final querySnapshot = await _firestore
          .collection(FirebaseConstants.treinos)
          .where('usuario_id', isEqualTo: userId)
          .where('data_fim', isGreaterThanOrEqualTo: Timestamp.fromDate(inicioAjustado))
          .where('data_fim', isLessThanOrEqualTo: Timestamp.fromDate(fimAjustado))
          .orderBy('data_fim', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => TreinoRealizadoModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Erro ao buscar treinos por período: $e');
      return [];
    }
  }

  MetricasPeriodo calcularMetricas(
    List<TreinoRealizadoModel> treinos,
    DateTime inicio,
    DateTime fim,
    int diasPorSemanaMeta,
  ) {
    int totalTreinos = treinos.length;
    int duracaoTotal = 0;
    double volumeTotal = 0;

    for (var t in treinos) {
      duracaoTotal += t.duracaoMinutos;
      volumeTotal += t.volumeTotalKg;
    }

    int diasPeriodo = fim.difference(inicio).inDays + 1;
    if (diasPeriodo <= 0) diasPeriodo = 1;

    double diasEsperados = (diasPeriodo / 7) * diasPorSemanaMeta;
    if (diasEsperados == 0) diasEsperados = 1;

    double frequencia = (totalTreinos / diasEsperados) * 100;
    if (frequencia > 100) frequencia = 100;

    int sequencia = _calcularSequencia(treinos);

    return MetricasPeriodo(
      totalTreinos: totalTreinos,
      duracaoTotalMinutos: duracaoTotal,
      volumeTotalKg: volumeTotal,
      frequenciaPercentual: frequencia,
      diasSequencia: sequencia,
      comparacaoPeriodoAnterior: 0, // To be implemented with comparison logic
    );
  }

  int _calcularSequencia(List<TreinoRealizadoModel> treinos) {
    if (treinos.isEmpty) return 0;

    // Sort descending just in case
    var sorted = List<TreinoRealizadoModel>.from(treinos)
      ..sort((a, b) => b.dataFim.compareTo(a.dataFim));

    // If last workout was more than 2 days ago, sequence is broken
    if (DateTime.now().difference(sorted.first.dataFim).inDays > 2) {
      return 0;
    }

    int sequencia = 0;
    DateTime? ultimaData;

    for (var treino in sorted) {
      if (ultimaData == null) {
        sequencia = 1;
        ultimaData = treino.dataFim;
        continue;
      }

      final diff = ultimaData.difference(treino.dataFim).inDays;

      if (diff == 0) continue; // Same day

      if (diff <= 2) {
        sequencia++;
        ultimaData = treino.dataFim;
      } else {
        break;
      }
    }
    return sequencia;
  }

  Future<List<PR>> buscarPRs(String userId, {int limite = 5}) async {
    try {
      // Fetch last 6 months for PR calculation
      final sixMonthsAgo = DateTime.now().subtract(const Duration(days: 180));
      final querySnapshot = await _firestore
          .collection(FirebaseConstants.treinos)
          .where('usuario_id', isEqualTo: userId)
          .where('data_fim', isGreaterThanOrEqualTo: Timestamp.fromDate(sixMonthsAgo))
          .orderBy('data_fim', descending: true)
          .get();

      final treinos = querySnapshot.docs
          .map((doc) => TreinoRealizadoModel.fromMap(doc.data(), doc.id))
          .toList();

      Map<String, PR> bestPRs = {};

      // Iterate chronological to find "New" PRs correctly?
      // Or just find the absolute max in the period.
      // The prompt asks for "Seus Recordes Pessoais".
      // Let's find the absolute max per exercise.

      for (var treino in treinos) {
        for (var exercicio in treino.exercicios) {
          double maxWeight = 0;
          int maxWeightReps = 0;

          for (var serie in exercicio.series) {
            if (serie.pesoKg != null && serie.repeticoes > 0) {
              if (serie.pesoKg! > maxWeight) {
                maxWeight = serie.pesoKg!;
                maxWeightReps = serie.repeticoes;
              }
            }
          }

          if (maxWeight > 0) {
            if (!bestPRs.containsKey(exercicio.exercicioId) ||
                maxWeight > bestPRs[exercicio.exercicioId]!.pesoMaximo) {
              
              bestPRs[exercicio.exercicioId] = PR(
                exercicioId: exercicio.exercicioId,
                exercicioNome: exercicio.nome,
                pesoMaximo: maxWeight,
                repeticoes: maxWeightReps,
                data: treino.dataFim,
                isNovo: DateTime.now().difference(treino.dataFim).inDays <= 14,
                diferencaPRAnterior: 0,
              );
            }
          }
        }
      }

      var sortedPRs = bestPRs.values.toList()
        ..sort((a, b) => b.data.compareTo(a.data)); // Recent first

      return sortedPRs.take(limite).toList();
    } catch (e) {
      print('Erro ao buscar PRs: $e');
      return [];
    }
  }

  Future<List<PontoEvolucao>> buscarEvolucaoExercicio(
    String userId,
    String exercicioId,
    DateTime inicio,
    DateTime fim,
  ) async {
    try {
      final treinos = await buscarTreinosPorPeriodo(userId, inicio, fim);
      List<PontoEvolucao> pontos = [];

      for (var treino in treinos) {
        final exercicios = treino.exercicios.where((e) => e.exercicioId == exercicioId);

        for (var exercicio in exercicios) {
          double maxWeight = 0;
          for (var serie in exercicio.series) {
            if (serie.pesoKg != null && serie.pesoKg! > maxWeight) {
              maxWeight = serie.pesoKg!;
            }
          }

          if (maxWeight > 0) {
            pontos.add(PontoEvolucao(
              data: treino.dataFim,
              valor: maxWeight,
              numeroSerie: 0,
              treinoId: treino.id,
            ));
          }
        }
      }

      pontos.sort((a, b) => a.data.compareTo(b.data));
      return pontos;
    } catch (e) {
      print('Erro ao buscar evolução: $e');
      return [];
    }
  }
}
