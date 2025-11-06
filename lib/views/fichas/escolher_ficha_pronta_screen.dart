import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../data/templates/ficha_templates.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/ficha_viewmodel.dart';
import '../../widgets/template_card.dart';
import 'criar_ficha_wizard_screen.dart';

class EscolherFichaProntaScreen extends StatelessWidget {
  const EscolherFichaProntaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();
    final fichaViewModel = context.watch<FichaViewModel>();
    final usuarioId = authViewModel.usuario?.id;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Escolher Ficha Pronta',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1E293B),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Descrição geral
            Text(
              'Criar Nova Ficha',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Crie sua ficha personalizada ou escolha um template pronto.',
              style: GoogleFonts.inter(
                fontSize: 15,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),

            // Botão Criar Ficha Personalizada
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CriarFichaWizardScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add_circle_outline),
                label: Text(
                  'Criar Ficha Personalizada',
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
            const SizedBox(height: 24),

            // Divisor
            Row(
              children: [
                Expanded(child: Divider(color: Colors.grey.shade300)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'ou',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
                Expanded(child: Divider(color: Colors.grey.shade300)),
              ],
            ),
            const SizedBox(height: 20),

            // Título templates
            Text(
              'Templates Prontos',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 12),

            // Lista de templates
            Expanded(
              child: ListView.builder(
                itemCount: FichaTemplates.templates.length,
                itemBuilder: (context, index) {
                  final template = FichaTemplates.templates[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: TemplateCard(
                      template: template,
                      onTap: () {
                        _mostrarDialogoConfirmacao(
                          context,
                          template.id,
                          template.nome,
                          fichaViewModel,
                          usuarioId!,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarDialogoConfirmacao(
    BuildContext context,
    String templateId,
    String templateNome,
    FichaViewModel fichaViewModel,
    String usuarioId,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Criar ficha',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Deseja criar a ficha "$templateNome"? Ela será ativada automaticamente.',
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
            onPressed: () async {
              Navigator.pop(context); // Fecha o diálogo de confirmação

              // Mostra loading
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => WillPopScope(
                  onWillPop: () async => false,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );

              // Cria a ficha
              final sucesso = await fichaViewModel.criarFichaDeTemplate(
                templateId: templateId,
                usuarioId: usuarioId,
              );

              // Fecha o loading
              if (context.mounted) {
                Navigator.pop(context);
              }

              // Mostra resultado e volta para a tela de fichas
              if (context.mounted) {
                if (sucesso) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Ficha criada com sucesso!'),
                      backgroundColor: Color(0xFF10B981),
                    ),
                  );
                  // Volta para FichasScreen (fecha a tela de escolher ficha)
                  Navigator.of(context).popUntil((route) => route.isFirst);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        fichaViewModel.mensagemErro ?? 'Erro ao criar ficha',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
            ),
            child: Text(
              'Criar Ficha',
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
