import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../viewmodels/perfil_viewmodel.dart';

class ConfiguracoesSection extends StatelessWidget {
  const ConfiguracoesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PerfilViewModel>();
    final usuario = viewModel.usuario;

    if (usuario == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '⚙️ Configurações',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Notificações', style: TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: const Text('Lembretes de treino', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  secondary: const Icon(Icons.notifications_outlined, color: AppColors.primary),
                  value: usuario.notificacoesAtivadas,
                  activeColor: AppColors.primary,
                  onChanged: (value) => viewModel.toggleNotificacoes(value),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.scale_outlined, color: AppColors.primary),
                  title: const Text('Unidades', style: TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: Text(usuario.unidadePeso == 'kg' ? 'Quilogramas (kg)' : 'Libras (lb)', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  trailing: const Icon(Icons.chevron_right, size: 20),
                  onTap: () {
                    // Toggle unit
                    viewModel.setUnidadePeso(usuario.unidadePeso == 'kg' ? 'lb' : 'kg');
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.dark_mode_outlined, color: AppColors.primary),
                  title: const Text('Tema', style: TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: Text(_formatarTema(usuario.tema), style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  trailing: const Icon(Icons.chevron_right, size: 20),
                  onTap: () => _mostrarOpcoesTema(context, viewModel),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.lock_outline, color: AppColors.primary),
                  title: const Text('Privacidade', style: TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: const Text('Dados e segurança', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  trailing: const Icon(Icons.chevron_right, size: 20),
                  onTap: () {
                    // TODO: Navegar para tela de privacidade
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatarTema(String tema) {
    switch (tema) {
      case 'claro': return 'Claro';
      case 'escuro': return 'Escuro';
      default: return 'Sistema (automático)';
    }
  }

  void _mostrarOpcoesTema(BuildContext context, PerfilViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Escolher Tema'),
        children: [
          SimpleDialogOption(
            onPressed: () {
              viewModel.setTema('sistema');
              Navigator.pop(context);
            },
            child: const Padding(padding: EdgeInsets.all(8.0), child: Text('Sistema (automático)')),
          ),
          SimpleDialogOption(
            onPressed: () {
              viewModel.setTema('claro');
              Navigator.pop(context);
            },
            child: const Padding(padding: EdgeInsets.all(8.0), child: Text('Claro')),
          ),
          SimpleDialogOption(
            onPressed: () {
              viewModel.setTema('escuro');
              Navigator.pop(context);
            },
            child: const Padding(padding: EdgeInsets.all(8.0), child: Text('Escuro')),
          ),
        ],
      ),
    );
  }
}
