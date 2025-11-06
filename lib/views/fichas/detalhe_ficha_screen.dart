import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_track/models/ficha_model.dart';
import 'package:gym_track/views/fichas/editar_ficha_wizard_screen.dart';

class DetalheFichaScreen extends StatelessWidget {
  final FichaModel ficha;

  const DetalheFichaScreen({super.key, required this.ficha});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: ficha.diasTreino.length,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            ficha.nome,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1E293B),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit, color: Color(0xFF1E293B)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditarFichaWizardScreen(ficha: ficha),
                  ),
                );
              },
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            labelColor: const Color(0xFF3B82F6),
            unselectedLabelColor: Colors.grey.shade600,
            indicatorColor: const Color(0xFF3B82F6),
            tabs: ficha.diasTreino
                .map((dia) => Tab(text: dia.nome.toUpperCase()))
                .toList(),
          ),
        ),
        body: TabBarView(
          children: ficha.diasTreino.map((dia) {
            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: dia.exercicios.length,
              itemBuilder: (context, index) {
                final exercicio = dia.exercicios[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
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
                        if (exercicio.grupo_muscular != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            exercicio.grupo_muscular!,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                        const SizedBox(height: 12),
                        ...exercicio.series.map((serie) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Text(
                              '${serie.numeroSerie}x ${serie.repeticoes} reps',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          );
                        }).toList(),
                        if (exercicio.descanso != null) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.timer, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                '${exercicio.descanso}s de descanso',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ]
                      ],
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
