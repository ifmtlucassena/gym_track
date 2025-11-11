import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/ficha_model.dart';
import '../models/dia_treino_model.dart';
import '../models/treino_model.dart';
import '../services/ficha_service.dart';
import '../services/treino_service.dart';

enum EstadoUsuario {
  semFicha,
  comFichaSemTreinos,
  ativo,
}

class HomeViewModel extends ChangeNotifier {
  final FichaService _fichaService = FichaService();
  final TreinoService _treinoService = TreinoService();

  bool _isLoading = true;
  String? _error;

  FichaModel? _fichaAtiva;
  DiaTreinoModel? _treinoHoje;
  TreinoRealizadoModel? _ultimoTreino;
  int _sequenciaDias = 0;
  String? _proximoTreino;
  String _fraseMotivacional = '';

  bool get isLoading => _isLoading;
  bool get hasError => _error != null;
  String? get error => _error;
  bool get hasFicha => _fichaAtiva != null;
  bool get hasHistorico => _ultimoTreino != null;

  FichaModel? get fichaAtiva => _fichaAtiva;
  DiaTreinoModel? get treinoHoje => _treinoHoje;
  TreinoRealizadoModel? get ultimoTreino => _ultimoTreino;
  int get sequenciaDias => _sequenciaDias;
  String? get proximoTreino => _proximoTreino;
  String get fraseMotivacional => _fraseMotivacional;

  EstadoUsuario get estadoUsuario {
    if (!hasFicha) return EstadoUsuario.semFicha;
    if (!hasHistorico) return EstadoUsuario.comFichaSemTreinos;
    return EstadoUsuario.ativo;
  }

  Future<void> carregarDados(String userId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _fraseMotivacional = _selecionarFraseMotivacional();

      _fichaAtiva = await _fichaService.buscarFichaAtiva(userId);

      if (_fichaAtiva != null) {
        _treinoHoje = _calcularTreinoHoje(_fichaAtiva!);
        _proximoTreino = _calcularProximoTreino(_fichaAtiva!);
      }

      _ultimoTreino = await _treinoService.buscarUltimoTreino(userId);

      if (_ultimoTreino != null) {
        final historico = await _treinoService.buscarHistoricoTreinos(userId, limite: 30);
        _sequenciaDias = _calcularSequencia(historico);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (!e.toString().contains('failed-precondition') && 
          !e.toString().contains('index')) {
        _error = 'Erro ao carregar dados. Tente novamente.';
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh(String userId) async {
    await carregarDados(userId);
  }

  String _selecionarFraseMotivacional() {
    final frases = [
      'Força e foco! Hoje é dia de vencer',
      'Cada rep te deixa mais forte!',
      'Seu único limite é você mesmo',
      'Transforme suor em conquistas',
      'O corpo alcança o que a mente acredita',
      'Consistência é a chave do sucesso',
      'Hoje é o dia perfeito para começar',
      'Não desista, você está progredindo!',
      'A dor de hoje é a força de amanhã',
      'Supere seus limites, sempre!',
    ];

    final index = DateTime.now().day % frases.length;
    return frases[index];
  }

  DiaTreinoModel? _calcularTreinoHoje(FichaModel ficha) {
    if (ficha.diasTreino.isEmpty) return null;

    final diaSemanaAtual = DateTime.now().weekday;

    for (var dia in ficha.diasTreino) {
      if (dia.diaSemana == diaSemanaAtual) {
        return dia;
      }
    }

    return ficha.diasTreino.first;
  }

  String _calcularProximoTreino(FichaModel ficha) {
    if (ficha.diasTreino.isEmpty) return 'Nenhum treino cadastrado';

    final diaSemanaAtual = DateTime.now().weekday;
    final diasOrdenados = [...ficha.diasTreino]..sort((a, b) => a.diaSemana.compareTo(b.diaSemana));

    for (var dia in diasOrdenados) {
      if (dia.diaSemana > diaSemanaAtual) {
        return _formatarDiaSemana(dia.diaSemana);
      }
    }

    return _formatarDiaSemana(diasOrdenados.first.diaSemana);
  }

  String _formatarDiaSemana(int diaSemana) {
    final hoje = DateTime.now().weekday;
    final amanha = hoje == 7 ? 1 : hoje + 1;

    if (diaSemana == hoje) return 'Hoje';
    if (diaSemana == amanha) return 'Amanhã';

    const diasSemana = {
      1: 'Segunda',
      2: 'Terça',
      3: 'Quarta',
      4: 'Quinta',
      5: 'Sexta',
      6: 'Sábado',
      7: 'Domingo',
    };

    return diasSemana[diaSemana] ?? '';
  }

  int _calcularSequencia(List<TreinoRealizadoModel> treinos) {
    if (treinos.isEmpty) return 0;

    int sequencia = 0;
    DateTime dataAtual = DateTime.now();

    for (var treino in treinos) {
      final diferenca = dataAtual.difference(treino.dataFim).inDays;

      if (diferenca <= 1) {
        sequencia++;
        dataAtual = treino.dataFim;
      } else {
        break;
      }
    }

    return sequencia;
  }

  String calcularTempoRelativo(DateTime data) {
    final agora = DateTime.now();
    final diferenca = agora.difference(data);

    if (diferenca.inDays == 0) return 'Hoje';
    if (diferenca.inDays == 1) return 'Ontem';
    if (diferenca.inDays < 7) return 'Há ${diferenca.inDays} dias';
    return DateFormat('dd/MM').format(data);
  }

  String formatarDuracao(int minutos) {
    if (minutos < 60) return '$minutos min';
    final horas = minutos ~/ 60;
    final mins = minutos % 60;
    if (mins == 0) return '$horas h';
    return '$horas h $mins min';
  }
}
