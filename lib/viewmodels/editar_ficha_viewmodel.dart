import 'package:flutter/material.dart';
import 'package:gym_track/models/dia_treino_model.dart';
import 'package:gym_track/models/exercicio_model.dart';
import 'package:gym_track/models/ficha_model.dart';
import 'package:gym_track/services/ficha_service.dart';

class EditarFichaViewModel extends ChangeNotifier {
  final FichaService _fichaService = FichaService();
  late FichaModel _fichaOriginal;

  late String nomeFicha;
  late List<DiaTreinoModel> diasTreino;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  EditarFichaViewModel(FichaModel fichaParaEditar) {
    _fichaOriginal = fichaParaEditar;
    nomeFicha = fichaParaEditar.nome;
    // Cria uma cópia profunda para evitar modificar o original diretamente
    diasTreino = fichaParaEditar.diasTreino.map((dia) => dia.copyWith()).toList();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void adicionarExercicio(int diaIndex, ExercicioModel exercicio) {
    if (diaIndex < diasTreino.length) {
      diasTreino[diaIndex].exercicios.add(exercicio);
      notifyListeners();
    }
  }

  void removerExercicio(int diaIndex, int exercicioIndex) {
    if (diaIndex < diasTreino.length && exercicioIndex < diasTreino[diaIndex].exercicios.length) {
      diasTreino[diaIndex].exercicios.removeAt(exercicioIndex);
      notifyListeners();
    }
  }

  void reordenarExercicios(int diaIndex, int oldIndex, int newIndex) {
    if (diaIndex < diasTreino.length) {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = diasTreino[diaIndex].exercicios.removeAt(oldIndex);
      diasTreino[diaIndex].exercicios.insert(newIndex, item);
      notifyListeners();
    }
  }

  void atualizarNomeDia(int diaIndex, String novoNome) {
    if (diaIndex < diasTreino.length) {
      diasTreino[diaIndex] = diasTreino[diaIndex].copyWith(nome: novoNome);
      notifyListeners();
    }
  }

  Future<bool> salvarFicha() async {
    _setLoading(true);
    try {
      FichaModel fichaAtualizada = _fichaOriginal.copyWith(
        nome: nomeFicha,
        diasTreino: diasTreino,
      );
      await _fichaService.atualizarFicha(fichaAtualizada);
      return true;
    } catch (e) {
      print("Erro ao salvar ficha: $e");
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
