import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';
import 'onboarding_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _isLoginMode = true;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final authViewModel = context.read<AuthViewModel>();
    bool success;

    if (_isLoginMode) {
      success = await authViewModel.login(
        _emailController.text.trim(),
        _senhaController.text,
      );
    } else {
      success = await authViewModel.cadastrar(
        _emailController.text.trim(),
        _senhaController.text,
        _nomeController.text.trim(),
      );
    }

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authViewModel.error ?? 'Erro ao autenticar'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _loginAnonimo() async {
    final authViewModel = context.read<AuthViewModel>();
    final success = await authViewModel.loginAnonimo();

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                Text(
                  _isLoginMode ? 'Bem-vindo de volta' : 'Criar conta',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  _isLoginMode
                      ? 'Entre para continuar seu progresso'
                      : 'Comece sua jornada fitness',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                if (!_isLoginMode)
                  AppTextField(
                    label: 'Nome',
                    controller: _nomeController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Digite seu nome';
                      }
                      return null;
                    },
                  ),
                if (!_isLoginMode) const SizedBox(height: 16),
                AppTextField(
                  label: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Digite seu email';
                    }
                    if (!value.contains('@')) {
                      return 'Email inválido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Senha',
                  controller: _senhaController,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Digite sua senha';
                    }
                    if (value.length < 6) {
                      return 'Senha deve ter no mínimo 6 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Consumer<AuthViewModel>(
                  builder: (context, viewModel, _) {
                    return AppButton(
                      text: _isLoginMode ? 'ENTRAR' : 'CADASTRAR',
                      onPressed: _submitForm,
                      isLoading: viewModel.isLoading,
                    );
                  },
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLoginMode = !_isLoginMode;
                    });
                  },
                  child: Text(
                    _isLoginMode
                        ? 'Não tem conta? Cadastre-se'
                        : 'Já tem conta? Entre',
                    style: const TextStyle(color: AppColors.primary),
                  ),
                ),
                const SizedBox(height: 32),
                TextButton(
                  onPressed: _loginAnonimo,
                  child: const Text(
                    'Continuar como visitante',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}