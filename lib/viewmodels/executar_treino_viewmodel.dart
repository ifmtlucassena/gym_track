import 'dart:async';
import 'package:flutter/material.dart';
import '../models/ficha_model.dart';
import '../models/dia_treino_model.dart';
import '../models/exercicio_model.dart';
import '../models/serie_model.dart';

class ExecutarTreinoViewModel extends ChangeNotifier {
  final FichaModel ficha;
  final DiaTreinoModel diaTreino;
  final DateTime dataTreino;
  final String usuarioId;

  late DateTime _dataInicio;
  Timer? _timer;
  int _segundosDecorridos = 0;

  int _exercicioAtualIndex = 0;
  late List<ExercicioModel> _exercicios;
  Map<String, List<SerieModel>> _seriesPorExercicio = {};

  bool _isLoading = false;
  String? _error;

  ExecutarTreinoViewModel({
    required this.ficha,
    required this.diaTreino,
    required this.dataTreino,
    required this.usuarioId,
  }) {
    _dataInicio = dataTreino;
    _exercicios = List.from(diaTreino.exercicios);
    _inicializarSeries();
    
    final now = DateTime.now();
    final isToday = dataTreino.year == now.year && 
                    dataTreino.month == now.month && 
                    dataTreino.day == now.day;
                    
    if (isToday) {
      _iniciarTimer();
    }
  }

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get exercicioAtualIndex => _exercicioAtualIndex;
  ExercicioModel get exercicioAtual => _exercicios[_exercicioAtualIndex];
  int get totalExercicios => _exercicios.length;
  String get tempoDecorrido => _formatarTempo(_segundosDecorridos);
  List<SerieModel> get seriesAtual => _seriesPorExercicio[exercicioAtual.id] ?? [];
  bool get isUltimoExercicio => _exercicioAtualIndex == _exercicios.length - 1;
  DateTime get dataInicio => _dataInicio;
  List<ExercicioModel> get exercicios => _exercicios;

  List<SerieModel> getSeriesExercicio(String exercicioId) {
    return _seriesPorExercicio[exercicioId] ?? [];
  }

  void _inicializarSeries() {
    for (var exercicio in _exercicios) {
      _seriesPorExercicio[exercicio.id] = exercicio.series.map((serie) {
        return SerieModel(
          numeroSerie: serie.numeroSerie,
          repeticoes: serie.repeticoes,
          pesoKg: null,
        );
      }).toList();
    }
  }

  void _iniciarTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _segundosDecorridos++;
      notifyListeners();
    });
  }

  String _formatarTempo(int segundos) {
    final horas = segundos ~/ 3600;
    final minutos = (segundos % 3600) ~/ 60;
    final segs = segundos % 60;
    return '${horas.toString().padLeft(2, '0')}:${minutos.toString().padLeft(2, '0')}:${segs.toString().padLeft(2, '0')}';
  }

  void atualizarSerie(int indexSerie, {int? repeticoes, double? pesoKg, bool forceNullPeso = false}) {
    final series = List<SerieModel>.from(seriesAtual);
    
    double? novoPeso;
    if (forceNullPeso) {
      novoPeso = null;
    } else {
      novoPeso = pesoKg ?? series[indexSerie].pesoKg;
    }

    series[indexSerie] = series[indexSerie].copyWith(
      repeticoes: repeticoes ?? series[indexSerie].repeticoes,
      pesoKg: novoPeso,
    );
    
    if (forceNullPeso) {
       series[indexSerie] = SerieModel(
          id: series[indexSerie].id,
          numeroSerie: series[indexSerie].numeroSerie,
          repeticoes: series[indexSerie].repeticoes, // Keep reps
          pesoKg: null, // Clear weight
          observacao: series[indexSerie].observacao,
       );
    } else {
       // Normal update
       series[indexSerie] = series[indexSerie].copyWith(
          repeticoes: repeticoes ?? series[indexSerie].repeticoes,
          pesoKg: pesoKg ?? series[indexSerie].pesoKg,
       );
    }

    _seriesPorExercicio[exercicioAtual.id] = series;
    notifyListeners();
  }


  void adicionarSerie() {
    final series = List<SerieModel>.from(seriesAtual);
    final novaSerie = SerieModel(
      numeroSerie: series.length + 1,
      repeticoes: series.isNotEmpty ? series.last.repeticoes : 0,
      pesoKg: null,
    );
    series.add(novaSerie);
    _seriesPorExercicio[exercicioAtual.id] = series;
    notifyListeners();
  }


  Future<void> proximoExercicio() async {
    if (_exercicioAtualIndex < _exercicios.length - 1) {
      _exercicioAtualIndex++;
      _error = null;
      notifyListeners();
    }
  }

  Future<void> exercicioAnterior() async {
    if (_exercicioAtualIndex > 0) {
      _exercicioAtualIndex--;
      _error = null;
      notifyListeners();
    }
  }

  Future<void> pularExercicio() async {
    if (_exercicioAtualIndex < _exercicios.length - 1) {
      _exercicioAtualIndex++;
      _error = null;
      notifyListeners();
    }
  }

  double calcularVolumeTotalKg() {
    double volumeTotal = 0;
    for (var exercicio in _exercicios) {
      final series = _seriesPorExercicio[exercicio.id] ?? [];
      for (var serie in series) {
        if (serie.repeticoes > 0 && serie.pesoKg != null) {
          volumeTotal += serie.repeticoes * serie.pesoKg!;
        }
      }
    }
    return volumeTotal;
  }

  int contarExerciciosConcluidos() {
    int count = 0;
    for (var exercicio in _exercicios) {
      final series = _seriesPorExercicio[exercicio.id] ?? [];
      // Conta como concluído se tiver pelo menos uma série com repeticoes > 0
      if (series.isNotEmpty && series.any((s) => s.repeticoes > 0)) {
        count++;
      }
    }
    return count;
  }


  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
