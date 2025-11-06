import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/ficha_model.dart';

class FichaCard extends StatelessWidget {
  final FichaModel ficha;
  final VoidCallback? onTap;
  final VoidCallback? onAtivar;
  final VoidCallback? onDesativar;
  final VoidCallback? onEditar;
  final VoidCallback? onDeletar;

  const FichaCard({
    super.key,
    required this.ficha,
    this.onTap,
    this.onAtivar,
    this.onDesativar,
    this.onEditar,
    this.onDeletar,
  });

  @override
  Widget build(BuildContext context) {
    final isAtiva = ficha.ativa;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isAtiva ? const Color(0xFF10B981) : Colors.grey.shade300,
          width: isAtiva ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabeçalho
              Row(
                children: [
                  // Badge de status
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isAtiva
                          ? const Color(0xFF10B981).withOpacity(0.1)
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isAtiva ? Icons.check_circle : Icons.pause_circle,
                          color: isAtiva
                              ? const Color(0xFF10B981)
                              : Colors.grey.shade600,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isAtiva ? 'Ativa' : 'Inativa',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isAtiva
                                ? const Color(0xFF10B981)
                                : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Menu de opções
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'ativar':
                          onAtivar?.call();
                          break;
                        case 'desativar':
                          onDesativar?.call();
                          break;
                        case 'editar':
                          onEditar?.call();
                          break;
                        case 'deletar':
                          onDeletar?.call();
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      if (!isAtiva)
                        PopupMenuItem(
                          value: 'ativar',
                          child: Row(
                            children: [
                              const Icon(Icons.play_arrow,
                                  color: Color(0xFF10B981)),
                              const SizedBox(width: 8),
                              Text(
                                'Ativar',
                                style: GoogleFonts.inter(),
                              ),
                            ],
                          ),
                        ),
                      if (isAtiva)
                        PopupMenuItem(
                          value: 'desativar',
                          child: Row(
                            children: [
                              Icon(Icons.pause, color: Colors.orange.shade700),
                              const SizedBox(width: 8),
                              Text(
                                'Desativar',
                                style: GoogleFonts.inter(),
                              ),
                            ],
                          ),
                        ),
                      PopupMenuItem(
                        value: 'editar',
                        child: Row(
                          children: [
                            Icon(Icons.edit, color: Colors.blue.shade700),
                            const SizedBox(width: 8),
                            Text(
                              'Editar',
                              style: GoogleFonts.inter(),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'deletar',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red.shade700),
                            const SizedBox(width: 8),
                            Text(
                              'Deletar',
                              style: GoogleFonts.inter(),
                            ),
                          ],
                        ),
                      ),
                    ],
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Nome da ficha
              Text(
                ficha.nome,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E293B),
                ),
              ),
              if (ficha.descricao != null) ...[
                const SizedBox(height: 4),
                Text(
                  ficha.descricao!,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              // Informações
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  _buildInfoChip(
                    icon: Icons.calendar_today,
                    label: '${ficha.diasTreino.length} dias',
                    color: const Color(0xFF3B82F6),
                  ),
                  _buildInfoChip(
                    icon: Icons.fitness_center,
                    label: '${_contarExercicios()} exercícios',
                    color: const Color(0xFF8B5CF6),
                  ),
                  if (ficha.dataInicio != null)
                    _buildInfoChip(
                      icon: Icons.event_available,
                      label: _formatarData(ficha.dataInicio!),
                      color: const Color(0xFF10B981),
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

  int _contarExercicios() {
    int total = 0;
    for (var dia in ficha.diasTreino) {
      total += dia.exercicios.length;
    }
    return total;
  }

  String _formatarData(DateTime data) {
    final agora = DateTime.now();
    final diferenca = agora.difference(data).inDays;

    if (diferenca == 0) return 'Iniciada hoje';
    if (diferenca == 1) return 'Iniciada ontem';
    if (diferenca < 7) return 'Iniciada há $diferenca dias';
    if (diferenca < 30) return 'Iniciada há ${(diferenca / 7).floor()} semanas';

    return 'Iniciada há ${(diferenca / 30).floor()} meses';
  }
}
