import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/ficha_model.dart';
import '../../models/dia_treino_model.dart';
import '../../models/exercicio_model.dart';
import 'executar_treino_screen.dart';

class PreviewExerciciosScreen extends StatefulWidget {
  final FichaModel ficha;
  final DiaTreinoModel diaTreino;
  final DateTime? dataTreino;

  const PreviewExerciciosScreen({
    super.key,
    required this.ficha,
    required this.diaTreino,
    this.dataTreino,
  });

  @override
  State<PreviewExerciciosScreen> createState() => _PreviewExerciciosScreenState();
}

class _PreviewExerciciosScreenState extends State<PreviewExerciciosScreen> {
  late List<ExercicioModel> _exercicios;

  @override
  void initState() {
    super.initState();
    _exercicios = List.from(widget.diaTreino.exercicios);
  }

  void _moveUp(int index) {
    if (index > 0) {
      setState(() {
        final item = _exercicios.removeAt(index);
        _exercicios.insert(index - 1, item);
      });
    }
  }

  void _moveDown(int index) {
    if (index < _exercicios.length - 1) {
      setState(() {
        final item = _exercicios.removeAt(index);
        _exercicios.insert(index + 1, item);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(widget.diaTreino.nome),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _iniciarTreino,
            child: const Text(
              'INICIAR',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: AppColors.background,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_exercicios.length} exercícios • ${widget.diaTreino.duracaoEstimada} min estimado',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Você pode reordenar os exercícios antes de iniciar',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _exercicios.length,
              itemBuilder: (context, index) {
                final exercicio = _exercicios[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildExercicioCard(exercicio, index),
                );
              },
            ),
          ),
          Container(
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
                  onPressed: _iniciarTreino,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'INICIAR TREINO',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExercicioCard(ExercicioModel exercicio, int index) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercicio.nome,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${exercicio.series.length} séries • ${exercicio.series.isNotEmpty ? exercicio.series.first.repeticoes : 0} reps',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_upward, size: 20),
                onPressed: index > 0 ? () => _moveUp(index) : null,
                color: AppColors.primary,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(height: 8),
              IconButton(
                icon: const Icon(Icons.arrow_downward, size: 20),
                onPressed: index < _exercicios.length - 1 ? () => _moveDown(index) : null,
                color: AppColors.primary,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _iniciarTreino() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ExecutarTreinoScreen(
          ficha: widget.ficha,
          diaTreino: widget.diaTreino.copyWith(exercicios: _exercicios),
          dataTreino: widget.dataTreino ?? DateTime.now(),
        ),
      ),
    );
  }
}
