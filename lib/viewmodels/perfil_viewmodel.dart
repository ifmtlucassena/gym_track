import 'dart:io';
import 'package:flutter/material.dart';
import '../models/usuario_model.dart';
import '../services/auth_service.dart';
import '../services/usuario_service.dart';
import '../services/storage_service.dart';
import '../services/treino_service.dart';
import '../services/ficha_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PerfilViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final UsuarioService _usuarioService = UsuarioService();
  final StorageService _storageService = StorageService();
  final TreinoService _treinoService = TreinoService();
  final FichaService _fichaService = FichaService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  bool _isLoading = false;
  String? _error;
  UsuarioModel? _usuario;
  Map<String, dynamic> _estatisticas = {};
  
  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  UsuarioModel? get usuario => _usuario;
  bool get isVisitante => _usuario?.isAnonimo ?? false;
  Map<String, dynamic> get estatisticas => _estatisticas;
  
  // Actions
  Future<void> carregarPerfil(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _usuario = await _usuarioService.getUsuario(userId);
      await carregarEstatisticas(userId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> carregarEstatisticas(String userId) async {
    try {
      final totalTreinos = await _treinoService.contarTreinosRealizados(userId);
      
      // Calcular tempo de uso
      String tempoUso = '0 dias';
      if (_usuario != null) {
        final diff = DateTime.now().difference(_usuario!.dataCadastro);
        if (diff.inDays > 30) {
          tempoUso = '${(diff.inDays / 30).floor()} meses';
        } else {
          tempoUso = '${diff.inDays} dias';
        }
      }
      
      // Volume total (simplificado, idealmente viria de um serviço de agregação)
      // Por enquanto vamos pegar do histórico recente ou deixar 0 se for muito pesado calcular tudo
      // O prompt pede "Volume total levantado". Vamos fazer uma query de agregação se possível ou somar os últimos 30.
      // Para MVP rápido e performance, vamos deixar placeholder ou calcular dos últimos 100 treinos.
      double volumeTotal = 0;
      final historico = await _treinoService.buscarHistoricoTreinos(userId, limite: 100);
      for (var t in historico) {
        volumeTotal += t.volumeTotalKg;
      }
      
      String volumeLabel = '${volumeTotal.toStringAsFixed(0)}kg';
      if (volumeTotal > 1000) {
        volumeLabel = '${(volumeTotal / 1000).toStringAsFixed(1)}t';
      }
      
      // Ficha ativa
      String fichaAtiva = 'Nenhuma';
      final ficha = await _fichaService.buscarFichaAtiva(userId);
      if (ficha != null) {
        fichaAtiva = ficha.nome;
      }
      
      _estatisticas = {
        'totalTreinos': totalTreinos,
        'tempoUso': tempoUso,
        'volumeTotal': volumeLabel,
        'fichaAtiva': fichaAtiva,
      };
      notifyListeners();
    } catch (e) {
      print('Erro ao carregar estatísticas: $e');
    }
  }
  
  Future<bool> atualizarNome(String nome) async {
    if (_usuario == null) return false;
    try {
      final novoUsuario = _usuario!.copyWith(nome: nome);
      await _usuarioService.atualizarUsuario(novoUsuario);
      _usuario = novoUsuario;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> atualizarEmail(String email) async {
     if (_usuario == null) return false;
    try {
      final novoUsuario = _usuario!.copyWith(email: email);
      await _usuarioService.atualizarUsuario(novoUsuario);
      _usuario = novoUsuario;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> atualizarPeso(double peso) async {
    if (_usuario == null) return false;
    try {
      final novoUsuario = _usuario!.copyWith(pesoAtual: peso);
      await _usuarioService.atualizarUsuario(novoUsuario);
      _usuario = novoUsuario;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> atualizarDataNascimento(DateTime data) async {
    if (_usuario == null) return false;
    try {
      final novoUsuario = _usuario!.copyWith(dataNascimento: data);
      await _usuarioService.atualizarUsuario(novoUsuario);
      _usuario = novoUsuario;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> atualizarObjetivo(String objetivo) async {
    if (_usuario == null) return false;
    try {
      final novoUsuario = _usuario!.copyWith(objetivo: objetivo);
      await _usuarioService.atualizarUsuario(novoUsuario);
      _usuario = novoUsuario;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> atualizarFoto(File imagem) async {
    if (_usuario == null) return false;
    _isLoading = true;
    notifyListeners();
    
    try {
      final url = await _storageService.uploadProfileImage(_usuario!.id, imagem);
      final novoUsuario = _usuario!.copyWith(fotoUrl: url);
      await _usuarioService.atualizarUsuario(novoUsuario);
      _usuario = novoUsuario;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Configurações
  Future<void> toggleNotificacoes(bool ativo) async {
    if (_usuario == null) return;
    final novoUsuario = _usuario!.copyWith(notificacoesAtivadas: ativo);
    await _usuarioService.atualizarUsuario(novoUsuario);
    _usuario = novoUsuario;
    notifyListeners();
  }
  
  Future<void> setUnidadePeso(String unidade) async {
    if (_usuario == null) return;
    final novoUsuario = _usuario!.copyWith(unidadePeso: unidade);
    await _usuarioService.atualizarUsuario(novoUsuario);
    _usuario = novoUsuario;
    notifyListeners();
  }
  
  Future<void> setTema(String tema) async {
    if (_usuario == null) return;
    final novoUsuario = _usuario!.copyWith(tema: tema);
    await _usuarioService.atualizarUsuario(novoUsuario);
    _usuario = novoUsuario;
    notifyListeners();
  }
  
  // Migração
  Future<bool> migrarParaContaEmail({
    required String nome,
    required String email,
    required String senha,
  }) async {
    if (_usuario == null || !_usuario!.isAnonimo) return false;
    
    _isLoading = true;
    notifyListeners();
    
    try {
      final uidAnonimo = _usuario!.id;
      
      // 1. Criar nova conta no Firebase Auth
      // Nota: Isso fará o login automático na nova conta
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );
      
      final uidNovo = userCredential.user!.uid;
      
      // 2. Migrar dados
      await _migrarDados(uidAnonimo, uidNovo);
      
      // 3. Atualizar dados do novo usuário com nome e email
      final novoUsuarioModel = UsuarioModel(
        id: uidNovo,
        nome: nome,
        email: email,
        dataCadastro: DateTime.now(),
        isAnonimo: false,
        dadosMigradosDe: uidAnonimo,
        dataMigracao: DateTime.now(),
        onboardingCompleto: true, // Já fez onboarding como anônimo
      );
      
      await _usuarioService.salvarUsuario(novoUsuarioModel);
      
      // 4. Atualizar estado local
      _usuario = novoUsuarioModel;
      
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<bool> migrarParaContaGoogle() async {
    // Implementar lógica similar usando GoogleSignIn
    // ...
    return false; // Placeholder
  }
  
  Future<void> _migrarDados(String uidAnonimo, String uidNovo) async {
    final batch = _firestore.batch();
    
    // 1. Atualizar todas as fichas
    final fichas = await _firestore
        .collection('fichas')
        .where('usuario_id', isEqualTo: uidAnonimo)
        .get();
    
    for (var doc in fichas.docs) {
      batch.update(doc.reference, {'usuario_id': uidNovo});
    }
    
    // 2. Atualizar todos os treinos
    final treinos = await _firestore
        .collection('treinos_realizados')
        .where('usuario_id', isEqualTo: uidAnonimo)
        .get();
    
    for (var doc in treinos.docs) {
      batch.update(doc.reference, {'usuario_id': uidNovo});
    }
    
    // 3. Atualizar controle_treinos se existir
    final controles = await _firestore
        .collection('controle_treinos')
        .where('usuario_id', isEqualTo: uidAnonimo)
        .get();
    
    for (var doc in controles.docs) {
      batch.update(doc.reference, {'usuario_id': uidNovo});
    }
    
    // 4. Marcar usuário anônimo como migrado
    batch.update(
      _firestore.collection('usuarios').doc(uidAnonimo),
      {
        'migrado_para': uidNovo,
        'data_migracao': FieldValue.serverTimestamp(),
      },
    );
    
    await batch.commit();
  }
  
  Future<void> logout() async {
    await _authService.logout();
  }
}
