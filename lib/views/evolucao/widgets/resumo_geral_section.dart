import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../viewmodels/evolucao_viewmodel.dart';

class ResumoGeralSection extends StatelessWidget {
  const ResumoGeralSection({super.key});

  @override
  Widget build(BuildContext context) {
    final metricas = context.watch<EvolucaoViewModel>().metricas;

    if (metricas == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Resumo Geral',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildCard(
                  context,
                  constraints,
                  label: 'Treinos',
                  value: metricas.totalTreinos.toString(),
                  icon: Icons.fitness_center,
                ),
                _buildCard(
                  context,
                  constraints,
                  label: 'Tempo Total',
                  value: '${(metricas.duracaoTotalMinutos / 60).toStringAsFixed(1)}h',
                  icon: Icons.timer,
                ),
                _buildCard(
                  context,
                  constraints,
                  label: 'Volume',
                  value: '${(metricas.volumeTotalKg / 1000).toStringAsFixed(1)}t',
                  icon: Icons.line_weight,
                ),
                _buildCard(
                  context,
                  constraints,
                  label: 'Frequência',
                  value: '${metricas.frequenciaPercentual.toStringAsFixed(0)}%',
                  icon: Icons.calendar_month,
                ),
                _buildCard(
                  context,
                  constraints,
                  label: 'Sequência',
                  value: '${metricas.diasSequencia} dias',
                  icon: Icons.local_fire_department,
                  color: AppColors.primary,
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildCard(
    BuildContext context,
    BoxConstraints constraints, {
    required String label,
    required String value,
    required IconData icon,
    Color? color,
  }) {
    double width = (constraints.maxWidth - 12) / 2; 
    if (constraints.maxWidth > 600) {
      width = (constraints.maxWidth - 24) / 3;
    }
    // Ensure min width
    if (width < 100) width = 100;

    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color ?? AppColors.textSecondary),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color ?? AppColors.textPrimary,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
