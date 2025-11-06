import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/criar_ficha_viewmodel.dart';

class Passo1SelecionarDias extends StatelessWidget {
  const Passo1SelecionarDias({super.key});

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
            'Passo 1 de 3',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF3B82F6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Selecione os dias de treino',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Escolha em quais dias da semana você vai treinar. Você pode selecionar quantos dias quiser.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),

          // Lista de dias
          Container(
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
              children: List.generate(7, (index) {
                final diaSelecionado = viewModel.diasSelecionados[index];
                final nomeDia = _getNomeDiaCompleto(index);
                final nomeAbreviado = viewModel.getNomeDiaSemanaAbreviado(index);

                return Column(
                  children: [
                    if (index > 0) const Divider(height: 1),
                    InkWell(
                      onTap: () => viewModel.toggleDia(index),
                      borderRadius: BorderRadius.vertical(
                        top: index == 0 ? const Radius.circular(16) : Radius.zero,
                        bottom: index == 6 ? const Radius.circular(16) : Radius.zero,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        child: Row(
                          children: [
                            // Checkbox customizado
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: diaSelecionado
                                    ? const Color(0xFF3B82F6)
                                    : Colors.transparent,
                                border: Border.all(
                                  color: diaSelecionado
                                      ? const Color(0xFF3B82F6)
                                      : Colors.grey.shade300,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: diaSelecionado
                                  ? const Icon(
                                      Icons.check,
                                      size: 16,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 16),
                            // Nome do dia
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    nomeDia,
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF1E293B),
                                    ),
                                  ),
                                  if (diaSelecionado)
                                    Text(
                                      'Dia de treino',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: const Color(0xFF3B82F6),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            // Badge com abreviação
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: diaSelecionado
                                    ? const Color(0xFF3B82F6).withOpacity(0.1)
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                nomeAbreviado,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: diaSelecionado
                                      ? const Color(0xFF3B82F6)
                                      : Colors.grey.shade600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
          const SizedBox(height: 24),

          // Info card
          if (viewModel.diasSelecionados.where((d) => d).length > 0)
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
                    Icons.info_outline,
                    color: Color(0xFF3B82F6),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${viewModel.diasSelecionados.where((d) => d).length} ${viewModel.diasSelecionados.where((d) => d).length == 1 ? 'dia selecionado' : 'dias selecionados'}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1E293B),
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

  String _getNomeDiaCompleto(int index) {
    const dias = [
      'Segunda-feira',
      'Terça-feira',
      'Quarta-feira',
      'Quinta-feira',
      'Sexta-feira',
      'Sábado',
      'Domingo',
    ];
    return dias[index];
  }
}
