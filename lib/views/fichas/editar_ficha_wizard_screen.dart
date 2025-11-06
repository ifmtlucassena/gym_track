import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gym_track/models/ficha_model.dart';
import 'package:gym_track/viewmodels/criar_ficha_viewmodel.dart';
import 'package:gym_track/views/fichas/wizard_steps/passo1_selecionar_dias.dart';
import 'package:gym_track/views/fichas/wizard_steps/passo2_nomear_dias.dart';
import 'package:gym_track/views/fichas/wizard_steps/passo3_adicionar_exercicios.dart';
import 'package:gym_track/services/auth_service.dart';

class EditarFichaWizardScreen extends StatelessWidget {
  final FichaModel ficha;

  const EditarFichaWizardScreen({super.key, required this.ficha});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return ChangeNotifierProvider(
      create: (_) {
        final viewModel = CriarFichaViewModel();
        viewModel.inicializarComFicha(ficha);
        return viewModel;
      },
      child: Consumer<CriarFichaViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(viewModel.modoEdicao ? 'Editar Ficha' : 'Criar Ficha'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  // A lógica de voltar agora é tratada pelo botão na barra inferior
                  // ou pelo gesto de voltar do sistema.
                  if (viewModel.passoAtual == PassoWizard.selecionarDias) {
                    Navigator.of(context).pop();
                  } else {
                    viewModel.voltarPasso();
                  }
                },
              ),
            ),
            body: Column(
              children: [
                LinearProgressIndicator(
                  value: viewModel.getProgressoPercentual() / 100,
                  backgroundColor: Colors.grey[300],
                ),
                Expanded(
                  child: _buildStep(context, viewModel),
                ),
              ],
            ),
            bottomNavigationBar: _buildBottomNavigationBar(context, viewModel, authService.currentUser?.uid),
          );
        },
      ),
    );
  }

  Widget _buildStep(BuildContext context, CriarFichaViewModel viewModel) {
    switch (viewModel.passoAtual) {
      case PassoWizard.selecionarDias:
        return const Passo1SelecionarDias();
      case PassoWizard.nomearDias:
        return const Passo2NomearDias();
      case PassoWizard.adicionarExercicios:
        return const Passo3AdicionarExercicios();
    }
  }

  Widget _buildBottomNavigationBar(BuildContext context, CriarFichaViewModel viewModel, String? usuarioId) {
    return Container(
      padding: const EdgeInsets.all(16.0).copyWith(bottom: MediaQuery.of(context).padding.bottom + 16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (viewModel.passoAtual != PassoWizard.selecionarDias)
            TextButton(
              onPressed: viewModel.voltarPasso,
              child: const Text('Voltar'),
            )
          else
            const SizedBox(), // Espaço vazio para alinhar o botão de continuar à direita
          
          ElevatedButton(
            onPressed: () => _onNextPressed(context, viewModel, usuarioId),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: Text(
              viewModel.passoAtual == PassoWizard.adicionarExercicios
                  ? (viewModel.modoEdicao ? 'Salvar Alterações' : 'Salvar Ficha')
                  : 'Continuar',
            ),
          ),
        ],
      ),
    );
  }

  void _onNextPressed(BuildContext context, CriarFichaViewModel viewModel, String? usuarioId) async {
    // Limpa qualquer erro anterior antes de tentar avançar
    viewModel.limparErro();

    VoidCallback? action;
    switch (viewModel.passoAtual) {
      case PassoWizard.selecionarDias:
        action = viewModel.avancarParaPasso2;
        break;
      case PassoWizard.nomearDias:
        action = viewModel.avancarParaPasso3;
        break;
      case PassoWizard.adicionarExercicios:
        if (usuarioId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro: Usuário não autenticado.')),
          );
          return;
        }
        final success = await viewModel.salvarFicha(usuarioId);
        if (context.mounted) {
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Ficha salva com sucesso!')),
            );
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
          // O erro já será exibido pelo listener do viewModel
        }
        return; // Retorna para não executar o código abaixo
    }

    action.call();

    // Exibe o erro se houver um após a tentativa de ação
    if (viewModel.mensagemErro != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(viewModel.mensagemErro!)),
      );
    }
  }
}
