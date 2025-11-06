import 'package:cloud_firestore/cloud_firestore.dart';
import 'dia_treino_model.dart';

class FichaModel {
  final String id;
  final String usuarioId;
  final String nome;
  final String? descricao;
  final String origem;
  final List<DiaTreinoModel> diasTreino;
  final bool ativa;
  final DateTime dataCriacao;
  final DateTime? dataInicio;
  final DateTime? dataFim;

  FichaModel({
    required this.id,
    required this.usuarioId,
    required this.nome,
    this.descricao,
    this.origem = 'customizada',
    this.diasTreino = const [],
    this.ativa = true,
    required this.dataCriacao,
    this.dataInicio,
    this.dataFim,
  });

  factory FichaModel.fromMap(Map<String, dynamic> map, String id) {
    return FichaModel(
      id: id,
      usuarioId: map['usuario_id'] ?? '',
      nome: map['nome'] ?? '',
      descricao: map['descricao'],
      origem: map['origem'] ?? 'customizada',
      diasTreino: (map['dias_treino'] as List<dynamic>?)
              ?.asMap()
              .entries
              .map((e) => DiaTreinoModel.fromMap(
                  e.value as Map<String, dynamic>, e.key.toString()))
              .toList() ??
          [],
      ativa: map['ativa'] ?? true,
      dataCriacao: map['data_criacao'] != null
          ? (map['data_criacao'] as Timestamp).toDate()
          : DateTime.now(),
      dataInicio: map['data_inicio'] != null
          ? (map['data_inicio'] as Timestamp).toDate()
          : null,
      dataFim: map['data_fim'] != null
          ? (map['data_fim'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'usuario_id': usuarioId,
      'nome': nome,
      'descricao': descricao,
      'origem': origem,
      'dias_treino': diasTreino.map((d) => d.toMap()).toList(),
      'ativa': ativa,
      'data_criacao': Timestamp.fromDate(dataCriacao),
      'data_inicio': dataInicio != null ? Timestamp.fromDate(dataInicio!) : null,
      'data_fim': dataFim != null ? Timestamp.fromDate(dataFim!) : null,
    };
  }

  FichaModel copyWith({
    String? id,
    String? usuarioId,
    String? nome,
    String? descricao,
    String? origem,
    List<DiaTreinoModel>? diasTreino,
    bool? ativa,
    DateTime? dataCriacao,
    DateTime? dataInicio,
    DateTime? dataFim,
  }) {
    return FichaModel(
      id: id ?? this.id,
      usuarioId: usuarioId ?? this.usuarioId,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      origem: origem ?? this.origem,
      diasTreino: diasTreino ?? this.diasTreino,
      ativa: ativa ?? this.ativa,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      dataInicio: dataInicio ?? this.dataInicio,
      dataFim: dataFim ?? this.dataFim,
    );
  }
}
