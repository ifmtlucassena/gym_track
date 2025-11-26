import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../models/ficha_model.dart';
import '../../models/dia_treino_model.dart';
import '../../models/exercicio_model.dart';
import '../../models/treino_model.dart';
import '../../services/treino_service.dart';

class FinalizarTreinoScreen extends StatefulWidget {
  final FichaModel ficha;
  final DiaTreinoModel diaTreino;
  final DateTime dataInicio;
  final DateTime dataFim;
  final String usuarioId;
  final List<ExercicioModel> exercicios;
  final String tempoDecorrido;
  final int exerciciosConcluidos;
  final double volumeTotal;
  final bool isTreinoPassado; // New parameter

  const FinalizarTreinoScreen({
    super.key,
    required this.ficha,
    required this.diaTreino,
    required this.dataInicio,
    required this.dataFim,
    required this.usuarioId,
    required this.exercicios,
    required this.tempoDecorrido,
    required this.exerciciosConcluidos,
    required this.volumeTotal,
    this.isTreinoPassado = false, // Default to false
  });

  @override
  State<FinalizarTreinoScreen> createState() => _FinalizarTreinoScreenState();
}

class _FinalizarTreinoScreenState extends State<FinalizarTreinoScreen> {
  final TreinoService _treinoService = TreinoService();
  final TextEditingController _pesoCorporalController = TextEditingController();
  final TextEditingController _observacoesController = TextEditingController();
  final TextEditingController _duracaoController = TextEditingController(); // New controller
  bool _isSalvando = false;

  @override
  void initState() {
    super.initState();
    if (widget.isTreinoPassado) {
      // Suggest estimated duration or 60 min
      _duracaoController.text = widget.diaTreino.duracaoEstimada.toString();
    }
  }

  @override
  void dispose() {
    _pesoCorporalController.dispose();
    _observacoesController.dispose();
    _duracaoController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return DateFormat("dd/MM/yyyy", 'pt_BR').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final duracaoMinutos = widget.tempoDecorrido;
    final exerciciosConcluidos = widget.exerciciosConcluidos;
    final volumeTotal = widget.volumeTotal;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.fitness_center,
                size: 80,
                color: AppColors.secondary,
              ),
              const SizedBox(height: 24),
              const Text(
                'Treino concluído!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              if (widget.isTreinoPassado)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Data: ${_formatDate(widget.dataInicio)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 8),
              const Text(
                'Mais um passo rumo ao seu objetivo',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  widget.isTreinoPassado
                      ? Expanded(
                          child: Column(
                            children: [
                              const Icon(Icons.timer, size: 24, color: AppColors.secondary),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: 80,
                                child: TextField(
                                  controller: _duracaoController,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  decoration: const InputDecoration(
                                    suffixText: 'min',
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                  ),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Duração',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        )
                      : _buildMetricCard(
                          icon: Icons.timer,
                          label: 'Duração',
                          value: duracaoMinutos,
                        ),
                  _buildMetricCard(
                    icon: Icons.fitness_center,
                    label: 'Exercícios',
                    value: exerciciosConcluidos.toString(),
                  ),
                  _buildMetricCard(
                    icon: Icons.local_fire_department,
                    label: 'Volume Total',
                    value: '${volumeTotal.toStringAsFixed(0)} kg',
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Text(
                'Registrar peso corporal (opcional)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _pesoCorporalController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                decoration: InputDecoration(
                  hintText: 'Ex: 75.5',
                  suffixText: 'kg',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: AppColors.background,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Como foi o treino? (opcional)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _observacoesController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Adicionar observações...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: AppColors.background,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isSalvando ? null : _finalizarTreino,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBackgroundColor: AppColors.disabled,
                ),
                child: _isSalvando
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.white,
                        ),
                      )
                    : const Text(
                        'FINALIZAR',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 24,
          color: AppColors.secondary,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Future<void> _finalizarTreino() async {
    setState(() {
      _isSalvando = true;
    });

    try {
      final pesoCorporal = _pesoCorporalController.text.isNotEmpty
          ? double.tryParse(_pesoCorporalController.text)
          : null;
      final observacao = _observacoesController.text.isNotEmpty
          ? _observacoesController.text
          : null;

      int duracaoMinutosInt;
      DateTime dataFimFinal;

      if (widget.isTreinoPassado) {
        duracaoMinutosInt = int.tryParse(_duracaoController.text) ?? widget.diaTreino.duracaoEstimada;
        // Calculate dataFim based on dataInicio + duration
        dataFimFinal = widget.dataInicio.add(Duration(minutes: duracaoMinutosInt));
      } else {
        duracaoMinutosInt = widget.dataFim.difference(widget.dataInicio).inMinutes;
        dataFimFinal = widget.dataFim;
      }

      final treino = TreinoRealizadoModel(
        id: '',
        usuarioId: widget.usuarioId,
        fichaId: widget.ficha.id,
        diaTreinoId: widget.diaTreino.id,
        nomeTreino: widget.diaTreino.nome,
        dataInicio: widget.dataInicio,
        dataFim: dataFimFinal,
        exercicios: widget.exercicios,
        duracaoMinutos: duracaoMinutosInt,
        volumeTotalKg: widget.volumeTotal,
        pesoCorporal: pesoCorporal,
        observacao: observacao,
      );

      await _treinoService.salvarTreino(treino);

      if (mounted) {
        // Voltar para HomeScreen e limpar stack
        Navigator.of(context).popUntil((route) => route.isFirst);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Treino salvo com sucesso!'),
            backgroundColor: AppColors.success,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar treino: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSalvando = false;
        });
      }
    }
  }
}
