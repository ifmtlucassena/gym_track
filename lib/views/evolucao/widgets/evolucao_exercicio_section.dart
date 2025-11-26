import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../viewmodels/evolucao_viewmodel.dart';
import '../../../viewmodels/auth_viewmodel.dart';

class EvolucaoExercicioSection extends StatelessWidget {
  const EvolucaoExercicioSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<EvolucaoViewModel>();
    final evolucao = viewModel.evolucaoExercicio;
    final prs = viewModel.prs;

    if (prs.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Evolução por Exercício',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            DropdownButton<String>(
              value: viewModel.exercicioSelecionadoId,
              hint: const Text('Selecione'),
              underline: const SizedBox(),
              isExpanded: false,
              items: prs.map((pr) {
                return DropdownMenuItem(
                  value: pr.exercicioId,
                  child: Text(
                    pr.exercicioNome.length > 20 
                      ? '${pr.exercicioNome.substring(0, 17)}...' 
                      : pr.exercicioNome,
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  final pr = prs.firstWhere((e) => e.exercicioId == value);
                  final userId = context.read<AuthViewModel>().usuario?.id;
                  if (userId != null) {
                    context.read<EvolucaoViewModel>().selecionarExercicio(
                      userId, 
                      value, 
                      pr.exercicioNome
                    );
                  }
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          height: 250,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.divider),
          ),
          child: evolucao.isEmpty
              ? const Center(child: Text('Sem dados suficientes para gráfico'))
              : LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: AppColors.divider.withOpacity(0.5),
                          strokeWidth: 1,
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          interval: evolucao.length > 5 ? (evolucao.length / 5).toDouble() : 1,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index >= 0 && index < evolucao.length) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  DateFormat('dd/MM').format(evolucao[index].data),
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 10,
                                  ),
                                ),
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '${value.toInt()}kg',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 10,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    minX: 0,
                    maxX: (evolucao.length - 1).toDouble(),
                    minY: 0,
                    lineBarsData: [
                      LineChartBarData(
                        spots: evolucao.asMap().entries.map((e) {
                          return FlSpot(e.key.toDouble(), e.value.valor);
                        }).toList(),
                        isCurved: true,
                        color: AppColors.primary,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: true),
                        belowBarData: BarAreaData(
                          show: true,
                          color: AppColors.primary.withOpacity(0.1),
                        ),
                      ),
                    ],
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipColor: (touchedSpot) => AppColors.surface,
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((spot) {
                            return LineTooltipItem(
                              '${spot.y}kg',
                              const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                            );
                          }).toList();
                        },
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
