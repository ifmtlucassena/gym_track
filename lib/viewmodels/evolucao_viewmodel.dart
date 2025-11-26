import 'package:flutter/material.dart';
import '../models/evolucao_models.dart';
import '../models/treino_model.dart';
import '../services/evolucao_service.dart';
import '../services/ficha_service.dart';
import '../core/theme/app_colors.dart';

class EvolucaoViewModel extends ChangeNotifier {
  final EvolucaoService _evolucaoService = EvolucaoService();
  final FichaService _fichaService = FichaService();

  bool _isLoading = false;
  String? _error;
  
  // Period filter
  DateTime _periodoInicio = DateTime.now().subtract(const Duration(days: 30));
  DateTime _periodoFim = DateTime.now();
  String _periodoLabel = 'Últimos 30 dias';

  // Data
  MetricasPeriodo? _metricas;
  List<PR> _prs = [];
  List<TreinoRealizadoModel> _historicoTreinos = [];
  List<Insight> _insights = [];
  List<PontoEvolucao> _evolucaoExercicio = [];
  
  // Selection
  String? _exercicioSelecionadoId;
  String? _exercicioSelecionadoNome;

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  DateTime get periodoInicio => _periodoInicio;
  DateTime get periodoFim => _periodoFim;
  String get periodoLabel => _periodoLabel;
  
  MetricasPeriodo? get metricas => _metricas;
  List<PR> get prs => _prs;
  List<TreinoRealizadoModel> get historicoTreinos => _historicoTreinos;
  List<Insight> get insights => _insights;
  List<PontoEvolucao> get evolucaoExercicio => _evolucaoExercicio;
  String? get exercicioSelecionadoNome => _exercicioSelecionadoNome;
  String? get exercicioSelecionadoId => _exercicioSelecionadoId;

  Future<void> carregarDados(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // 1. Fetch workouts for period
      _historicoTreinos = await _evolucaoService.buscarTreinosPorPeriodo(
        userId, 
        _periodoInicio, 
        _periodoFim
      );

      // 2. Get active ficha for meta
      int diasPorSemana = 3;
      try {
        final ficha = await _fichaService.buscarFichaAtiva(userId);
        if (ficha != null) {
          diasPorSemana = ficha.diasTreino.length;
        }
      } catch (e) {
        print('Erro ao buscar ficha ativa: $e');
      }

      // 3. Calculate metrics
      _metricas = _evolucaoService.calcularMetricas(
        _historicoTreinos, 
        _periodoInicio, 
        _periodoFim, 
        diasPorSemana
      );

      // 4. Fetch PRs
      _prs = await _evolucaoService.buscarPRs(userId);

      // 5. Generate Insights
      _gerarInsights();
      
      // 6. Load evolution for top exercise if none selected
      if (_exercicioSelecionadoId == null && _prs.isNotEmpty) {
        await selecionarExercicio(userId, _prs.first.exercicioId, _prs.first.exercicioNome);
      } else if (_exercicioSelecionadoId != null) {
        await selecionarExercicio(userId, _exercicioSelecionadoId!, _exercicioSelecionadoNome!);
      }

    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setPeriodo(String userId, DateTime inicio, DateTime fim, String label) async {
    _periodoInicio = inicio;
    _periodoFim = fim;
    _periodoLabel = label;
    await carregarDados(userId);
  }

  Future<void> selecionarExercicio(String userId, String exercicioId, String nome) async {
    _exercicioSelecionadoId = exercicioId;
    _exercicioSelecionadoNome = nome;
    
    // Fetch evolution data (always 6 months for chart context)
    _evolucaoExercicio = await _evolucaoService.buscarEvolucaoExercicio(
      userId, 
      exercicioId, 
      DateTime.now().subtract(const Duration(days: 180)), 
      DateTime.now()
    );
    notifyListeners();
  }

  void _gerarInsights() {
    _insights = [];
    if (_metricas == null) return;

    // Sequencia
    if (_metricas!.diasSequencia >= 3) {
      _insights.add(Insight(
        id: 'seq',
        tipo: TipoInsight.sequencia,
        titulo: '🔥 Sequência de ${_metricas!.diasSequencia} dias!',
        descricao: 'Continue assim! A consistência é a chave.',
        icone: Icons.local_fire_department,
        cor: AppColors.success,
        geradoEm: DateTime.now(),
      ));
    }

    // PRs
    final prsRecentes = _prs.where((pr) => pr.isNovo).toList();
    if (prsRecentes.isNotEmpty) {
      _insights.add(Insight(
        id: 'pr',
        tipo: TipoInsight.recorde,
        titulo: '🏆 ${prsRecentes.length} novos recordes!',
        descricao: 'Parabéns! Você superou seus limites em ${prsRecentes.map((e) => e.exercicioNome).join(", ")}.',
        icone: Icons.emoji_events,
        cor: Colors.amber,
        geradoEm: DateTime.now(),
      ));
    }
    
    // Volume
    if (_metricas!.volumeTotalKg > 5000) {
       _insights.add(Insight(
        id: 'vol',
        tipo: TipoInsight.motivacao,
        titulo: '💪 ${(_metricas!.volumeTotalKg / 1000).toStringAsFixed(1)} toneladas!',
        descricao: 'Você já levantou o equivalente a um elefante este mês.',
        icone: Icons.fitness_center,
        cor: Colors.blue,
        geradoEm: DateTime.now(),
      ));
    }
  }
}
