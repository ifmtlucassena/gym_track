import 'package:flutter/material.dart';
import '../models/ficha_model.dart';
import '../services/ficha_service.dart';
import '../data/templates/ficha_templates.dart';

enum EstadoFichas {
  carregando,
  sucesso,
  erro,
  vazio,
}

class FichaViewModel extends ChangeNotifier {
  final FichaService _fichaService = FichaService();

  EstadoFichas _estado = EstadoFichas.carregando;
  EstadoFichas get estado => _estado;

  List<FichaModel> _fichas = [];
  List<FichaModel> get fichas => _fichas;

  FichaModel? _fichaAtiva;
  FichaModel? get fichaAtiva => _fichaAtiva;

  List<FichaModel> get fichasAtivas =>
      _fichas.where((f) => f.ativa).toList();

  List<FichaModel> get fichasInativas =>
      _fichas.where((f) => !f.ativa).toList();

  String? _mensagemErro;
  String? get mensagemErro => _mensagemErro;

  bool _carregando = false;
  bool get carregando => _carregando;

  // CARREGAR FICHAS DO USUÁRIO
  Future<void> carregarFichas(String usuarioId) async {
    _setEstado(EstadoFichas.carregando);
    _mensagemErro = null;

    try {
      _fichas = await _fichaService.buscarFichasUsuario(usuarioId);
      _fichaAtiva = _fichas.where((f) => f.ativa).firstOrNull;

      if (_fichas.isEmpty) {
        _setEstado(EstadoFichas.vazio);
      } else {
        _setEstado(EstadoFichas.sucesso);
      }
    } catch (e) {
      _mensagemErro = 'Erro ao carregar fichas: ${e.toString()}';
      _setEstado(EstadoFichas.erro);
    }
  }

  // CRIAR FICHA A PARTIR DE TEMPLATE
  Future<bool> criarFichaDeTemplate({
    required String templateId,
    required String usuarioId,
  }) async {
    _setCarregando(true);
    _mensagemErro = null;

    try {
      final template = FichaTemplates.buscarPorId(templateId);
      if (template == null) {
        throw Exception('Template não encontrado');
      }

      // Desativa todas as fichas anteriores
      await _fichaService.desativarTodasFichas(usuarioId);

      // Cria a nova ficha baseada no template
      final novaFicha = FichaModel(
        id: '', // Será gerado pelo Firestore
        usuarioId: usuarioId,
        nome: template.nome,
        descricao: template.descricao,
        origem: 'template_${template.id}',
        diasTreino: template.diasTreino,
        ativa: true,
        dataCriacao: DateTime.now(),
        dataInicio: DateTime.now(),
      );

      await _fichaService.criarFicha(novaFicha);

      // Recarrega as fichas
      await carregarFichas(usuarioId);

      _setCarregando(false);
      return true;
    } catch (e) {
      _mensagemErro = 'Erro ao criar ficha: ${e.toString()}';
      _setCarregando(false);
      return false;
    }
  }

  // ATIVAR FICHA
  Future<bool> ativarFicha(String fichaId, String usuarioId) async {
    _setCarregando(true);
    _mensagemErro = null;

    try {
      await _fichaService.ativarFicha(fichaId, usuarioId);
      await carregarFichas(usuarioId);
      _setCarregando(false);
      return true;
    } catch (e) {
      _mensagemErro = 'Erro ao ativar ficha: ${e.toString()}';
      _setCarregando(false);
      return false;
    }
  }

  // DESATIVAR FICHA
  Future<bool> desativarFicha(String fichaId, String usuarioId) async {
    _setCarregando(true);
    _mensagemErro = null;

    try {
      await _fichaService.desativarFicha(fichaId);
      await carregarFichas(usuarioId);
      _setCarregando(false);
      return true;
    } catch (e) {
      _mensagemErro = 'Erro ao desativar ficha: ${e.toString()}';
      _setCarregando(false);
      return false;
    }
  }

  // EDITAR FICHA
  Future<bool> editarFicha(FichaModel ficha, String usuarioId) async {
    _setCarregando(true);
    _mensagemErro = null;

    try {
      await _fichaService.atualizarFicha(ficha);
      await carregarFichas(usuarioId);
      _setCarregando(false);
      return true;
    } catch (e) {
      _mensagemErro = 'Erro ao editar ficha: ${e.toString()}';
      _setCarregando(false);
      return false;
    }
  }

  // DELETAR FICHA
  Future<bool> deletarFicha(String fichaId, String usuarioId) async {
    _setCarregando(true);
    _mensagemErro = null;

    try {
      await _fichaService.deletarFicha(fichaId);
      await carregarFichas(usuarioId);
      _setCarregando(false);
      return true;
    } catch (e) {
      _mensagemErro = 'Erro ao deletar ficha: ${e.toString()}';
      _setCarregando(false);
      return false;
    }
  }

  // BUSCAR FICHA POR ID
  FichaModel? buscarFichaPorId(String fichaId) {
    try {
      return _fichas.firstWhere((f) => f.id == fichaId);
    } catch (e) {
      return null;
    }
  }

  // HELPERS
  void _setEstado(EstadoFichas novoEstado) {
    _estado = novoEstado;
    notifyListeners();
  }

  void _setCarregando(bool valor) {
    _carregando = valor;
    notifyListeners();
  }

  void limparErro() {
    _mensagemErro = null;
    notifyListeners();
  }
}
