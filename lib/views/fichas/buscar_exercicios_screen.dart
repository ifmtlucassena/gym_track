import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/exercicio_model.dart';
import '../../models/serie_model.dart';
import '../../services/exercicio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BuscarExerciciosScreen extends StatefulWidget {
  const BuscarExerciciosScreen({super.key});

  @override
  State<BuscarExerciciosScreen> createState() => _BuscarExerciciosScreenState();
}

class _BuscarExerciciosScreenState extends State<BuscarExerciciosScreen> {
  final ExercicioService _service = ExercicioService();
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  String? _filtroMusculo;
  String? _filtroEquipamento;

  List<ExercicioCatalogo> _exercicios = [];
  MetadadosExercicios? _metadados;
  bool _carregando = true;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    setState(() => _carregando = true);

    try {
      // Carrega metadados e exercícios em paralelo
      final results = await Future.wait([
        _service.buscarMetadados(),
        _service.buscarTodosExercicios(),
      ]);

      setState(() {
        _metadados = results[0] as MetadadosExercicios?;
        _exercicios = results[1] as List<ExercicioCatalogo>;
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

  Future<void> _aplicarFiltros() async {
    setState(() => _carregando = true);

    try {
      final exercicios = await _service.buscarExerciciosFiltrados(
        musculo: _filtroMusculo,
        equipamento: _filtroEquipamento,
        busca: _searchQuery.isNotEmpty ? _searchQuery : null,
      );

      setState(() {
        _exercicios = exercicios;
        _carregando = false;
      });
    } catch (e) {
      setState(() => _carregando = false);
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() => _searchQuery = query);
      _aplicarFiltros();
    });
  }

  void _onFiltroMusculoChanged(String? musculo) {
    setState(() => _filtroMusculo = musculo);
    _aplicarFiltros();
  }

  void _onFiltroEquipamentoChanged(String? equipamento) {
    setState(() => _filtroEquipamento = equipamento);
    _aplicarFiltros();
  }

  List<String> get _musculosFormatados {
    if (_metadados == null) return ['Todos'];
    return [
      'Todos',
      ..._metadados!.musculos.map((m) => _formatarNome(m)).toList(),
    ];
  }

  List<String> get _equipamentosFormatados {
    if (_metadados == null) return ['Todos'];
    return [
      'Todos',
      ..._metadados!.equipamentos.map((e) => _formatarNome(e)).toList(),
    ];
  }

  String _formatarNome(String nome) {
    return nome
        .split('-')
        .map((palavra) => palavra[0].toUpperCase() + palavra.substring(1))
        .join(' ');
  }

  String _reverterFormatacao(String nomeFormatado) {
    return nomeFormatado.toLowerCase().replaceAll(' ', '-');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      resizeToAvoidBottomInset: true,
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
                          _onSearchChanged('');
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
              onChanged: _onSearchChanged,
            ),
          ),

          // Filtros
          if (!_carregando || _metadados != null)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filtro de músculos
                  Text(
                    'Músculos',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _musculosFormatados.map((musculo) {
                        final isSelected = (musculo == 'Todos' && _filtroMusculo == null) ||
                            (_filtroMusculo != null && _formatarNome(_filtroMusculo!) == musculo);

                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(musculo),
                            selected: isSelected,
                            onSelected: (_) {
                              final filtro = musculo == 'Todos' ? null : _reverterFormatacao(musculo);
                              _onFiltroMusculoChanged(filtro);
                            },
                            backgroundColor: Colors.grey.shade100,
                            selectedColor: const Color(0xFF3B82F6),
                            labelStyle: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white : const Color(0xFF1E293B),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Filtro de equipamentos
                  Text(
                    'Equipamentos',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _equipamentosFormatados.map((equipamento) {
                        final isSelected = (equipamento == 'Todos' && _filtroEquipamento == null) ||
                            (_filtroEquipamento != null && _formatarNome(_filtroEquipamento!) == equipamento);

                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(equipamento),
                            selected: isSelected,
                            onSelected: (_) {
                              final filtro = equipamento == 'Todos' ? null : _reverterFormatacao(equipamento);
                              _onFiltroEquipamentoChanged(filtro);
                            },
                            backgroundColor: Colors.grey.shade100,
                            selectedColor: const Color(0xFF10B981),
                            labelStyle: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white : const Color(0xFF1E293B),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

          const Divider(height: 1),

          // Lista de exercícios
          Expanded(
            child: _carregando
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(
                          'Carregando exercícios...',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                : _exercicios.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: _exercicios.length,
                        itemBuilder: (context, index) {
                          final exercicio = _exercicios[index];
                          return _buildExercicioCard(exercicio);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.search_off,
                size: 48,
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: 12),
              Text(
                'Nenhum exercício encontrado',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                'Tente ajustar os filtros ou a busca',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExercicioCard(ExercicioCatalogo exercicio) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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
        child: InkWell(
          onTap: () => _mostrarDetalhesExercicio(exercicio),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Imagem do exercício
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: exercicio.imagens.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: exercicio.imagens.first,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            width: 70,
                            height: 70,
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: const Color(0xFF3B82F6).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.fitness_center,
                              color: Color(0xFF3B82F6),
                              size: 32,
                            ),
                          ),
                        )
                      : Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: const Color(0xFF3B82F6).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.fitness_center,
                            color: Color(0xFF3B82F6),
                            size: 32,
                          ),
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
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          if (exercicio.primeiroMusculo.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF3B82F6).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                exercicio.primeiroMusculo,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF3B82F6),
                                ),
                              ),
                            ),
                          if (exercicio.equipamento != null)
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
                                exercicio.equipamentoFormatado,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Botão adicionar rápido
                IconButton(
                  onPressed: () => _configurarExercicio(exercicio),
                  icon: const Icon(Icons.add_circle),
                  color: const Color(0xFF3B82F6),
                  iconSize: 32,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _mostrarDetalhesExercicio(ExercicioCatalogo exercicio) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _DetalhesExercicioModal(
        exercicio: exercicio,
        onAdicionar: () {
          Navigator.pop(context);
          _configurarExercicio(exercicio);
        },
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
                grupo_muscular: exercicio.primeiroMusculo,
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
    _debounce?.cancel();
    super.dispose();
  }
}

// Widget do modal de detalhes
class _DetalhesExercicioModal extends StatefulWidget {
  final ExercicioCatalogo exercicio;
  final VoidCallback onAdicionar;

  const _DetalhesExercicioModal({
    required this.exercicio,
    required this.onAdicionar,
  });

  @override
  State<_DetalhesExercicioModal> createState() => _DetalhesExercicioModalState();
}

class _DetalhesExercicioModalState extends State<_DetalhesExercicioModal> {
  int _imagemAtualIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Alterna entre as imagens a cada 2 segundos
    if (widget.exercicio.imagens.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
        setState(() {
          _imagemAtualIndex = (_imagemAtualIndex + 1) % widget.exercicio.imagens.length;
        });
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle do modal
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Conteúdo
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(0),
                  children: [
                    // Imagens alternando (efeito GIF)
                    if (widget.exercicio.imagens.isNotEmpty)
                      Container(
                        height: 250,
                        color: Colors.grey.shade100,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CachedNetworkImage(
                              imageUrl: widget.exercicio.imagens[_imagemAtualIndex],
                              width: double.infinity,
                              height: 250,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: const Color(0xFF3B82F6).withOpacity(0.1),
                                child: const Icon(
                                  Icons.fitness_center,
                                  size: 64,
                                  color: Color(0xFF3B82F6),
                                ),
                              ),
                            ),
                            // Indicadores de imagem
                            if (widget.exercicio.imagens.length > 1)
                              Positioned(
                                bottom: 12,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    widget.exercicio.imagens.length.clamp(0, 2),
                                    (index) => Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 4),
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _imagemAtualIndex == index
                                            ? Colors.white
                                            : Colors.white.withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                    // Informações do exercício
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Nome
                          Text(
                            widget.exercicio.nome,
                            style: GoogleFonts.inter(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Tags
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              if (widget.exercicio.primeiroMusculo.isNotEmpty)
                                _buildTag(
                                  widget.exercicio.primeiroMusculo,
                                  const Color(0xFF3B82F6),
                                  Icons.fitness_center,
                                ),
                              if (widget.exercicio.equipamento != null)
                                _buildTag(
                                  widget.exercicio.equipamentoFormatado,
                                  const Color(0xFF10B981),
                                  Icons.sports_gymnastics,
                                ),
                              if (widget.exercicio.nivel != null)
                                _buildTag(
                                  widget.exercicio.nivel!.toUpperCase(),
                                  const Color(0xFFF59E0B),
                                  Icons.signal_cellular_alt,
                                ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Instruções
                          if (widget.exercicio.instrucoes.isNotEmpty) ...[
                            Text(
                              'Como Executar',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...widget.exercicio.instrucoes.asMap().entries.map(
                                  (entry) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF3B82F6),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${entry.key + 1}',
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            entry.value,
                                            style: GoogleFonts.inter(
                                              fontSize: 14,
                                              color: Colors.grey.shade700,
                                              height: 1.5,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            const SizedBox(height: 12),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Botão adicionar
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: ElevatedButton.icon(
                    onPressed: widget.onAdicionar,
                    icon: const Icon(Icons.add),
                    label: Text(
                      'Adicionar Exercício',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(double.infinity, 0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTag(String label, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
