import 'package:cloud_firestore/cloud_firestore.dart';

class SerieModel {
  final String id;
  final int numeroSerie;
  final int repeticoes;
  final double? peso;
  final String? observacao;
  final bool concluida;
  final DateTime? dataRealizacao;

  SerieModel({
    required this.id,
    required this.numeroSerie,
    required this.repeticoes,
    this.peso,
    this.observacao,
    this.concluida = false,
    this.dataRealizacao,
  });

  factory SerieModel.fromMap(Map<String, dynamic> map, String id) {
    return SerieModel(
      id: id,
      numeroSerie: map['numero_serie'] ?? 0,
      repeticoes: map['repeticoes'] ?? 0,
      peso: map['peso']?.toDouble(),
      observacao: map['observacao'],
      concluida: map['concluida'] ?? false,
      dataRealizacao: map['data_realizacao'] != null
          ? (map['data_realizacao'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'numero_serie': numeroSerie,
      'repeticoes': repeticoes,
      'peso': peso,
      'observacao': observacao,
      'concluida': concluida,
      'data_realizacao': dataRealizacao != null
          ? Timestamp.fromDate(dataRealizacao!)
          : null,
    };
  }

  SerieModel copyWith({
    String? id,
    int? numeroSerie,
    int? repeticoes,
    double? peso,
    String? observacao,
    bool? concluida,
    DateTime? dataRealizacao,
  }) {
    return SerieModel(
      id: id ?? this.id,
      numeroSerie: numeroSerie ?? this.numeroSerie,
      repeticoes: repeticoes ?? this.repeticoes,
      peso: peso ?? this.peso,
      observacao: observacao ?? this.observacao,
      concluida: concluida ?? this.concluida,
      dataRealizacao: dataRealizacao ?? this.dataRealizacao,
    );
  }
}
