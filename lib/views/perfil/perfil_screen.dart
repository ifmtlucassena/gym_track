import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../viewmodels/perfil_viewmodel.dart';
import '../../../viewmodels/auth_viewmodel.dart';
import 'widgets/perfil_header.dart';
import 'widgets/estatisticas_section.dart';
import 'widgets/dados_pessoais_section.dart';
import 'widgets/sobre_section.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthViewModel>().usuario?.id;
      if (userId != null) {
        context.read<PerfilViewModel>().carregarPerfil(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PerfilViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Perfil'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
      body: viewModel.isLoading && viewModel.usuario == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                children: [
                  const PerfilHeader(),
                  const SizedBox(height: 24),
                  const EstatisticasSection(),
                  const SizedBox(height: 24),
                  const DadosPessoaisSection(),
                  const SizedBox(height: 24),
                  const SobreSection(),
                  const SizedBox(height: 32),
                  _buildLogoutButton(context, viewModel),
                ],
              ),
            ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, PerfilViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton.icon(
          onPressed: () => _confirmarLogout(context, viewModel),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          icon: const Icon(Icons.logout),
          label: const Text(
            'SAIR DA CONTA',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  void _confirmarLogout(BuildContext context, PerfilViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair da conta?'),
        content: const Text('Você precisará fazer login novamente para acessar seus dados.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCELAR'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await viewModel.logout();
              if (mounted) {
                // Navegar para tela de login/splash
                // O AuthWrapper no main deve lidar com isso, mas podemos forçar
                // Navigator.of(context).pushReplacementNamed('/login'); 
                // Assumindo que o stream de auth vai redirecionar
              }
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('SAIR'),
          ),
        ],
      ),
    );
  }
}
