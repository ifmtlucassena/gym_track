import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/templates/ficha_templates.dart';

class TemplateCard extends StatelessWidget {
  final FichaTemplate template;
  final VoidCallback onTap;

  const TemplateCard({
    super.key,
    required this.template,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge de nível
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getCorNivel().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getNivelLabel(),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _getCorNivel(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Nome do template
              Text(
                template.nome,
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              // Descrição
              Text(
                template.descricao,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              // Informações
              Row(
                children: [
                  _buildInfoChip(
                    icon: Icons.calendar_today,
                    label: '${template.diasPorSemana}x/semana',
                    color: const Color(0xFF3B82F6),
                  ),
                  const SizedBox(width: 12),
                  _buildInfoChip(
                    icon: Icons.fitness_center,
                    label: '${_contarExercicios()} exercícios',
                    color: const Color(0xFF8B5CF6),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Botão ver detalhes
              Row(
                children: [
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () => _mostrarDetalhes(context),
                    icon: const Icon(Icons.info_outline, size: 18),
                    label: Text(
                      'Ver Detalhes',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getCorNivel() {
    switch (template.nivel) {
      case 'iniciante':
        return const Color(0xFF10B981);
      case 'intermediario':
        return const Color(0xFFF59E0B);
      case 'avancado':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF3B82F6);
    }
  }

  String _getNivelLabel() {
    switch (template.nivel) {
      case 'iniciante':
        return 'INICIANTE';
      case 'intermediario':
        return 'INTERMEDIÁRIO';
      case 'avancado':
        return 'AVANÇADO';
      default:
        return template.nivel.toUpperCase();
    }
  }

  int _contarExercicios() {
    int total = 0;
    for (var dia in template.diasTreino) {
      total += dia.exercicios.length;
    }
    return total;
  }

  void _mostrarDetalhes(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          template.nome,
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                template.descricao,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Dias de treino:',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 12),
              ...template.diasTreino.map((dia) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.fitness_center,
                                size: 16,
                                color: _getCorNivel(),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  dia.nome,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1E293B),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (dia.descricao != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              dia.descricao!,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                          const SizedBox(height: 8),
                          Text(
                            '${dia.exercicios.length} exercícios • ~${dia.duracaoEstimada} min',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: const Color(0xFF3B82F6),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Fechar',
              style: GoogleFonts.inter(
                color: Colors.grey.shade600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onTap();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
            ),
            child: Text(
              'Escolher Esta',
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
