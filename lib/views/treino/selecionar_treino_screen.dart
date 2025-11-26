import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/ficha_model.dart';
import '../../models/dia_treino_model.dart';
import 'preview_exercicios_screen.dart';

import 'package:intl/intl.dart';

class SelecionarTreinoScreen extends StatefulWidget {
  final FichaModel ficha;
  final DateTime? dataTreino;

  const SelecionarTreinoScreen({
    super.key,
    required this.ficha,
    this.dataTreino,
  });

  @override
  State<SelecionarTreinoScreen> createState() => _SelecionarTreinoScreenState();
}

class _SelecionarTreinoScreenState extends State<SelecionarTreinoScreen> {
  DiaTreinoModel? _treinoSelecionado;

  String _formatDate(DateTime date) {
    return DateFormat("EEEE, d 'de' MMMM", 'pt_BR').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Selecionar Treino'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                if (widget.dataTreino != null) ...[
                  Text(
                    'Treino de ${_formatDate(widget.dataTreino!)}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                const Text(
                  'Qual treino você fez?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 20),
                ...widget.ficha.diasTreino.map((dia) {
                  final isSelected = _treinoSelecionado?.id == dia.id;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildTreinoCard(dia, isSelected),
                  );
                }).toList(),
              ],
            ),
          ),
          if (_treinoSelecionado != null)
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PreviewExerciciosScreen(
                            ficha: widget.ficha,
                            diaTreino: _treinoSelecionado!,
                            dataTreino: widget.dataTreino,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Continuar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
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

  Widget _buildTreinoCard(DiaTreinoModel dia, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          _treinoSelecionado = dia;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.divider,
                  width: 2,
                ),
                color: isSelected ? AppColors.primary : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      color: AppColors.white,
                      size: 16,
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dia.nome,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${dia.exercicios.length} exercícios • ~${dia.duracaoEstimada} min',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
