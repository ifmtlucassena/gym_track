import 'package:cloud_firestore/cloud_firestore.dart';
import 'exercicio_model.dart';

class TreinoRealizadoModel {
  final String id;
  final String usuarioId;
  final String fichaId;
  final String diaTreinoId;
  final String nomeTreino;
  final DateTime dataInicio;
  final DateTime dataFim;
  final List<ExercicioModel> exercicios;
  final int duracaoMinutos;
  final String? observacao;

  TreinoRealizadoModel({
    required this.id,
    required this.usuarioId,
    required this.fichaId,
    required this.diaTreinoId,
    required this.nomeTreino,
    required this.dataInicio,
    required this.dataFim,
    this.exercicios = const [],
    required this.duracaoMinutos,
    this.observacao,
  });

  factory TreinoRealizadoModel.fromMap(Map<String, dynamic> map, String id) {
    return TreinoRealizadoModel(
      id: id,
      usuarioId: map['usuario_id'] ?? '',
      fichaId: map['ficha_id'] ?? '',
      diaTreinoId: map['dia_treino_id'] ?? '',
      nomeTreino: map['nome_treino'] ?? '',
      dataInicio: map['data_inicio'] != null
          ? (map['data_inicio'] as Timestamp).toDate()
          : DateTime.now(),
      dataFim: map['data_fim'] != null
          ? (map['data_fim'] as Timestamp).toDate()
          : DateTime.now(),
      exercicios: (map['exercicios'] as List<dynamic>?)
              ?.asMap()
              .entries
              .map((e) => ExercicioModel.fromMap(
                  e.value as Map<String, dynamic>, e.key.toString()))
              .toList() ??
          [],
      duracaoMinutos: map['duracao_minutos'] ?? 0,
      observacao: map['observacao'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'usuario_id': usuarioId,
      'ficha_id': fichaId,
      'dia_treino_id': diaTreinoId,
      'nome_treino': nomeTreino,
      'data_inicio': Timestamp.fromDate(dataInicio),
      'data_fim': Timestamp.fromDate(dataFim),
      'exercicios': exercicios.map((e) => e.toMap()).toList(),
      'duracao_minutos': duracaoMinutos,
      'observacao': observacao,
    };
  }

  TreinoRealizadoModel copyWith({
    String? id,
    String? usuarioId,
    String? fichaId,
    String? diaTreinoId,
    String? nomeTreino,
    DateTime? dataInicio,
    DateTime? dataFim,
    List<ExercicioModel>? exercicios,
    int? duracaoMinutos,
    String? observacao,
  }) {
    return TreinoRealizadoModel(
      id: id ?? this.id,
      usuarioId: usuarioId ?? this.usuarioId,
      fichaId: fichaId ?? this.fichaId,
      diaTreinoId: diaTreinoId ?? this.diaTreinoId,
      nomeTreino: nomeTreino ?? this.nomeTreino,
      dataInicio: dataInicio ?? this.dataInicio,
      dataFim: dataFim ?? this.dataFim,
      exercicios: exercicios ?? this.exercicios,
      duracaoMinutos: duracaoMinutos ?? this.duracaoMinutos,
      observacao: observacao ?? this.observacao,
    );
  }
}
