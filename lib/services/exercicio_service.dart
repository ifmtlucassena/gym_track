import 'package:cloud_firestore/cloud_firestore.dart';

class MetadadosExercicios {
  final List<String> musculos;
  final List<String> equipamentos;
  final List<String> categorias;
  final List<String> niveis;
  final List<String> forcas;
  final int totalExercicios;

  MetadadosExercicios({
    required this.musculos,
    required this.equipamentos,
    required this.categorias,
    required this.niveis,
    required this.forcas,
    required this.totalExercicios,
  });

  factory MetadadosExercicios.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MetadadosExercicios(
      musculos: List<String>.from(data['musculos'] ?? []),
      equipamentos: List<String>.from(data['equipamentos'] ?? []),
      categorias: List<String>.from(data['categorias'] ?? []),
      niveis: List<String>.from(data['niveis'] ?? []),
      forcas: List<String>.from(data['forcas'] ?? []),
      totalExercicios: data['total_exercicios'] ?? 0,
    );
  }
}

class ExercicioCatalogo {
  final String id;
  final String nome;
  final List<String> imagens;
  final List<String> instrucoes;
  final List<String> musculosPrimarios;
  final List<String> musculosSecundarios;
  final String? equipamento;
  final String? nivel;
  final String? categoria;
  final String? forca;
  final String? mecanica;

  ExercicioCatalogo({
    required this.id,
    required this.nome,
    required this.imagens,
    required this.instrucoes,
    required this.musculosPrimarios,
    required this.musculosSecundarios,
    this.equipamento,
    this.nivel,
    this.categoria,
    this.forca,
    this.mecanica,
  });

  factory ExercicioCatalogo.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ExercicioCatalogo(
      id: doc.id,
      nome: data['nome'] ?? '',
      imagens: List<String>.from(data['imagens'] ?? []),
      instrucoes: List<String>.from(data['instrucoes'] ?? []),
      musculosPrimarios: List<String>.from(data['musculos_primarios'] ?? []),
      musculosSecundarios: List<String>.from(data['musculos_secundarios'] ?? []),
      equipamento: data['equipamento'],
      nivel: data['nivel'],
      categoria: data['categoria'],
      forca: data['forca'],
      mecanica: data['mecanica'],
    );
  }

  String get primeiroMusculo {
    if (musculosPrimarios.isEmpty) return '';
    return _formatarNomeMusculo(musculosPrimarios.first);
  }

  String _formatarNomeMusculo(String musculo) {
    // Converte "inferior-das-costas" para "Inferior das Costas"
    return musculo
        .split('-')
        .map((palavra) => palavra[0].toUpperCase() + palavra.substring(1))
        .join(' ');
  }

  String get equipamentoFormatado {
    if (equipamento == null) return '';
    return _formatarNomeMusculo(equipamento!);
  }
}

class ExercicioService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Buscar metadados
  Future<MetadadosExercicios?> buscarMetadados() async {
    try {
      final doc = await _firestore
          .collection('metadados')
          .doc('exercicios')
          .get();

      if (doc.exists) {
        return MetadadosExercicios.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Erro ao buscar metadados: $e');
      return null;
    }
  }

  // Buscar todos os exercícios
  Future<List<ExercicioCatalogo>> buscarTodosExercicios() async {
    try {
      final snapshot = await _firestore
          .collection('exercicios')
          .orderBy('nome')
          .get();

      return snapshot.docs
          .map((doc) => ExercicioCatalogo.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Erro ao buscar exercícios: $e');
      return [];
    }
  }

  // Buscar exercícios com filtros
  Future<List<ExercicioCatalogo>> buscarExerciciosFiltrados({
    String? musculo,
    String? equipamento,
    String? categoria,
    String? nivel,
    String? busca,
  }) async {
    try {
      Query query = _firestore.collection('exercicios');

      // Aplicar filtros
      if (musculo != null && musculo.isNotEmpty) {
        query = query.where('musculos_primarios', arrayContains: musculo);
      }

      if (equipamento != null && equipamento.isNotEmpty) {
        query = query.where('equipamento', isEqualTo: equipamento);
      }

      if (categoria != null && categoria.isNotEmpty) {
        query = query.where('categoria', isEqualTo: categoria);
      }

      if (nivel != null && nivel.isNotEmpty) {
        query = query.where('nivel', isEqualTo: nivel);
      }

      query = query.orderBy('nome');

      final snapshot = await query.get();
      var exercicios = snapshot.docs
          .map((doc) => ExercicioCatalogo.fromFirestore(doc))
          .toList();

      // Filtro de busca por texto (feito localmente)
      if (busca != null && busca.isNotEmpty) {
        final buscaLower = busca.toLowerCase();
        exercicios = exercicios.where((ex) {
          return ex.nome.toLowerCase().contains(buscaLower) ||
              ex.musculosPrimarios.any((m) => m.contains(buscaLower)) ||
              (ex.equipamento?.toLowerCase().contains(buscaLower) ?? false);
        }).toList();
      }

      return exercicios;
    } catch (e) {
      print('Erro ao buscar exercícios filtrados: $e');
      return [];
    }
  }

  // Buscar exercício por ID
  Future<ExercicioCatalogo?> buscarExercicioPorId(String id) async {
    try {
      final doc = await _firestore.collection('exercicios').doc(id).get();

      if (doc.exists) {
        return ExercicioCatalogo.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Erro ao buscar exercício por ID: $e');
      return null;
    }
  }
}
