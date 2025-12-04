import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../viewmodels/perfil_viewmodel.dart';

class MigracaoModal extends StatefulWidget {
  const MigracaoModal({super.key});

  @override
  State<MigracaoModal> createState() => _MigracaoModalState();
}

class _MigracaoModalState extends State<MigracaoModal> {
  bool _showEmailForm = false;
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  bool _aceitoTermos = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PerfilViewModel>();

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        top: 20,
        left: 20,
        right: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _showEmailForm ? 'Criar Conta com Email' : 'Criar Conta Permanente',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (viewModel.isLoading)
            const Center(
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Migrando seus dados... Por favor, aguarde.'),
                ],
              ),
            )
          else if (_showEmailForm)
            _buildEmailForm(viewModel)
          else
            _buildOptions(viewModel),
        ],
      ),
    );
  }

  Widget _buildOptions(PerfilViewModel viewModel) {
    return Column(
      children: [
        const Text(
          'Escolha como deseja criar sua conta. Seus dados atuais (fichas e treinos) serão mantidos.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _showEmailForm = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.email_outlined),
            label: const Text('Continuar com Email'),
          ),
        ),

        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.warning.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.warning.withOpacity(0.3)),
          ),
          child: const Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.warning),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Importante: Seus dados serão migrados automaticamente para a nova conta.',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmailForm(PerfilViewModel viewModel) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nomeController,
            decoration: const InputDecoration(
              labelText: 'Nome Completo',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person_outline),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Informe seu nome';
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email_outlined),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Informe seu email';
              if (!value.contains('@')) return 'Email inválido';
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _senhaController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Senha',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock_outline),
            ),
            validator: (value) {
              if (value == null || value.length < 6) return 'Mínimo 6 caracteres';
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _confirmarSenhaController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Confirmar Senha',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock_outline),
            ),
            validator: (value) {
              if (value != _senhaController.text) return 'Senhas não conferem';
              return null;
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Checkbox(
                value: _aceitoTermos,
                onChanged: (value) {
                  setState(() {
                    _aceitoTermos = value ?? false;
                  });
                },
              ),
              const Expanded(
                child: Text('Aceito os termos de uso e política de privacidade'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _aceitoTermos
                  ? () async {
                      if (_formKey.currentState!.validate()) {
                        final success = await viewModel.migrarParaContaEmail(
                          nome: _nomeController.text,
                          email: _emailController.text,
                          senha: _senhaController.text,
                        );
                        
                        if (mounted) {
                          if (success) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Conta criada e dados migrados com sucesso!'),
                                backgroundColor: AppColors.success,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(viewModel.error ?? 'Erro ao migrar'),
                                backgroundColor: AppColors.error,
                              ),
                            );
                          }
                        }
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('CRIAR CONTA E MIGRAR DADOS'),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _showEmailForm = false;
              });
            },
            child: const Text('Voltar'),
          ),
        ],
      ),
    );
  }
}
