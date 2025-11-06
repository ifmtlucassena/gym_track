import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/criar_ficha_viewmodel.dart';
import '../buscar_exercicios_screen.dart';

class Passo3AdicionarExercicios extends StatelessWidget {
  const Passo3AdicionarExercicios({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CriarFichaViewModel>();

    return Column(
      children: [
        // Header fixo
        Container(
          color: const Color(0xFFF8F9FA),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Passo 3 de 3',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF3B82F6),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Adicione exercícios',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Adicione exercícios para cada dia de treino. Você pode organizar a ordem e configurar séries, repetições e peso.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),

        // Tabs dos dias
        if (viewModel.diasTreino.isNotEmpty)
          Container(
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: List.generate(viewModel.diasTreino.length, (index) {
                  final dia = viewModel.diasTreino[index];
                  final isSelected = viewModel.diaAtualIndex == index;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(dia.nome),
                      selected: isSelected,
                      onSelected: (_) => viewModel.selecionarDia(index),
                      backgroundColor: Colors.grey.shade100,
                      selectedColor: const Color(0xFF3B82F6),
                      labelStyle: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : const Color(0xFF1E293B),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),

        const Divider(height: 1),

        // Lista de exercícios do dia selecionado
        Expanded(
          child: _buildExerciciosList(context, viewModel),
        ),
      ],
    );
  }

  Widget _buildExerciciosList(
    BuildContext context,
    CriarFichaViewModel viewModel,
  ) {
    if (viewModel.diasTreino.isEmpty) {
      return const Center(child: Text('Nenhum dia de treino'));
    }

    final diaAtual = viewModel.diasTreino[viewModel.diaAtualIndex];
    final exercicios = diaAtual.exercicios;

    if (exercicios.isEmpty) {
      return _buildEmptyState(context, viewModel);
    }

    return ReorderableListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: exercicios.length + 1,
      onReorder: (oldIndex, newIndex) {
        if (newIndex > oldIndex) {
          newIndex -= 1;
        }
        viewModel.reordenarExercicios(oldIndex, newIndex);
      },
      itemBuilder: (context, index) {
        // Botão adicionar no final
        if (index == exercicios.length) {
          return _buildBotaoAdicionar(context, viewModel, key: const ValueKey('add'));
        }

        final exercicio = exercicios[index];
        return _buildExercicioCard(
          context,
          viewModel,
          exercicio,
          index,
          key: ValueKey(exercicio.id),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, CriarFichaViewModel viewModel) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                Icons.fitness_center,
                size: 40,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Nenhum exercício adicionado',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Comece adicionando exercícios para este dia de treino',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _abrirBuscaExercicios(context, viewModel),
              icon: const Icon(Icons.add),
              label: Text(
                'Adicionar Exercício',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBotaoAdicionar(
    BuildContext context,
    CriarFichaViewModel viewModel, {
    required Key key,
  }) {
    return Padding(
      key: key,
      padding: const EdgeInsets.only(top: 12),
      child: OutlinedButton.icon(
        onPressed: () => _abrirBuscaExercicios(context, viewModel),
        icon: const Icon(Icons.add),
        label: Text(
          'Adicionar Exercício',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF3B82F6),
          side: const BorderSide(color: Color(0xFF3B82F6), width: 2),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildExercicioCard(
    BuildContext context,
    CriarFichaViewModel viewModel,
    dynamic exercicio,
    int index, {
    required Key key,
  }) {
    return Padding(
      key: key,
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Handle para reordenar
                  Icon(
                    Icons.drag_handle,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(width: 12),
                  // Info do exercício
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exercicio.nome,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          exercicio.grupo_muscular ?? '',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Botão remover
                  IconButton(
                    onPressed: () => _confirmarRemover(context, viewModel, index),
                    icon: const Icon(Icons.delete_outline),
                    color: Colors.red,
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Séries
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Séries',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                      Text(
                        '${exercicio.series.length} séries',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(exercicio.series.length, (serieIndex) {
                    final serie = exercicio.series[serieIndex];
                    final peso = serie.peso != null ? '${serie.peso}kg' : '-';
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Série ${serieIndex + 1}:',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                '${serie.repeticoes} reps • $peso',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: const Color(0xFF1E293B),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _abrirBuscaExercicios(
    BuildContext context,
    CriarFichaViewModel viewModel,
  ) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const BuscarExerciciosScreen(),
      ),
    );

    if (resultado != null) {
      viewModel.adicionarExercicio(resultado);
    }
  }

  void _confirmarRemover(
    BuildContext context,
    CriarFichaViewModel viewModel,
    int index,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Remover Exercício',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Deseja remover este exercício do treino?',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: GoogleFonts.inter(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              viewModel.removerExercicio(index);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(
              'Remover',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
