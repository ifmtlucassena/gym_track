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
    if (e.toString().contains('user-not-found')) {
      return 'Usuário não encontrado';
    } else if (e.toString().contains('wrong-password')) {
      return 'Senha incorreta';
    } else if (e.toString().contains('email-already-in-use')) {
      return 'Email já está em uso';
    } else if (e.toString().contains('weak-password')) {
      return 'Senha muito fraca (mínimo 6 caracteres)';
    } else if (e.toString().contains('invalid-email')) {
      return 'Email inválido';
    }
    return 'Erro ao autenticar: ${e.toString()}';
  }
}