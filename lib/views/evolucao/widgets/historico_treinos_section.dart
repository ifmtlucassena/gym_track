import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../viewmodels/evolucao_viewmodel.dart';
import '../../../models/treino_model.dart';

class HistoricoTreinosSection extends StatelessWidget {
  const HistoricoTreinosSection({super.key});

  @override
  Widget build(BuildContext context) {
    final treinos = context.watch<EvolucaoViewModel>().historicoTreinos;

    if (treinos.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Histórico de Treinos',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: treinos.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return _buildTreinoCard(context, treinos[index]);
          },
        ),
      ],
    );
  }

  Widget _buildTreinoCard(BuildContext context, TreinoRealizadoModel treino) {
    final dateFormat = DateFormat("dd/MM • HH:mm", 'pt_BR');
    
    return InkWell(
      onTap: () {
        _mostrarDetalhesTreino(context, treino);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateFormat.format(treino.dataFim),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  '${treino.duracaoMinutos} min',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              treino.nomeTreino,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${treino.exercicios.length} exercícios • ${(treino.volumeTotalKg / 1000).toStringAsFixed(1)}t',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            if (treino.observacao != null && treino.observacao!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '💬 ${treino.observacao}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _mostrarDetalhesTreino(BuildContext context, TreinoRealizadoModel treino) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(24),
          child: ListView(
            controller: controller,
            children: [
              Text(
                treino.nomeTreino,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${DateFormat("dd/MM/yyyy • HH:mm", 'pt_BR').format(treino.dataInicio)} - ${DateFormat("HH:mm", 'pt_BR').format(treino.dataFim)}',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              ...treino.exercicios.map((exercicio) => Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercicio.nome,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...exercicio.series.map((serie) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${serie.numeroSerie}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '${serie.repeticoes} reps',
                            style: const TextStyle(
                                fontSize: 14, color: AppColors.textPrimary),
                          ),
                          if (serie.pesoKg != null) ...[
                            const SizedBox(width: 8),
                            const Text('•', style: TextStyle(color: AppColors.textSecondary)),
                            const SizedBox(width: 8),
                            Text(
                              '${serie.pesoKg}kg',
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                            ),
                          ],
                        ],
                      ),
                    )),
                  ],
                ),
              )),
              if (treino.observacao != null) ...[
                const Divider(),
                const SizedBox(height: 16),
                const Text(
                  'Observações',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  treino.observacao!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
