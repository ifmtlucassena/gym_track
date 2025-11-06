import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/criar_ficha_viewmodel.dart';

class Passo2NomearDias extends StatelessWidget {
  const Passo2NomearDias({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CriarFichaViewModel>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Passo 2 de 3',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF3B82F6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Nomeie seus dias de treino',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Dê um nome para cada dia de treino. Por exemplo: "Peito e Tríceps", "Costas e Bíceps", etc.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),

          // Lista de dias para nomear
          ...List.generate(viewModel.diasTreino.length, (index) {
            final dia = viewModel.diasTreino[index];
            final nomeController = TextEditingController(text: dia.nome);
            final descricaoController = TextEditingController(text: dia.descricao);

            // Atualizar quando o campo perde o foco
            nomeController.addListener(() {
              if (nomeController.text != dia.nome) {
                viewModel.atualizarNomeDia(index, nomeController.text);
              }
            });

            descricaoController.addListener(() {
              if (descricaoController.text != dia.descricao) {
                viewModel.atualizarDescricaoDia(index, descricaoController.text);
              }
            });

            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
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
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header do dia
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF3B82F6).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              _getDiaAbreviado(dia.diaSemana),
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF3B82F6),
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
                                _getNomeDiaCompleto(dia.diaSemana),
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1E293B),
                                ),
                              ),
                              Text(
                                'Dia ${index + 1} de ${viewModel.diasTreino.length}',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Campo Nome
                    TextField(
                      controller: nomeController,
                      decoration: InputDecoration(
                        labelText: 'Nome do Treino*',
                        hintText: 'Ex: Peito e Tríceps',
                        prefixIcon: const Icon(Icons.fitness_center),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                      style: GoogleFonts.inter(),
                    ),
                    const SizedBox(height: 16),

                    // Campo Descrição (opcional)
                    TextField(
                      controller: descricaoController,
                      decoration: InputDecoration(
                        labelText: 'Descrição (opcional)',
                        hintText: 'Ex: Foco em peito superior',
                        prefixIcon: const Icon(Icons.notes),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                      style: GoogleFonts.inter(),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            );
          }),

          // Info card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF3B82F6).withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.lightbulb_outline,
                  color: Color(0xFF3B82F6),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Dica: Use nomes que ajudem você a identificar rapidamente qual treino fazer em cada dia.',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: const Color(0xFF1E293B),
                      height: 1.4,
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

  String _getNomeDiaCompleto(int diaSemana) {
    const dias = [
      'Segunda-feira',
      'Terça-feira',
      'Quarta-feira',
      'Quinta-feira',
      'Sexta-feira',
      'Sábado',
      'Domingo',
    ];
    return dias[diaSemana];
  }

  String _getDiaAbreviado(int diaSemana) {
    const dias = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];
    return dias[diaSemana];
  }
}
