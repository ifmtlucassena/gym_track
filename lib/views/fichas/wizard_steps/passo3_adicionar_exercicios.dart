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

    return Stack(
      children: [
        ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 90),
          itemCount: exercicios.length,
          itemBuilder: (context, index) {
            final exercicio = exercicios[index];
            return _ExercicioCard(
              key: ValueKey(exercicio.id),
              exercicio: exercicio,
              index: index,
              viewModel: viewModel,
              isFirst: index == 0,
              isLast: index == exercicios.length - 1,
              onDelete: () => _confirmarRemover(context, viewModel, index),
            );
          },
        ),
        // Botão flutuante no bottom
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
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
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, CriarFichaViewModel viewModel) {
    return Center(
      child: SingleChildScrollView(
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

// Widget de card de exercício com estado colapsável
class _ExercicioCard extends StatefulWidget {
  final dynamic exercicio;
  final int index;
  final CriarFichaViewModel viewModel;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onDelete;

  const _ExercicioCard({
    super.key,
    required this.exercicio,
    required this.index,
    required this.viewModel,
    required this.isFirst,
    required this.isLast,
    required this.onDelete,
  });

  @override
  State<_ExercicioCard> createState() => _ExercicioCardState();
}

class _ExercicioCardState extends State<_ExercicioCard> {
  bool _expandido = false;

  void _moverParaCima() {
    if (!widget.isFirst) {
      widget.viewModel.reordenarExercicios(widget.index, widget.index - 1);
    }
  }

  void _moverParaBaixo() {
    if (!widget.isLast) {
      widget.viewModel.reordenarExercicios(widget.index, widget.index + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            InkWell(
              onTap: () => setState(() => _expandido = !_expandido),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Info do exercício
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.exercicio.nome,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                widget.exercicio.grupo_muscular ?? '',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '• ${widget.exercicio.series.length} séries',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Botões de reordenação
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 32,
                          height: 32,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: widget.isFirst ? null : _moverParaCima,
                            icon: Icon(
                              Icons.keyboard_arrow_up,
                              color: widget.isFirst ? Colors.grey.shade300 : const Color(0xFF3B82F6),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 32,
                          height: 32,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: widget.isLast ? null : _moverParaBaixo,
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                              color: widget.isLast ? Colors.grey.shade300 : const Color(0xFF3B82F6),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 4),
                    // Botão remover
                    IconButton(
                      onPressed: widget.onDelete,
                      icon: const Icon(Icons.delete_outline),
                      color: Colors.red,
                    ),
                    const SizedBox(width: 4),
                    // Ícone de expandir/colapsar
                    Icon(
                      _expandido ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: Colors.grey.shade600,
                    ),
                  ],
                ),
              ),
            ),
            // Séries (colapsável)
            if (_expandido) ...[
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Séries',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...List.generate(widget.exercicio.series.length, (serieIndex) {
                      final serie = widget.exercicio.series[serieIndex];
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
          ],
        ),
      ),
    );
  }
}
