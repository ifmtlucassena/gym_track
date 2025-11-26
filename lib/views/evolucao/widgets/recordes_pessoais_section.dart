import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../viewmodels/evolucao_viewmodel.dart';
import '../../../models/evolucao_models.dart';

class RecordesPessoaisSection extends StatelessWidget {
  const RecordesPessoaisSection({super.key});

  @override
  Widget build(BuildContext context) {
    final prs = context.watch<EvolucaoViewModel>().prs;

    if (prs.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recordes Pessoais',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: prs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return _buildPRCard(context, prs[index], index);
          },
        ),
      ],
    );
  }

  Widget _buildPRCard(BuildContext context, PR pr, int index) {
    String medalha = '🏅';
    if (index == 0) medalha = '🥇';
    if (index == 1) medalha = '🥈';
    if (index == 2) medalha = '🥉';

    final dateFormat = DateFormat("dd/MM/yyyy", 'pt_BR');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Text(
            medalha,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pr.exercicioNome,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${pr.pesoMaximo}kg • ${pr.repeticoes} reps • ${dateFormat.format(pr.data)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (pr.isNovo)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Novo recorde! 🎉',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
