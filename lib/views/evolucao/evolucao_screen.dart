import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../viewmodels/evolucao_viewmodel.dart';
import '../../viewmodels/auth_viewmodel.dart';
import 'widgets/resumo_geral_section.dart';
import 'widgets/insights_section.dart';
import 'widgets/recordes_pessoais_section.dart';
import 'widgets/evolucao_exercicio_section.dart';
import 'widgets/historico_treinos_section.dart';

class EvolucaoScreen extends StatefulWidget {
  const EvolucaoScreen({super.key});

  @override
  State<EvolucaoScreen> createState() => _EvolucaoScreenState();
}

class _EvolucaoScreenState extends State<EvolucaoScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthViewModel>().usuario?.id;
      if (userId != null) {
        context.read<EvolucaoViewModel>().carregarDados(userId);
      }
    });
  }

  void _mostrarFiltroPeriodo() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildFiltroPeriodoModal(),
    );
  }

  Widget _buildFiltroPeriodoModal() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Filtrar Período',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          _buildOpcaoFiltro('Últimos 7 dias', 7),
          _buildOpcaoFiltro('Últimos 30 dias', 30),
          _buildOpcaoFiltro('Últimos 90 dias', 90),
          _buildOpcaoFiltro('Últimos 180 dias', 180),
          _buildOpcaoFiltro('Este ano', 365),
        ],
      ),
    );
  }

  Widget _buildOpcaoFiltro(String label, int dias) {
    return ListTile(
      title: Text(label),
      onTap: () {
        final userId = context.read<AuthViewModel>().usuario?.id;
        if (userId != null) {
          final fim = DateTime.now();
          final inicio = fim.subtract(Duration(days: dias));
          context.read<EvolucaoViewModel>().setPeriodo(userId, inicio, fim, label);
        }
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Evolução'),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          Consumer<EvolucaoViewModel>(
            builder: (context, viewModel, _) {
              return TextButton.icon(
                onPressed: _mostrarFiltroPeriodo,
                icon: const Icon(Icons.calendar_today, size: 16),
                label: Text(viewModel.periodoLabel),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<EvolucaoViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.error != null) {
            return Center(child: Text('Erro: ${viewModel.error}'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              final userId = context.read<AuthViewModel>().usuario?.id;
              if (userId != null) {
                await viewModel.carregarDados(userId);
              }
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [
                  ResumoGeralSection(),
                  SizedBox(height: 24),
                  InsightsSection(),
                  SizedBox(height: 24),
                  RecordesPessoaisSection(),
                  SizedBox(height: 24),
                  EvolucaoExercicioSection(),
                  SizedBox(height: 24),
                  HistoricoTreinosSection(),
                  SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
