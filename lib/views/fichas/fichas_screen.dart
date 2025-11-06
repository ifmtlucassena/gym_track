import 'package:flutter/material.dart';// TODO: Implementar fichas screen

import 'package:gym_track/views/fichas/editar_ficha_wizard_screen.dart';
import 'package:gym_track/views/fichas/detalhe_ficha_screen.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/ficha_viewmodel.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/ficha_card.dart';
import 'escolher_ficha_pronta_screen.dart';

class FichasScreen extends StatefulWidget {
  const FichasScreen({super.key});

  @override
  State<FichasScreen> createState() => _FichasScreenState();
}

class _FichasScreenState extends State<FichasScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authViewModel = context.read<AuthViewModel>();
      final fichaViewModel = context.read<FichaViewModel>();
      if (authViewModel.usuario != null) {
        fichaViewModel.carregarFichas(authViewModel.usuario!.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();
    final fichaViewModel = context.watch<FichaViewModel>();
    final usuario = authViewModel.usuario;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: CustomAppBar(
        title: 'Minhas Fichas',
        onNotificationTap: () {},
      ),
      body: _buildBody(fichaViewModel, usuario?.id),
      floatingActionButton: fichaViewModel.estado == EstadoFichas.vazio
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EscolherFichaProntaScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: Text(
                'Nova Ficha',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                ),
              ),
              backgroundColor: const Color(0xFF3B82F6),
              foregroundColor: Colors.white,
            ),
    );
  }

  Widget _buildBody(FichaViewModel fichaViewModel, String? usuarioId) {
    if (fichaViewModel.estado == EstadoFichas.carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (fichaViewModel.estado == EstadoFichas.erro) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'Erro ao carregar fichas',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              fichaViewModel.mensagemErro ?? 'Erro desconhecido',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (usuarioId != null) {
                  fichaViewModel.carregarFichas(usuarioId);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: Text(
                'Tentar novamente',
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

    if (fichaViewModel.estado == EstadoFichas.vazio) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        if (usuarioId != null) {
          await fichaViewModel.carregarFichas(usuarioId);
        }
      },
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Fichas Ativas
          if (fichaViewModel.fichasAtivas.isNotEmpty) ...[
            Text(
              'Ficha Ativa',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 12),
            ...fichaViewModel.fichasAtivas.map(
              (ficha) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: FichaCard(
                  ficha: ficha,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetalheFichaScreen(ficha: ficha),
                      ),
                    );
                  },
                  onDesativar: () {
                    _mostrarDialogoDesativar(
                      context,
                      ficha.id,
                      fichaViewModel,
                      usuarioId!,
                    );
                  },
                  onEditar: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditarFichaWizardScreen(ficha: ficha),
                      ),
                    ).then((_) {
                      // Recarrega as fichas quando a tela de edição é fechada
                      if (usuarioId != null) {
                        fichaViewModel.carregarFichas(usuarioId);
                      }
                    });
                  },
                  onDeletar: () {
                    _mostrarDialogoDeletar(
                      context,
                      ficha.id,
                      fichaViewModel,
                      usuarioId!,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
          // Fichas Inativas
          if (fichaViewModel.fichasInativas.isNotEmpty) ...[
            Text(
              'Fichas Anteriores',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 12),
            ...fichaViewModel.fichasInativas.map(
              (ficha) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: FichaCard(
                  ficha: ficha,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetalheFichaScreen(ficha: ficha),
                      ),
                    );
                  },
                  onAtivar: () {
                    _mostrarDialogoAtivar(
                      context,
                      ficha.id,
                      fichaViewModel,
                      usuarioId!,
                    );
                  },
                  onEditar: () {
                    // TODO: Navegar para edição
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Edição em breve'),
                      ),
                    );
                  },
                  onDeletar: () {
                    _mostrarDialogoDeletar(
                      context,
                      ficha.id,
                      fichaViewModel,
                      usuarioId!,
                    );
                  },
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.assignment,
                size: 64,
                color: Color(0xFF3B82F6),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Nenhuma ficha criada',
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Comece escolhendo uma ficha pronta ou crie a sua própria ficha personalizada.',
              style: GoogleFonts.inter(
                fontSize: 15,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EscolherFichaProntaScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: Text(
                'Criar Minha Primeira Ficha',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
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

  void _mostrarDialogoAtivar(
    BuildContext context,
    String fichaId,
    FichaViewModel fichaViewModel,
    String usuarioId,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Ativar ficha',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Deseja ativar esta ficha? A ficha ativa atual será desativada.',
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
              Navigator.pop(context);
              final sucesso = await fichaViewModel.ativarFicha(
                fichaId,
                usuarioId,
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      sucesso
                          ? 'Ficha ativada com sucesso!'
                          : 'Erro ao ativar ficha',
                    ),
                    backgroundColor:
                        sucesso ? const Color(0xFF10B981) : Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
            ),
            child: Text(
              'Ativar',
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

  void _mostrarDialogoDesativar(
    BuildContext context,
    String fichaId,
    FichaViewModel fichaViewModel,
    String usuarioId,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Desativar ficha',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Deseja desativar esta ficha? Você poderá reativá-la depois.',
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
              Navigator.pop(context);
              final sucesso = await fichaViewModel.desativarFicha(
                fichaId,
                usuarioId,
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      sucesso
                          ? 'Ficha desativada com sucesso!'
                          : 'Erro ao desativar ficha',
                    ),
                    backgroundColor:
                        sucesso ? Colors.orange.shade700 : Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade700,
            ),
            child: Text(
              'Desativar',
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

  void _mostrarDialogoDeletar(
    BuildContext context,
    String fichaId,
    FichaViewModel fichaViewModel,
    String usuarioId,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Deletar ficha',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Tem certeza que deseja deletar esta ficha? Esta ação não pode ser desfeita.',
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
              Navigator.pop(context);
              final sucesso = await fichaViewModel.deletarFicha(
                fichaId,
                usuarioId,
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      sucesso
                          ? 'Ficha deletada com sucesso!'
                          : 'Erro ao deletar ficha',
                    ),
                    backgroundColor: sucesso ? Colors.red : Colors.red.shade900,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(
              'Deletar',
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
