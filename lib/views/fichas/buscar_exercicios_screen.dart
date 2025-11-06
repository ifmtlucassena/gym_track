import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/exercicio_model.dart';
import '../../models/serie_model.dart';

// Model temporário para exercícios do catálogo
class ExercicioCatalogo {
  final String id;
  final String nome;
  final String grupoMuscular;
  final String? equipamento;
  final String? descricao;

  ExercicioCatalogo({
    required this.id,
    required this.nome,
    required this.grupoMuscular,
    this.equipamento,
    this.descricao,
  });

  factory ExercicioCatalogo.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ExercicioCatalogo(
      id: doc.id,
      nome: data['nome'] ?? '',
      grupoMuscular: data['grupo_muscular'] ?? '',
      equipamento: data['equipamento'],
      descricao: data['descricao'],
    );
  }
}

class BuscarExerciciosScreen extends StatefulWidget {
  const BuscarExerciciosScreen({super.key});

  @override
  State<BuscarExerciciosScreen> createState() => _BuscarExerciciosScreenState();
}

class _BuscarExerciciosScreenState extends State<BuscarExerciciosScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _grupoSelecionado;
  List<ExercicioCatalogo> _exercicios = [];
  bool _carregando = true;

  final List<String> _gruposMusculares = [
    'Todos',
    'Peito',
    'Costas',
    'Ombros',
    'Bíceps',
    'Tríceps',
    'Pernas',
    'Abdômen',
  ];

  @override
  void initState() {
    super.initState();
    _carregarExercicios();
  }

  Future<void> _carregarExercicios() async {
    setState(() => _carregando = true);

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('exercicios')
          .orderBy('nome')
          .get();

      setState(() {
        _exercicios = snapshot.docs
            .map((doc) => ExercicioCatalogo.fromFirestore(doc))
            .toList();
        _carregando = false;
      });
    } catch (e) {
      setState(() => _carregando = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar exercícios: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  List<ExercicioCatalogo> get _exerciciosFiltrados {
    var filtrados = _exercicios;

    // Filtro por grupo muscular
    if (_grupoSelecionado != null && _grupoSelecionado != 'Todos') {
      filtrados = filtrados
          .where((ex) => ex.grupoMuscular == _grupoSelecionado)
          .toList();
    }

    // Filtro por busca
    if (_searchQuery.isNotEmpty) {
      filtrados = filtrados
          .where((ex) =>
              ex.nome.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              ex.grupoMuscular.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return filtrados;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Buscar Exercícios',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1E293B),
          ),
        ),
      ),
      body: Column(
        children: [
          // Barra de busca
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar exercícios...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              style: GoogleFonts.inter(),
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),

          // Filtro de grupos musculares
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _gruposMusculares.map((grupo) {
                  final isSelected = _grupoSelecionado == grupo ||
                      (_grupoSelecionado == null && grupo == 'Todos');

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(grupo),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() {
                          _grupoSelecionado = grupo == 'Todos' ? null : grupo;
                        });
                      },
                      backgroundColor: Colors.grey.shade100,
                      selectedColor: const Color(0xFF3B82F6),
                      labelStyle: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : const Color(0xFF1E293B),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const Divider(height: 1),

          // Lista de exercícios
          Expanded(
            child: _carregando
                ? const Center(child: CircularProgressIndicator())
                : _exerciciosFiltrados.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: _exerciciosFiltrados.length,
                        itemBuilder: (context, index) {
                          final exercicio = _exerciciosFiltrados[index];
                          return _buildExercicioCard(exercicio);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum exercício encontrado',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tente ajustar os filtros ou a busca',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExercicioCard(ExercicioCatalogo exercicio) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _configurarExercicio(exercicio),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Ícone
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.fitness_center,
                  color: Color(0xFF3B82F6),
                ),
              ),
              const SizedBox(width: 16),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercicio.nome,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            exercicio.grupoMuscular,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                        if (exercicio.equipamento != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              exercicio.equipamento!,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              // Botão adicionar
              Icon(
                Icons.add_circle_outline,
                color: const Color(0xFF3B82F6),
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _configurarExercicio(ExercicioCatalogo exercicio) {
    // Controllers para as séries
    final numSeriesController = TextEditingController(text: '3');
    final repeticoesController = TextEditingController(text: '12');
    final pesoController = TextEditingController(text: '0');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Configurar Exercício',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                exercicio.nome,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF3B82F6),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: numSeriesController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Número de Séries',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                style: GoogleFonts.inter(),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: repeticoesController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Repetições',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                style: GoogleFonts.inter(),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: pesoController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Peso (kg)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                style: GoogleFonts.inter(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: GoogleFonts.inter(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final numSeries = int.tryParse(numSeriesController.text) ?? 3;
              final repeticoes = int.tryParse(repeticoesController.text) ?? 12;
              final peso = double.tryParse(pesoController.text) ?? 0.0;

              // Criar séries
              final series = List.generate(
                numSeries,
                (index) => SerieModel(
                  numeroSerie: index + 1,
                  repeticoes: repeticoes,
                  peso: peso,
                ),
              );

              // Criar ExercicioModel para adicionar à ficha
              final exercicioParaFicha = ExercicioModel(
                id: 'ex_${DateTime.now().millisecondsSinceEpoch}',
                nome: exercicio.nome,
                grupo_muscular: exercicio.grupoMuscular,
                series: series,
              );

              Navigator.pop(context); // Fecha o diálogo
              Navigator.pop(context, exercicioParaFicha); // Volta com o exercício
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
            ),
            child: Text(
              'Adicionar',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
