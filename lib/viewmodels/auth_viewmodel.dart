import 'package:flutter/material.dart';
import '../models/usuario_model.dart';
import '../services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _error;
  UsuarioModel? _usuario;

  bool get isLoading => _isLoading;
  String? get error => _error;
  UsuarioModel? get usuario => _usuario;
  bool get isLogado => _usuario != null;

  Future<bool> cadastrar(String email, String senha, String nome) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _usuario = await _authService.cadastrarComEmail(email, senha, nome);
      return true;
    } catch (e) {
      _error = _tratarErro(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String senha) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _usuario = await _authService.loginComEmail(email, senha);
      return true;
    } catch (e) {
      _error = _tratarErro(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> loginComGoogle() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _usuario = await _authService.loginComGoogle();
      return _usuario != null;
    } catch (e) {
      _error = _tratarErro(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> loginAnonimo() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _usuario = await _authService.loginAnonimo();
      return true;
    } catch (e) {
      _error = _tratarErro(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> verificarUsuarioLogado() async {
    final currentUser = _authService.currentUser;
    if (currentUser != null) {
      _usuario = await _authService.buscarUsuario(currentUser.uid);
      notifyListeners();
    }
  }

  Future<void> marcarOnboardingCompleto() async {
    if (_usuario == null) return;
    await _authService.marcarOnboardingCompleto(_usuario!.id);
    _usuario = _usuario!.copyWith(onboardingCompleto: true);
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.logout();
    _usuario = null;
    notifyListeners();
  }

  String _tratarErro(dynamic e) {
    final errorMessage = e.toString().toLowerCase();
    
    // Erros de credenciais
    if (errorMessage.contains('invalid-credential') || 
        errorMessage.contains('wrong-password') ||
        errorMessage.contains('user-not-found')) {
      return 'Email ou senha incorretos';
    }
    
    // Erros de cadastro
    if (errorMessage.contains('email-already-in-use')) {
      return 'Este email já está cadastrado';
    }
    
    if (errorMessage.contains('weak-password')) {
      return 'Senha muito fraca. Use no mínimo 6 caracteres';
    }
    
    if (errorMessage.contains('invalid-email')) {
      return 'Email inválido';
    }
    
    // Erros de rede
    if (errorMessage.contains('network-request-failed')) {
      return 'Sem conexão com a internet';
    }
    
    if (errorMessage.contains('too-many-requests')) {
      return 'Muitas tentativas. Tente novamente mais tarde';
    }
    
    // Erros do Google Sign In
    if (errorMessage.contains('account-exists-with-different-credential')) {
      return 'Já existe uma conta com este email';
    }
    
    if (errorMessage.contains('popup-closed-by-user')) {
      return 'Login cancelado';
    }
    
    // Erro genérico apenas se não for nenhum dos acima
    return 'Erro ao realizar operação. Tente novamente';
  }
}