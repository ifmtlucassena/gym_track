import 'exercicio_model.dart';

class DiaTreinoModel {
  final String id;
  final String nome;
  final String? descricao;
  final int diaSemana;
  final List<ExercicioModel> exercicios;
  final int ordem;

  DiaTreinoModel({
    required this.id,
    required this.nome,
    this.descricao,
    required this.diaSemana,
    this.exercicios = const [],
    this.ordem = 0,
  });

  factory DiaTreinoModel.fromMap(Map<String, dynamic> map, String id) {
    return DiaTreinoModel(
      id: id,
      nome: map['nome'] ?? '',
      descricao: map['descricao'],
      diaSemana: map['dia_semana'] ?? 1,
      exercicios: (map['exercicios'] as List<dynamic>?)
              ?.asMap()
              .entries
              .map((e) => ExercicioModel.fromMap(
                  e.value as Map<String, dynamic>, e.key.toString()))
              .toList() ??
          [],
      ordem: map['ordem'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'descricao': descricao,
      'dia_semana': diaSemana,
      'exercicios': exercicios.map((e) => e.toMap()).toList(),
      'ordem': ordem,
    };
  }

  int get duracaoEstimada {
    int total = 0;
    for (var exercicio in exercicios) {
      total += exercicio.series.length * 2;
      total += (exercicio.descanso ?? 60) * exercicio.series.length ~/ 60;
    }
    return total;
  }

  DiaTreinoModel copyWith({
    String? id,
    String? nome,
    String? descricao,
    int? diaSemana,
    List<ExercicioModel>? exercicios,
    int? ordem,
  }) {
    return DiaTreinoModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      diaSemana: diaSemana ?? this.diaSemana,
      exercicios: exercicios ?? this.exercicios,
      ordem: ordem ?? this.ordem,
    );
  }
}
