import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../viewmodels/perfil_viewmodel.dart';

class DadosPessoaisSection extends StatelessWidget {
  const DadosPessoaisSection({super.key});

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
            '👤 Dados Pessoais',
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
                _buildItem(
                  context,
                  'Nome',
                  usuario.nome ?? 'Não informado',
                  onTap: () => _editarNome(context, viewModel),
                ),
                const Divider(height: 1),
                _buildItem(
                  context,
                  'Email',
                  usuario.email ?? 'Não informado',
                  onTap: () => _editarEmail(context, viewModel),
                ),
                const Divider(height: 1),
                _buildItem(
                  context,
                  'Peso Corporal Atual',
                  usuario.pesoAtual != null ? '${usuario.pesoAtual} kg' : 'Não informado',
                  onTap: () => _editarPeso(context, viewModel),
                ),
                const Divider(height: 1),
                _buildItem(
                  context,
                  'Data de Nascimento',
                  usuario.dataNascimento != null 
                      ? DateFormat('dd/MM/yyyy').format(usuario.dataNascimento!)
                      : 'Não informado',
                  onTap: () => _editarDataNascimento(context, viewModel),
                ),
                const Divider(height: 1),
                _buildItem(
                  context,
                  'Objetivo',
                  _formatarObjetivo(usuario.objetivo),
                  onTap: () => _editarObjetivo(context, viewModel),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, String label, String value, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  String _formatarObjetivo(String? objetivo) {
    switch (objetivo) {
      case 'massa': return 'Ganho de massa muscular';
      case 'perda_peso': return 'Perda de peso';
      case 'manutencao': return 'Manutenção';
      case 'forca': return 'Força e performance';
      case 'saude': return 'Saúde geral';
      default: return 'Não informado';
    }
  }

  void _editarNome(BuildContext context, PerfilViewModel viewModel) {
    final controller = TextEditingController(text: viewModel.usuario?.nome);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Nome'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Nome Completo'),
          textCapitalization: TextCapitalization.words,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              viewModel.atualizarNome(controller.text);
              Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _editarEmail(BuildContext context, PerfilViewModel viewModel) {
    final controller = TextEditingController(text: viewModel.usuario?.email);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Email'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Email'),
          keyboardType: TextInputType.emailAddress,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              viewModel.atualizarEmail(controller.text);
              Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _editarPeso(BuildContext context, PerfilViewModel viewModel) {
    final controller = TextEditingController(text: viewModel.usuario?.pesoAtual?.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Peso'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Peso (kg)', suffixText: 'kg'),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              final peso = double.tryParse(controller.text.replaceAll(',', '.'));
              if (peso != null) {
                viewModel.atualizarPeso(peso);
              }
              Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _editarDataNascimento(BuildContext context, PerfilViewModel viewModel) async {
    final data = await showDatePicker(
      context: context,
      initialDate: viewModel.usuario?.dataNascimento ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (data != null) {
      viewModel.atualizarDataNascimento(data);
    }
  }

  void _editarObjetivo(BuildContext context, PerfilViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Selecione seu Objetivo'),
        children: [
          _buildObjetivoOption(context, viewModel, 'massa', 'Ganho de massa muscular'),
          _buildObjetivoOption(context, viewModel, 'perda_peso', 'Perda de peso'),
          _buildObjetivoOption(context, viewModel, 'manutencao', 'Manutenção'),
          _buildObjetivoOption(context, viewModel, 'forca', 'Força e performance'),
          _buildObjetivoOption(context, viewModel, 'saude', 'Saúde geral'),
        ],
      ),
    );
  }

  Widget _buildObjetivoOption(BuildContext context, PerfilViewModel viewModel, String value, String label) {
    return SimpleDialogOption(
      onPressed: () {
        viewModel.atualizarObjetivo(value);
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(label),
      ),
    );
  }
}
