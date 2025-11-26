import 'package:flutter/material.dart';

class MetricasPeriodo {
  final int totalTreinos;
  final int duracaoTotalMinutos;
  final double volumeTotalKg;
  final double frequenciaPercentual;
  final int diasSequencia;
  final double comparacaoPeriodoAnterior; // %

  MetricasPeriodo({
    required this.totalTreinos,
    required this.duracaoTotalMinutos,
    required this.volumeTotalKg,
    required this.frequenciaPercentual,
    required this.diasSequencia,
    required this.comparacaoPeriodoAnterior,
  });
}

class PR {
  final String exercicioId;
  final String exercicioNome;
  final double pesoMaximo;
  final int repeticoes;
  final DateTime data;
  final bool isNovo; // últimas 2 semanas
  final double diferencaPRAnterior;

  PR({
    required this.exercicioId,
    required this.exercicioNome,
    required this.pesoMaximo,
    required this.repeticoes,
    required this.data,
    required this.isNovo,
    required this.diferencaPRAnterior,
  });
}

class PontoEvolucao {
  final DateTime data;
  final double valor; // peso, volume, ou reps
  final int numeroSerie;
  final String treinoId;

  PontoEvolucao({
    required this.data,
    required this.valor,
    required this.numeroSerie,
    required this.treinoId,
  });
}

enum TipoInsight {
  sequencia,
  progresso,
  alerta,
  recorde,
  comparacao,
  motivacao,
}

class Insight {
  final String id;
  final TipoInsight tipo;
  final String titulo;
  final String descricao;
  final IconData icone;
  final Color cor;
  final DateTime geradoEm;

  Insight({
    required this.id,
    required this.tipo,
    required this.titulo,
    required this.descricao,
    required this.icone,
    required this.cor,
    required this.geradoEm,
  });
}
