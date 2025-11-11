class SerieModel {
  final String id;
  final int numeroSerie;
  final int repeticoes;
  final double? pesoKg;
  final String? observacao;

  SerieModel({
    String? id,
    required this.numeroSerie,
    required this.repeticoes,
    this.pesoKg,
    this.observacao,
  }) : id = id ?? 's$numeroSerie';

  factory SerieModel.fromMap(Map<String, dynamic> map, String id) {
    return SerieModel(
      id: id,
      numeroSerie: map['numero_serie'] ?? 0,
      repeticoes: map['repeticoes'] ?? 0,
      pesoKg: map['peso_kg']?.toDouble(),
      observacao: map['observacao'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'numero_serie': numeroSerie,
      'repeticoes': repeticoes,
      'peso_kg': pesoKg,
      'observacao': observacao,
    };
  }

  SerieModel copyWith({
    String? id,
    int? numeroSerie,
    int? repeticoes,
    double? pesoKg,
    String? observacao,
  }) {
    return SerieModel(
      id: id ?? this.id,
      numeroSerie: numeroSerie ?? this.numeroSerie,
      repeticoes: repeticoes ?? this.repeticoes,
      pesoKg: pesoKg ?? this.pesoKg,
      observacao: observacao ?? this.observacao,
    );
  }
}
