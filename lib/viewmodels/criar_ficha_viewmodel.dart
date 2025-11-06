import 'package:flutter/material.dart';
import '../models/dia_treino_model.dart';
import '../models/exercicio_model.dart';
import '../models/ficha_model.dart';
import '../services/ficha_service.dart';

enum PassoWizard {
  selecionarDias, // Passo 1: Escolher quantos dias de treino
  nomearDias, // Passo 2: Nomear cada dia de treino
  adicionarExercicios, // Passo 3: Adicionar exercícios em cada dia
}

class CriarFichaViewModel extends ChangeNotifier {
  final FichaService _fichaService = FichaService();

  // Estado do wizard
  PassoWizard _passoAtual = PassoWizard.selecionarDias;
  PassoWizard get passoAtual => _passoAtual;

  bool _carregando = false;
  bool get carregando => _carregando;

  String? _mensagemErro;
  String? get mensagemErro => _mensagemErro;

  // PASSO 1: Seleção de dias
  final List<bool> _diasSelecionados = List.filled(7, false);
  List<bool> get diasSelecionados => _diasSelecionados;

  int get quantidadeDiasSelecionados =>
      _diasSelecionados.where((d) => d).length;

  // PASSO 2: Nomeação dos dias
  final List<DiaTreinoModel> _diasTreino = [];
  List<DiaTreinoModel> get diasTreino => _diasTreino;

  // PASSO 3: Dia atual sendo editado (para adicionar exercícios)
  int _diaAtualIndex = 0;
  int get diaAtualIndex => _diaAtualIndex;

  DiaTreinoModel? get diaAtual =>
      _diasTreino.isNotEmpty ? _diasTreino[_diaAtualIndex] : null;

  // Dados da ficha
  String _nomeFicha = '';
  String get nomeFicha => _nomeFicha;

  String _descricaoFicha = '';
  String get descricaoFicha => _descricaoFicha;

  // MODO DE OPERAÇÃO (Criação vs Edição)
  bool _modoEdicao = false;
  bool get modoEdicao => _modoEdicao;
  String? _idFichaOriginal;

  // Inicializa o ViewModel com os dados de uma ficha para edição
  void inicializarComFicha(FichaModel ficha) {
    _modoEdicao = true;
    _idFichaOriginal = ficha.id;
    _nomeFicha = ficha.nome;
    _descricaoFicha = ficha.descricao ?? '';

    // Preenche os dias selecionados
    _diasSelecionados.fillRange(0, 7, false);
    for (var dia in ficha.diasTreino) {
      if (dia.diaSemana >= 0 && dia.diaSemana < 7) {
        _diasSelecionados[dia.diaSemana] = true;
      }
    }

    // Copia os dias de treino
    _diasTreino.clear();
    _diasTreino.addAll(ficha.diasTreino.map((d) => d.copyWith()).toList());

    // Inicia no passo de nomear os dias, já que a seleção já foi feita
    _passoAtual = PassoWizard.nomearDias;

    notifyListeners();
  }

  // MÉTODOS DO PASSO 1: SELECIONAR DIAS

  void toggleDia(int diaSemana) {
    if (diaSemana >= 0 && diaSemana < 7) {
      _diasSelecionados[diaSemana] = !_diasSelecionados[diaSemana];
      notifyListeners();
    }
  }

  bool podeContinuarPasso1() {
    return quantidadeDiasSelecionados > 0;
  }

  void avancarParaPasso2() {
    if (!podeContinuarPasso1()) {
      _mensagemErro = 'Selecione pelo menos um dia de treino';
      notifyListeners();
      return;
    }

    // Cria os dias de treino baseado na seleção
    _diasTreino.clear();
    int ordem = 0;

    for (int i = 0; i < _diasSelecionados.length; i++) {
      if (_diasSelecionados[i]) {
        _diasTreino.add(
          DiaTreinoModel(
            id: 'dia_$i',
            nome: _getNomeDiaSemana(i),
            descricao: '',
            diaSemana: i,
            ordem: ordem++,
            exercicios: [],
          ),
        );
      }
    }

    _passoAtual = PassoWizard.nomearDias;
    _mensagemErro = null;
    notifyListeners();
  }

  // MÉTODOS DO PASSO 2: NOMEAR DIAS

  void atualizarNomeDia(int index, String nome) {
    if (index >= 0 && index < _diasTreino.length) {
      _diasTreino[index] = _diasTreino[index].copyWith(nome: nome);
      notifyListeners();
    }
  }

  void atualizarDescricaoDia(int index, String descricao) {
    if (index >= 0 && index < _diasTreino.length) {
      _diasTreino[index] = _diasTreino[index].copyWith(descricao: descricao);
      notifyListeners();
    }
  }

  bool podeContinuarPasso2() {
    // Todos os dias devem ter nome
    return _diasTreino.every((dia) => dia.nome.trim().isNotEmpty);
  }

  void avancarParaPasso3() {
    if (!podeContinuarPasso2()) {
      _mensagemErro = 'Todos os dias devem ter um nome';
      notifyListeners();
      return;
    }

    _diaAtualIndex = 0;
    _passoAtual = PassoWizard.adicionarExercicios;
    _mensagemErro = null;
    notifyListeners();
  }

  // MÉTODOS DO PASSO 3: ADICIONAR EXERCÍCIOS

  void selecionarDia(int index) {
    if (index >= 0 && index < _diasTreino.length) {
      _diaAtualIndex = index;
      notifyListeners();
    }
  }

  void adicionarExercicio(ExercicioModel exercicio) {
    if (_diaAtualIndex >= 0 && _diaAtualIndex < _diasTreino.length) {
      final dia = _diasTreino[_diaAtualIndex];
      final novosExercicios = List<ExercicioModel>.from(dia.exercicios);
      
      // Atualiza a ordem do exercício
      final exercicioComOrdem = exercicio.copyWith(
        ordem: novosExercicios.length,
      );
      
      novosExercicios.add(exercicioComOrdem);
      
      _diasTreino[_diaAtualIndex] = dia.copyWith(exercicios: novosExercicios);
      notifyListeners();
    }
  }

  void removerExercicio(int indexExercicio) {
    if (_diaAtualIndex >= 0 && _diaAtualIndex < _diasTreino.length) {
      final dia = _diasTreino[_diaAtualIndex];
      final novosExercicios = List<ExercicioModel>.from(dia.exercicios);
      
      if (indexExercicio >= 0 && indexExercicio < novosExercicios.length) {
        novosExercicios.removeAt(indexExercicio);
        
        // Reordena os exercícios
        for (int i = 0; i < novosExercicios.length; i++) {
          novosExercicios[i] = novosExercicios[i].copyWith(ordem: i);
        }
        
        _diasTreino[_diaAtualIndex] = dia.copyWith(exercicios: novosExercicios);
        notifyListeners();
      }
    }
  }

  void reordenarExercicios(int oldIndex, int newIndex) {
    if (_diaAtualIndex >= 0 && _diaAtualIndex < _diasTreino.length) {
      final dia = _diasTreino[_diaAtualIndex];
      final novosExercicios = List<ExercicioModel>.from(dia.exercicios);

      // Validação de índices
      if (oldIndex < 0 ||
          oldIndex >= novosExercicios.length ||
          newIndex < 0 ||
          newIndex >= novosExercicios.length ||
          oldIndex == newIndex) {
        return;
      }

      final exercicio = novosExercicios.removeAt(oldIndex);
      novosExercicios.insert(newIndex, exercicio);

      // Atualiza as ordens
      for (int i = 0; i < novosExercicios.length; i++) {
        novosExercicios[i] = novosExercicios[i].copyWith(ordem: i);
      }

      _diasTreino[_diaAtualIndex] = dia.copyWith(exercicios: novosExercicios);
      notifyListeners();
    }
  }

  bool podeContinuarPasso3() {
    // Todos os dias devem ter pelo menos 1 exercício
    return _diasTreino.every((dia) => dia.exercicios.isNotEmpty);
  }

  // SALVAR FICHA

  void setNomeFicha(String nome) {
    _nomeFicha = nome;
    notifyListeners();
  }

  void setDescricaoFicha(String descricao) {
    _descricaoFicha = descricao;
    notifyListeners();
  }

  Future<bool> salvarFicha(String usuarioId) async {
    if (_modoEdicao) {
      return _atualizarFicha(usuarioId);
    } else {
      return _criarFicha(usuarioId);
    }
  }

  Future<bool> _criarFicha(String usuarioId) async {
    if (_nomeFicha.trim().isEmpty) {
      _mensagemErro = 'O nome da ficha é obrigatório';
      notifyListeners();
      return false;
    }

    if (!podeContinuarPasso3()) {
      _mensagemErro = 'Todos os dias devem ter pelo menos 1 exercício';
      notifyListeners();
      return false;
    }

    _setCarregando(true);
    _mensagemErro = null;

    try {
      // Desativa todas as fichas anteriores
      await _fichaService.desativarTodasFichas(usuarioId);

      // Cria a nova ficha
      final novaFicha = FichaModel(
        id: '', // Será gerado pelo Firestore
        usuarioId: usuarioId,
        nome: _nomeFicha,
        descricao: _descricaoFicha.isNotEmpty ? _descricaoFicha : null,
        origem: 'customizada',
        diasTreino: _diasTreino,
        ativa: true,
        dataCriacao: DateTime.now(),
        dataInicio: DateTime.now(),
      );

      await _fichaService.criarFicha(novaFicha);

      _setCarregando(false);
      return true;
    } catch (e) {
      _mensagemErro = 'Erro ao salvar ficha: ${e.toString()}';
      _setCarregando(false);
      return false;
    }
  }

  Future<bool> _atualizarFicha(String usuarioId) async {
    if (_idFichaOriginal == null) {
      _mensagemErro = 'ID da ficha original não encontrado para atualização.';
      notifyListeners();
      return false;
    }
    if (_nomeFicha.trim().isEmpty) {
      _mensagemErro = 'O nome da ficha é obrigatório';
      notifyListeners();
      return false;
    }
    if (!podeContinuarPasso3()) {
      _mensagemErro = 'Todos os dias devem ter pelo menos 1 exercício';
      notifyListeners();
      return false;
    }

    _setCarregando(true);
    _mensagemErro = null;

    try {
      final fichaAtualizada = FichaModel(
        id: _idFichaOriginal!,
        usuarioId: usuarioId,
        nome: _nomeFicha,
        descricao: _descricaoFicha.isNotEmpty ? _descricaoFicha : null,
        diasTreino: _diasTreino,
        // Mantém os outros campos do original que não são editados aqui
        origem: 'customizada', // Pode ser necessário buscar do original
        ativa: true, // Lógica de ativação é separada
        dataCriacao: DateTime.now(), // Manter a data original? Depende da regra.
      );

      await _fichaService.atualizarFicha(fichaAtualizada);

      _setCarregando(false);
      return true;
    } catch (e) {
      _mensagemErro = 'Erro ao atualizar ficha: ${e.toString()}';
      _setCarregando(false);
      return false;
    }
  }

  // NAVEGAÇÃO

  void voltarPasso() {
    switch (_passoAtual) {
      case PassoWizard.nomearDias:
        _passoAtual = PassoWizard.selecionarDias;
        break;
      case PassoWizard.adicionarExercicios:
        _passoAtual = PassoWizard.nomearDias;
        break;
      default:
        break;
    }
    _mensagemErro = null;
    notifyListeners();
  }

  // RESET

  void resetar() {
    _passoAtual = PassoWizard.selecionarDias;
    _diasSelecionados.fillRange(0, 7, false);
    _diasTreino.clear();
    _diaAtualIndex = 0;
    _nomeFicha = '';
    _descricaoFicha = '';
    _carregando = false;
    _mensagemErro = null;
    _modoEdicao = false;
    _idFichaOriginal = null;
    notifyListeners();
  }

  // HELPERS

  void _setCarregando(bool valor) {
    _carregando = valor;
    notifyListeners();
  }

  void limparErro() {
    _mensagemErro = null;
    notifyListeners();
  }

  String _getNomeDiaSemana(int dia) {
    const nomes = [
      'Segunda-feira',
      'Terça-feira',
      'Quarta-feira',
      'Quinta-feira',
      'Sexta-feira',
      'Sábado',
      'Domingo',
    ];
    return nomes[dia];
  }

  String getNomeDiaSemanaAbreviado(int dia) {
    const nomes = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];
    return nomes[dia];
  }

  int getProgressoPercentual() {
    switch (_passoAtual) {
      case PassoWizard.selecionarDias:
        return 33;
      case PassoWizard.nomearDias:
        return 66;
      case PassoWizard.adicionarExercicios:
        return 100;
    }
  }
}
