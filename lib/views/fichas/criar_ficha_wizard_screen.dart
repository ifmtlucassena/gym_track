import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/criar_ficha_viewmodel.dart';
import '../../viewmodels/ficha_viewmodel.dart';
import 'wizard_steps/passo1_selecionar_dias.dart';
import 'wizard_steps/passo2_nomear_dias.dart';
import 'wizard_steps/passo3_adicionar_exercicios.dart';

class CriarFichaWizardScreen extends StatelessWidget {
  const CriarFichaWizardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final criarFichaViewModel = context.watch<CriarFichaViewModel>();
    final authViewModel = context.watch<AuthViewModel>();

    return WillPopScope(
      onWillPop: () async {
        if (criarFichaViewModel.passoAtual != PassoWizard.selecionarDias) {
          _mostrarDialogoVoltar(context, criarFichaViewModel);
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
            onPressed: () {
              if (criarFichaViewModel.passoAtual != PassoWizard.selecionarDias) {
                _mostrarDialogoVoltar(context, criarFichaViewModel);
              } else {
                Navigator.pop(context);
              }
            },
          ),
          title: Text(
            'Criar Ficha Personalizada',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1E293B),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(8),
            child: LinearProgressIndicator(
              value: criarFichaViewModel.getProgressoPercentual() / 100,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF3B82F6),
              ),
            ),
          ),
        ),
        body: _buildPasso(criarFichaViewModel.passoAtual),
        bottomNavigationBar: _buildBottomBar(
          context,
          criarFichaViewModel,
          authViewModel,
        ),
      ),
    );
  }

  Widget _buildPasso(PassoWizard passo) {
    switch (passo) {
      case PassoWizard.selecionarDias:
        return const Passo1SelecionarDias();
      case PassoWizard.nomearDias:
        return const Passo2NomearDias();
      case PassoWizard.adicionarExercicios:
        return const Passo3AdicionarExercicios();
    }
  }

  Widget _buildBottomBar(
    BuildContext context,
    CriarFichaViewModel viewModel,
    AuthViewModel authViewModel,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Botão Voltar
          if (viewModel.passoAtual != PassoWizard.selecionarDias)
            Expanded(
              child: OutlinedButton(
                onPressed: () => viewModel.voltarPasso(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Color(0xFF3B82F6)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Voltar',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF3B82F6),
                  ),
                ),
              ),
            ),
          if (viewModel.passoAtual != PassoWizard.selecionarDias)
            const SizedBox(width: 12),
          // Botão Continuar/Finalizar
          Expanded(
            flex: viewModel.passoAtual == PassoWizard.selecionarDias ? 1 : 2,
            child: ElevatedButton(
              onPressed: viewModel.carregando
                  ? null
                  : () => _onContinuar(context, viewModel, authViewModel),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBackgroundColor: Colors.grey.shade300,
              ),
              child: viewModel.carregando
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      _getTextoBotao(viewModel.passoAtual),
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  String _getTextoBotao(PassoWizard passo) {
    switch (passo) {
      case PassoWizard.selecionarDias:
        return 'Continuar';
      case PassoWizard.nomearDias:
        return 'Continuar';
      case PassoWizard.adicionarExercicios:
        return 'Finalizar e Salvar';
    }
  }

  void _onContinuar(
    BuildContext context,
    CriarFichaViewModel viewModel,
    AuthViewModel authViewModel,
  ) async {
    switch (viewModel.passoAtual) {
      case PassoWizard.selecionarDias:
        if (!viewModel.podeContinuarPasso1()) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Selecione pelo menos um dia de treino'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        viewModel.avancarParaPasso2();
        break;

      case PassoWizard.nomearDias:
        if (!viewModel.podeContinuarPasso2()) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Todos os dias devem ter um nome'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        viewModel.avancarParaPasso3();
        break;

      case PassoWizard.adicionarExercicios:
        // Mostrar diálogo para nomear a ficha
        _mostrarDialogoNomearFicha(context, viewModel, authViewModel);
        break;
    }
  }

  void _mostrarDialogoNomearFicha(
    BuildContext context,
    CriarFichaViewModel viewModel,
    AuthViewModel authViewModel,
  ) {
    final nomeController = TextEditingController();
    final descricaoController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          'Nomear Ficha',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome da Ficha*',
                  hintText: 'Ex: Minha Ficha de Hipertrofia',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                style: GoogleFonts.inter(),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descricaoController,
                decoration: InputDecoration(
                  labelText: 'Descrição (opcional)',
                  hintText: 'Ex: Focado em ganho de massa',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                style: GoogleFonts.inter(),
                maxLines: 3,
              ),
            ],
          ),
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
              final nome = nomeController.text.trim();
              if (nome.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('O nome da ficha é obrigatório'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              Navigator.pop(context); // Fecha o diálogo

              viewModel.setNomeFicha(nome);
              viewModel.setDescricaoFicha(descricaoController.text.trim());

              final usuarioId = authViewModel.usuario?.id;
              if (usuarioId == null) return;

              final sucesso = await viewModel.salvarFicha(usuarioId);

              if (context.mounted) {
                if (sucesso) {
                  // Recarrega as fichas
                  final fichaViewModel = Provider.of<FichaViewModel>(context, listen: false);
                  await fichaViewModel.carregarFichas(usuarioId);

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ficha criada com sucesso!'),
                        backgroundColor: Color(0xFF10B981),
                      ),
                    );
                    // Volta para FichasScreen (fecha wizard e escolher ficha)
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        viewModel.mensagemErro ?? 'Erro ao criar ficha',
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
              'Salvar Ficha',
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

  void _mostrarDialogoVoltar(
    BuildContext context,
    CriarFichaViewModel viewModel,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Voltar ao passo anterior?',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Deseja voltar ao passo anterior?',
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
              viewModel.voltarPasso();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
            ),
            child: Text(
              'Voltar',
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
