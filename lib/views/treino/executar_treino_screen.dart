import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../models/ficha_model.dart';
import '../../models/dia_treino_model.dart';
import '../../models/serie_model.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/executar_treino_viewmodel.dart';
import '../../services/treino_service.dart';
import '../../services/exercicio_service.dart';
import 'finalizar_treino_screen.dart';

class ExecutarTreinoScreen extends StatefulWidget {
  final FichaModel ficha;
  final DiaTreinoModel diaTreino;
  final DateTime dataTreino;

  const ExecutarTreinoScreen({
    super.key,
    required this.ficha,
    required this.diaTreino,
    required this.dataTreino,
  });

  @override
  State<ExecutarTreinoScreen> createState() => _ExecutarTreinoScreenState();
}

class _ExecutarTreinoScreenState extends State<ExecutarTreinoScreen> {
  late ExecutarTreinoViewModel _viewModel;
  final TreinoService _treinoService = TreinoService();
  final ExercicioService _exercicioService = ExercicioService();
  Map<String, dynamic>? _ultimoTreinoExercicio;
  bool _carregandoHistorico = true;
  ExercicioCatalogo? _exercicioCatalogo;
  int _imagemAtualIndex = 0;
  Timer? _timerImagem;

  String _formatDate(DateTime date) {
    return DateFormat("dd/MM/yyyy", 'pt_BR').format(date);
  }

  bool get _isTreinoPassado {
    final now = DateTime.now();
    return widget.dataTreino.year != now.year ||
        widget.dataTreino.month != now.month ||
        widget.dataTreino.day != now.day;
  }

  // Controllers para os inputs
  final Map<String, Map<String, TextEditingController>> _controllers = {};

  @override
  void initState() {
    super.initState();
    final authViewModel = context.read<AuthViewModel>();
    _viewModel = ExecutarTreinoViewModel(
      ficha: widget.ficha,
      diaTreino: widget.diaTreino,
      dataTreino: widget.dataTreino,
      usuarioId: authViewModel.usuario!.id,
    );
    _carregarDadosExercicio();
  }

  Future<void> _carregarDadosExercicio() async {
    final authViewModel = context.read<AuthViewModel>();

    // Buscar dados do catálogo
    final exercicio = await _exercicioService.buscarExercicioPorId(
      _viewModel.exercicioAtual.exercicioId,
    );

    // Buscar histórico
    final historico = await _treinoService.buscarUltimoTreinoPorExercicio(
      authViewModel.usuario!.id,
      _viewModel.exercicioAtual.exercicioId,
    );

    setState(() {
      _exercicioCatalogo = exercicio;
      _ultimoTreinoExercicio = historico;
      _carregandoHistorico = false;
    });

    // Iniciar timer de alternância de imagens
    if (exercicio != null && exercicio.imagens.length > 1) {
      _timerImagem?.cancel();
      _timerImagem = Timer.periodic(const Duration(seconds: 2), (timer) {
        if (mounted) {
          setState(() {
            _imagemAtualIndex = (_imagemAtualIndex + 1) % exercicio.imagens.length;
          });
        }
      });
    }
  }

  TextEditingController _getController(String exercicioId, int serieIndex, String field) {
    final key = '${exercicioId}_$serieIndex';
    if (!_controllers.containsKey(key)) {
      _controllers[key] = {};
    }
    if (!_controllers[key]!.containsKey(field)) {
      _controllers[key]![field] = TextEditingController();
    }
    return _controllers[key]![field]!;
  }

  void _updateControllers() {
    final exercicioAtual = _viewModel.exercicioAtual;
    final series = _viewModel.seriesAtual;

    for (int i = 0; i < series.length; i++) {
      final serie = series[i];
      final repsController = _getController(exercicioAtual.id, i, 'reps');
      final pesoController = _getController(exercicioAtual.id, i, 'peso');

      // Só atualiza se o valor mudou e o campo não está focado
      if (repsController.text != (serie.repeticoes > 0 ? serie.repeticoes.toString() : '')) {
        if (!repsController.selection.isValid || repsController.selection.baseOffset == -1) {
          repsController.text = serie.repeticoes > 0 ? serie.repeticoes.toString() : '';
        }
      }
      if (pesoController.text != (serie.pesoKg != null ? serie.pesoKg.toString() : '')) {
        if (!pesoController.selection.isValid || pesoController.selection.baseOffset == -1) {
          pesoController.text = serie.pesoKg != null ? serie.pesoKg.toString() : '';
        }
      }
    }
  }

  void _limparControllersExercicioAnterior() {
    // Limpa controllers do exercício anterior
    final exerciciosIds = _viewModel.exercicios.map((e) => e.id).toList();
    _controllers.removeWhere((key, value) {
      final exercicioId = key.split('_')[0];
      return !exerciciosIds.contains(exercicioId);
    });
  }

  @override
  void dispose() {
    _timerImagem?.cancel();
    // Dispose de todos os controllers
    for (var map in _controllers.values) {
      for (var controller in map.values) {
        controller.dispose();
      }
    }
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: WillPopScope(
        onWillPop: () async {
          final confirmar = await _confirmarSaida();
          return confirmar ?? false;
        },
        child: Consumer<ExecutarTreinoViewModel>(
          builder: (context, viewModel, child) {
            return Scaffold(
              backgroundColor: AppColors.surface,
              appBar: AppBar(
                backgroundColor: AppColors.background,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () async {
                    final confirmar = await _confirmarSaida();
                    if (confirmar == true && mounted) {
                      Navigator.pop(context);
                    }
                  },
                ),
                title: Text(
                  '${viewModel.exercicioAtualIndex + 1}/${viewModel.totalExercicios} exercícios',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                centerTitle: true,
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Center(
                      child: _isTreinoPassado
                          ? Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 16, color: AppColors.textPrimary),
                                const SizedBox(width: 8),
                                Text(
                                  _formatDate(widget.dataTreino),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              viewModel.tempoDecorrido,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'monospace',
                              ),
                            ),
                    ),
                  ),
                ],
              ),
              body: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildExercicioHeader(viewModel),
                          if (!_carregandoHistorico && _ultimoTreinoExercicio != null)
                            _buildUltimoTreinoCard(_ultimoTreinoExercicio!),
                          _buildSeriesList(viewModel),
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ),
                  _buildBottomActions(viewModel),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildExercicioHeader(ExecutarTreinoViewModel viewModel) {
    return Container(
      color: AppColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagens alternando
          if (_exercicioCatalogo != null && _exercicioCatalogo!.imagens.isNotEmpty)
            Container(
              height: 200,
              color: Colors.grey.shade100,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CachedNetworkImage(
                    imageUrl: _exercicioCatalogo!.imagens[_imagemAtualIndex],
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.primaryLight.withOpacity(0.1),
                      child: const Icon(
                        Icons.fitness_center,
                        size: 64,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  // Indicadores de imagem
                  if (_exercicioCatalogo!.imagens.length > 1)
                    Positioned(
                      bottom: 12,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _exercicioCatalogo!.imagens.length.clamp(0, 2),
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _imagemAtualIndex == index
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          // Título e detalhes
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        viewModel.exercicioAtual.nome,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (viewModel.exercicioAtual.grupo_muscular != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          viewModel.exercicioAtual.grupo_muscular!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (_exercicioCatalogo != null && _exercicioCatalogo!.instrucoes.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.info_outline),
                    color: AppColors.primary,
                    onPressed: () => _mostrarDetalhesExercicio(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarDetalhesExercicio() {
    if (_exercicioCatalogo == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(20),
                    children: [
                      Text(
                        _exercicioCatalogo!.nome,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Instruções',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...List.generate(_exercicioCatalogo!.instrucoes.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  _exercicioCatalogo!.instrucoes[index],
                                  style: const TextStyle(
                                    fontSize: 15,
                                    height: 1.5,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Fechar'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUltimoTreinoCard(Map<String, dynamic> ultimoTreino) {
    final dataFim = (ultimoTreino['data_treino'] as Timestamp?)?.toDate();
    final diasAtras = dataFim != null ? DateTime.now().difference(dataFim).inDays : 0;

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'ÚLTIMO TREINO',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${ultimoTreino['total_series']} séries • ${ultimoTreino['media_reps']} reps • ${ultimoTreino['media_peso_kg'].toStringAsFixed(1)} kg',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            diasAtras == 0
                ? 'Hoje'
                : diasAtras == 1
                    ? 'Há 1 dia'
                    : 'Há $diasAtras dias',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeriesList(ExecutarTreinoViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...List.generate(viewModel.seriesAtual.length, (index) {
            final serie = viewModel.seriesAtual[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildSerieCard(viewModel, serie, index),
            );
          }),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {
              viewModel.adicionarSerie();
              setState(() {
                _updateControllers();
              });
            },
            icon: const Icon(Icons.add, size: 20),
            label: const Text('Adicionar série'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSerieCard(
    ExecutarTreinoViewModel viewModel,
    SerieModel serie,
    int index,
  ) {
    final exercicioId = viewModel.exercicioAtual.id;
    final repsController = _getController(exercicioId, index, 'reps');
    final pesoController = _getController(exercicioId, index, 'peso');

    // Inicializa os controllers com os valores atuais
    if (repsController.text.isEmpty && serie.repeticoes > 0) {
      repsController.text = serie.repeticoes.toString();
    }
    if (pesoController.text.isEmpty && serie.pesoKg != null) {
      pesoController.text = serie.pesoKg.toString();
    }

    // Visual simples: se tem valores preenchidos, mostra com fundo verde claro
    final temValores = serie.repeticoes > 0 || serie.pesoKg != null;
    final backgroundColor = temValores ? const Color(0xFFF0FDF4) : AppColors.background;
    final borderColor = temValores ? AppColors.success : AppColors.divider;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: temValores ? AppColors.success : AppColors.divider,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${serie.numeroSerie}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: repsController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                labelText: 'Reps',
                hintText: '0',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                filled: true,
                fillColor: AppColors.white,
              ),
              onChanged: (value) {
                final reps = int.tryParse(value) ?? 0;
                viewModel.atualizarSerie(index, repeticoes: reps);
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: pesoController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                labelText: 'Kg',
                hintText: '0',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                filled: true,
                fillColor: AppColors.white,
              ),
              onChanged: (value) {
                // Replace comma with dot for parsing
                final normalizedValue = value.replaceAll(',', '.');
                
                if (normalizedValue.isEmpty) {
                   viewModel.atualizarSerie(index, forceNullPeso: true);
                } else {
                   final peso = double.tryParse(normalizedValue);
                   viewModel.atualizarSerie(index, pesoKg: peso);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(ExecutarTreinoViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              if (viewModel.isUltimoExercicio) {
                await _finalizarTreino();
              } else {
                await viewModel.proximoExercicio();
                _imagemAtualIndex = 0;
                _limparControllersExercicioAnterior();
                await _carregarDadosExercicio();
                setState(() {});
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              viewModel.isUltimoExercicio ? 'FINALIZAR TREINO' : 'PRÓXIMO EXERCÍCIO',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> _confirmarSaida() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair do treino?'),
        content: const Text(
          'Seu progresso será perdido se você sair agora. Deseja continuar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Sair',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _finalizarTreino() async {
    final authViewModel = context.read<AuthViewModel>();

    // Construir lista de exercícios com séries atualizadas
    final exerciciosFinalizados = _viewModel.exercicios.map((exercicio) {
      final series = _viewModel.getSeriesExercicio(exercicio.id);
      return exercicio.copyWith(series: series);
    }).toList();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => FinalizarTreinoScreen(
          ficha: widget.ficha,
          diaTreino: widget.diaTreino,
          dataInicio: widget.dataTreino, // Use dataTreino as start date
          dataFim: _isTreinoPassado ? widget.dataTreino : DateTime.now(), // Use dataTreino for past workouts initially
          usuarioId: authViewModel.usuario!.id,
          exercicios: exerciciosFinalizados,
          tempoDecorrido: _isTreinoPassado ? '00:00' : _viewModel.tempoDecorrido, // Placeholder for past
          exerciciosConcluidos: _viewModel.contarExerciciosConcluidos(),
          volumeTotal: _viewModel.calcularVolumeTotalKg(),
          isTreinoPassado: _isTreinoPassado, // Pass flag
        ),
      ),
    );
  }
}
