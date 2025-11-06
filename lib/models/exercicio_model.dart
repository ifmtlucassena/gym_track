import 'serie_model.dart';

class ExercicioModel {
  final String id;
  final String nome;
  final String? grupo_muscular;
  final String? observacao;
  final int? descanso;
  final List<SerieModel> series;
  final int ordem;

  ExercicioModel({
    required this.id,
    required this.nome,
    this.grupo_muscular,
    this.observacao,
    this.descanso,
    this.series = const [],
    this.ordem = 0,
  });

  factory ExercicioModel.fromMap(Map<String, dynamic> map, String id) {
    return ExercicioModel(
      id: id,
      nome: map['nome'] ?? '',
      grupo_muscular: map['grupo_muscular'],
      observacao: map['observacao'],
      descanso: map['descanso'],
      series: (map['series'] as List<dynamic>?)
              ?.asMap()
              .entries
              .map((e) => SerieModel.fromMap(
                  e.value as Map<String, dynamic>, e.key.toString()))
              .toList() ??
          [],
      ordem: map['ordem'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'grupo_muscular': grupo_muscular,
      'observacao': observacao,
      'descanso': descanso,
      'series': series.map((s) => s.toMap()).toList(),
      'ordem': ordem,
    };
  }

  ExercicioModel copyWith({
    String? id,
    String? nome,
    String? grupo_muscular,
    String? observacao,
    int? descanso,
    List<SerieModel>? series,
    int? ordem,
  }) {
    return ExercicioModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      grupo_muscular: grupo_muscular ?? this.grupo_muscular,
      observacao: observacao ?? this.observacao,
      descanso: descanso ?? this.descanso,
      series: series ?? this.series,
      ordem: ordem ?? this.ordem,
    );
  }
}
