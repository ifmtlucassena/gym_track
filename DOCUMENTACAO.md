# 📱 GymTrack - Documentação Técnica do Projeto

## 📋 Sumário
1. [Visão Geral](#visão-geral)
2. [Arquitetura do Projeto (MVVM)](#arquitetura-do-projeto-mvvm)
3. [Estrutura de Pastas](#estrutura-de-pastas)
4. [Tecnologias e Dependências](#tecnologias-e-dependências)
5. [Fluxo de Navegação](#fluxo-de-navegação)
6. [Detalhamento: Tela de Criação de Fichas (Wizard)](#detalhamento-tela-de-criação-de-fichas-wizard)
7. [Models (Modelos de Dados)](#models-modelos-de-dados)
8. [Services (Serviços)](#services-serviços)
9. [ViewModels (Gerenciamento de Estado)](#viewmodels-gerenciamento-de-estado)
10. [Componentes Reutilizáveis (Widgets)](#componentes-reutilizáveis-widgets)
11. [Integração com Firebase](#integração-com-firebase)
12. [Pontos Interessantes e Técnicas Utilizadas](#pontos-interessantes-e-técnicas-utilizadas)
13. [Possíveis Perguntas da Apresentação](#possíveis-perguntas-da-apresentação)

---

## 🎯 Visão Geral

O **GymTrack** é um aplicativo de acompanhamento de treinos de academia desenvolvido em **Flutter**. O app permite que usuários:

- Criem fichas de treino personalizadas
- Registrem treinos realizados
- Acompanhem sua evolução através de gráficos
- Gerenciem seu perfil e dados pessoais

### Características Principais:
- **Multiplataforma**: Funciona em Android, iOS e Web
- **Autenticação**: Login anônimo (visitante) ou com email/senha
- **Persistência**: Dados salvos no Firebase Firestore
- **Armazenamento**: Imagens de exercícios no Firebase Storage
- **Offline-first**: Estrutura preparada para funcionar offline

---

## 🏗️ Arquitetura do Projeto (MVVM)

O projeto utiliza a arquitetura **MVVM (Model-View-ViewModel)**, um padrão de projeto que separa a lógica de negócios da interface do usuário.

```
┌─────────────────────────────────────────────────────────────────┐
│                         ARQUITETURA MVVM                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   ┌──────────┐      ┌──────────────┐      ┌──────────────┐     │
│   │   VIEW   │◄────►│  VIEWMODEL   │◄────►│    MODEL     │     │
│   │ (Telas)  │      │  (Estado)    │      │   (Dados)    │     │
│   └──────────┘      └──────────────┘      └──────────────┘     │
│        │                   │                     │              │
│        │                   │                     │              │
│   Widgets Flutter    ChangeNotifier        Classes Dart        │
│   Stateless/Stateful    Provider           toMap/fromMap       │
│                                                                 │
│                          ┌──────────────┐                      │
│                          │   SERVICE    │                      │
│                          │  (Firebase)  │                      │
│                          └──────────────┘                      │
│                                │                               │
│                          Firebase/API                          │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Camadas da Arquitetura:

| Camada | Responsabilidade | Exemplo |
|--------|------------------|---------|
| **View** | Interface do usuário, widgets, telas | `perfil_screen.dart`, `criar_ficha_wizard_screen.dart` |
| **ViewModel** | Gerenciamento de estado, lógica de apresentação | `CriarFichaViewModel`, `AuthViewModel` |
| **Model** | Estrutura de dados, conversão JSON | `FichaModel`, `ExercicioModel` |
| **Service** | Comunicação com Firebase/APIs | `FichaService`, `AuthService` |

### Por que MVVM?

1. **Separação de Responsabilidades**: Cada camada tem uma função específica
2. **Testabilidade**: ViewModels podem ser testados independentemente
3. **Manutenibilidade**: Fácil de modificar uma camada sem afetar outras
4. **Reatividade**: Provider + ChangeNotifier atualiza a UI automaticamente

---

## 📁 Estrutura de Pastas

```
lib/
├── main.dart                    # Ponto de entrada da aplicação
├── firebase_options.dart        # Configurações do Firebase (gerado automaticamente)
│
├── core/                        # Configurações globais
│   ├── constants/               # Constantes (nomes de coleções Firebase, etc)
│   │   └── firebase_constants.dart
│   └── theme/                   # Tema e cores do app
│       ├── app_colors.dart      # Paleta de cores
│       └── app_theme.dart       # ThemeData do MaterialApp
│
├── models/                      # Modelos de dados
│   ├── usuario_model.dart       # Dados do usuário
│   ├── ficha_model.dart         # Ficha de treino
│   ├── dia_treino_model.dart    # Dia dentro da ficha
│   ├── exercicio_model.dart     # Exercício
│   ├── serie_model.dart         # Série de um exercício
│   ├── treino_model.dart        # Treino realizado
│   └── evolucao_models.dart     # Dados de evolução
│
├── services/                    # Comunicação com Firebase
│   ├── auth_service.dart        # Autenticação
│   ├── usuario_service.dart     # CRUD de usuários
│   ├── ficha_service.dart       # CRUD de fichas
│   ├── exercicio_service.dart   # Busca de exercícios
│   ├── treino_service.dart      # Registro de treinos
│   ├── evolucao_service.dart    # Dados de evolução
│   └── storage_service.dart     # Upload de imagens
│
├── viewmodels/                  # Gerenciamento de estado
│   ├── auth_viewmodel.dart      # Estado de autenticação
│   ├── home_viewmodel.dart      # Estado da home
│   ├── ficha_viewmodel.dart     # Lista de fichas
│   ├── criar_ficha_viewmodel.dart    # Wizard de criação
│   ├── editar_ficha_viewmodel.dart   # Edição de ficha
│   ├── executar_treino_viewmodel.dart # Execução de treino
│   ├── evolucao_viewmodel.dart  # Gráficos de evolução
│   ├── perfil_viewmodel.dart    # Dados do perfil
│   └── treino_viewmodel.dart    # Histórico de treinos
│
├── views/                       # Telas do app
│   ├── splash_screen.dart       # Tela inicial
│   ├── auth_screen.dart         # Login/Cadastro
│   ├── onboarding_screen.dart   # Primeira vez do usuário
│   │
│   ├── home/                    # Tela principal
│   │   └── home_screen.dart     # Container das abas
│   │
│   ├── fichas/                  # Módulo de fichas
│   │   ├── fichas_screen.dart   # Lista de fichas
│   │   ├── criar_ficha_screen.dart        # Escolha do tipo
│   │   ├── criar_ficha_wizard_screen.dart # Wizard manual
│   │   ├── escolher_ficha_pronta_screen.dart # Fichas prontas
│   │   ├── detalhe_ficha_screen.dart      # Visualização
│   │   ├── editar_ficha_wizard_screen.dart # Edição
│   │   ├── buscar_exercicios_screen.dart  # Catálogo
│   │   └── wizard_steps/        # Passos do wizard
│   │       ├── passo1_selecionar_dias.dart
│   │       ├── passo2_nomear_dias.dart
│   │       └── passo3_adicionar_exercicios.dart
│   │
│   ├── treino/                  # Módulo de treinos
│   │   └── registrar_treino_screen.dart
│   │
│   ├── evolucao/                # Módulo de evolução
│   │   └── evolucao_screen.dart
│   │
│   ├── perfil/                  # Módulo de perfil
│   │   ├── perfil_screen.dart
│   │   └── widgets/
│   │       ├── perfil_header.dart
│   │       ├── estatisticas_section.dart
│   │       ├── dados_pessoais_section.dart
│   │       ├── sobre_section.dart
│   │       └── migracao_modal.dart
│   │
│   └── auth/                    # Módulo de autenticação
│       └── (componentes de auth)
│
└── widgets/                     # Componentes reutilizáveis
    ├── bottom_nav_bar.dart      # Barra de navegação inferior
    ├── custom_app_bar.dart      # AppBar customizada
    ├── motivational_card.dart   # Card motivacional
    ├── workout_today_card.dart  # Card do treino do dia
    └── quick_stats_card.dart    # Card de estatísticas
```

---

## 🛠️ Tecnologias e Dependências

### Flutter SDK
- **Versão**: ^3.9.2
- **Linguagem**: Dart

### Dependências Principais

```yaml
dependencies:
  # Firebase Core (obrigatório)
  firebase_core: ^3.15.2
  
  # Autenticação Firebase
  firebase_auth: ^5.7.0
  
  # Banco de dados Firestore
  cloud_firestore: ^5.6.12
  
  # Armazenamento de arquivos
  firebase_storage: ^12.4.10
  
  # Gerenciamento de estado
  provider: ^6.1.2
  
  # Fontes personalizadas
  google_fonts: ^6.2.1
  
  # Formatação de datas
  intl: any
  
  # Cache de imagens
  cached_network_image: ^3.4.1
  
  # Gráficos
  fl_chart: ^1.1.1
  
  # Seleção de imagens
  image_picker: ^1.2.1
  
  # Informações do app
  package_info_plus: ^9.0.0
  
  # Abrir URLs externas
  url_launcher: ^6.3.2
  
  # Verificar conectividade
  connectivity_plus: ^6.1.5
```

### Por que essas tecnologias?

| Tecnologia | Motivo |
|------------|--------|
| **Provider** | Simples, oficial do Flutter, bom para projetos médios |
| **Firebase** | Backend completo sem servidor próprio (BaaS) |
| **Google Fonts** | Tipografia profissional (Inter) |
| **CachedNetworkImage** | Performance ao carregar imagens da internet |
| **fl_chart** | Gráficos bonitos e customizáveis |

---

## 🧭 Fluxo de Navegação

```
┌──────────────────────────────────────────────────────────────┐
│                        FLUXO DO APP                          │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  SplashScreen                                                │
│       │                                                      │
│       ▼                                                      │
│  ┌─────────────┐    Não logado    ┌─────────────────┐       │
│  │ Verifica    │─────────────────►│   AuthScreen    │       │
│  │ Auth State  │                  │ (Login/Cadastro)│       │
│  └─────────────┘                  └─────────────────┘       │
│       │                                  │                   │
│       │ Logado                          │ Login OK           │
│       ▼                                  ▼                   │
│  ┌─────────────────────────────────────────────────────┐    │
│  │                    HomeScreen                        │    │
│  │  ┌─────────────────────────────────────────────┐    │    │
│  │  │              BottomNavBar                    │    │    │
│  │  │  ┌───────┬───────┬───────┬───────┬───────┐  │    │    │
│  │  │  │Início │Fichas │Treinar│Evol.  │Perfil │  │    │    │
│  │  │  │  (0)  │  (1)  │  (2)  │  (3)  │  (4)  │  │    │    │
│  │  │  └───────┴───────┴───────┴───────┴───────┘  │    │    │
│  │  └─────────────────────────────────────────────┘    │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

### Abas do BottomNavBar:

| Índice | Aba | Tela | Descrição |
|--------|-----|------|-----------|
| 0 | Início | `InicioPage` | Dashboard com resumo e treino do dia |
| 1 | Fichas | `FichasScreen` | Lista de fichas de treino |
| 2 | Treinar | `RegistrarTreinoScreen` | Abre em nova tela (modal) |
| 3 | Evolução | `EvolucaoScreen` | Gráficos e estatísticas |
| 4 | Perfil | `PerfilScreen` | Dados do usuário e configurações |

---

## 🎨 Detalhamento: Tela de Criação de Fichas (Wizard)

Esta é uma das telas mais complexas do app. Implementa um **Wizard (assistente passo-a-passo)** para criar fichas de treino personalizadas.

### Arquivos Envolvidos:

```
views/fichas/
├── criar_ficha_screen.dart           # Tela de escolha (manual vs pronta)
├── criar_ficha_wizard_screen.dart    # Container do wizard
└── wizard_steps/
    ├── passo1_selecionar_dias.dart   # Passo 1: Escolher dias
    ├── passo2_nomear_dias.dart       # Passo 2: Nomear dias
    └── passo3_adicionar_exercicios.dart # Passo 3: Adicionar exercícios

viewmodels/
└── criar_ficha_viewmodel.dart        # Estado e lógica do wizard
```

### Fluxo do Wizard:

```
┌────────────────────────────────────────────────────────────────────┐
│                    WIZARD DE CRIAÇÃO DE FICHA                      │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  PASSO 1: Selecionar Dias (33%)                                   │
│  ┌─────────────────────────────────────────┐                      │
│  │  ☐ Segunda-feira                         │                      │
│  │  ☑ Terça-feira                           │                      │
│  │  ☐ Quarta-feira                          │                      │
│  │  ☑ Quinta-feira                          │                      │
│  │  ☐ Sexta-feira                           │                      │
│  │  ☑ Sábado                                │                      │
│  │  ☐ Domingo                               │                      │
│  └─────────────────────────────────────────┘                      │
│                         │                                          │
│                         ▼                                          │
│  PASSO 2: Nomear Dias (66%)                                       │
│  ┌─────────────────────────────────────────┐                      │
│  │  Terça-feira  → [Treino A - Peito]      │                      │
│  │  Quinta-feira → [Treino B - Costas]     │                      │
│  │  Sábado       → [Treino C - Pernas]     │                      │
│  └─────────────────────────────────────────┘                      │
│                         │                                          │
│                         ▼                                          │
│  PASSO 3: Adicionar Exercícios (100%)                             │
│  ┌─────────────────────────────────────────┐                      │
│  │  [Treino A] [Treino B] [Treino C] ← Tabs│                      │
│  │  ─────────────────────────────────────  │                      │
│  │  1. Supino Reto      3x12  60kg         │                      │
│  │  2. Supino Inclinado 3x12  50kg         │                      │
│  │  3. Crucifixo        3x15  16kg         │                      │
│  │  [+ Adicionar Exercício]                │                      │
│  └─────────────────────────────────────────┘                      │
│                         │                                          │
│                         ▼                                          │
│  DIÁLOGO: Nomear Ficha                                            │
│  ┌─────────────────────────────────────────┐                      │
│  │  Nome: [Minha Ficha de Hipertrofia]     │                      │
│  │  Descrição: [Foco em ganho de massa]    │                      │
│  │              [Cancelar] [Salvar Ficha]  │                      │
│  └─────────────────────────────────────────┘                      │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘
```

### CriarFichaViewModel - Detalhamento

```dart
// Enum que define os passos do wizard
enum PassoWizard {
  selecionarDias,      // Passo 1
  nomearDias,          // Passo 2
  adicionarExercicios, // Passo 3
}

class CriarFichaViewModel extends ChangeNotifier {
  // ═══════════════════════════════════════════════════════════
  // ESTADO DO WIZARD
  // ═══════════════════════════════════════════════════════════
  
  PassoWizard _passoAtual = PassoWizard.selecionarDias;
  // Controla qual passo está sendo exibido
  
  bool _carregando = false;
  // Indica se está salvando no Firebase
  
  String? _mensagemErro;
  // Mensagem de erro para exibir ao usuário

  // ═══════════════════════════════════════════════════════════
  // PASSO 1: SELEÇÃO DE DIAS
  // ═══════════════════════════════════════════════════════════
  
  final List<bool> _diasSelecionados = List.filled(7, false);
  // Array de 7 booleanos (Seg=0, Ter=1, ..., Dom=6)
  // Ex: [false, true, false, true, false, true, false]
  //      Seg    Ter   Qua    Qui   Sex    Sab   Dom
  
  void toggleDia(int diaSemana) {
    _diasSelecionados[diaSemana] = !_diasSelecionados[diaSemana];
    notifyListeners(); // Notifica a UI para reconstruir
  }

  // ═══════════════════════════════════════════════════════════
  // PASSO 2: NOMEAÇÃO DOS DIAS
  // ═══════════════════════════════════════════════════════════
  
  final List<DiaTreinoModel> _diasTreino = [];
  // Lista de dias de treino com nome e descrição
  
  void avancarParaPasso2() {
    // Cria DiaTreinoModel para cada dia selecionado
    _diasTreino.clear();
    int ordem = 0;
    
    for (int i = 0; i < _diasSelecionados.length; i++) {
      if (_diasSelecionados[i]) {
        _diasTreino.add(
          DiaTreinoModel(
            id: 'dia_$i',
            nome: _getNomeDiaSemana(i), // "Segunda-feira", etc
            diaSemana: i,
            ordem: ordem++,
            exercicios: [],
          ),
        );
      }
    }
    
    _passoAtual = PassoWizard.nomearDias;
    notifyListeners();
  }

  // ═══════════════════════════════════════════════════════════
  // PASSO 3: ADICIONAR EXERCÍCIOS
  // ═══════════════════════════════════════════════════════════
  
  int _diaAtualIndex = 0;
  // Qual dia está selecionado nas tabs
  
  void adicionarExercicio(ExercicioModel exercicio) {
    final dia = _diasTreino[_diaAtualIndex];
    final novosExercicios = List<ExercicioModel>.from(dia.exercicios);
    
    // Define a ordem do exercício na lista
    final exercicioComOrdem = exercicio.copyWith(
      ordem: novosExercicios.length,
    );
    
    novosExercicios.add(exercicioComOrdem);
    _diasTreino[_diaAtualIndex] = dia.copyWith(exercicios: novosExercicios);
    
    notifyListeners();
  }
  
  void reordenarExercicios(int oldIndex, int newIndex) {
    // Permite drag-and-drop para reorganizar
    final dia = _diasTreino[_diaAtualIndex];
    final exercicios = List<ExercicioModel>.from(dia.exercicios);
    
    final item = exercicios.removeAt(oldIndex);
    exercicios.insert(newIndex, item);
    
    // Atualiza as ordens
    for (int i = 0; i < exercicios.length; i++) {
      exercicios[i] = exercicios[i].copyWith(ordem: i);
    }
    
    _diasTreino[_diaAtualIndex] = dia.copyWith(exercicios: exercicios);
    notifyListeners();
  }

  // ═══════════════════════════════════════════════════════════
  // SALVAR FICHA
  // ═══════════════════════════════════════════════════════════
  
  Future<bool> salvarFicha(String usuarioId) async {
    _carregando = true;
    notifyListeners();
    
    try {
      // 1. Desativa fichas anteriores do usuário
      await _fichaService.desativarTodasFichas(usuarioId);
      
      // 2. Cria o modelo da ficha
      final novaFicha = FichaModel(
        id: '',  // Firestore gera automaticamente
        usuarioId: usuarioId,
        nome: _nomeFicha,
        descricao: _descricaoFicha,
        origem: 'customizada',
        diasTreino: _diasTreino,
        ativa: true,
        dataCriacao: DateTime.now(),
      );
      
      // 3. Salva no Firestore
      await _fichaService.criarFicha(novaFicha);
      
      return true;
    } catch (e) {
      _mensagemErro = 'Erro ao salvar: $e';
      return false;
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }
  
  // ═══════════════════════════════════════════════════════════
  // UTILITÁRIOS
  // ═══════════════════════════════════════════════════════════
  
  int getProgressoPercentual() {
    switch (_passoAtual) {
      case PassoWizard.selecionarDias: return 33;
      case PassoWizard.nomearDias: return 66;
      case PassoWizard.adicionarExercicios: return 100;
    }
  }
  
  void resetar() {
    // Limpa todo o estado para criar uma nova ficha
    _passoAtual = PassoWizard.selecionarDias;
    _diasSelecionados.fillRange(0, 7, false);
    _diasTreino.clear();
    _diaAtualIndex = 0;
    _nomeFicha = '';
    notifyListeners();
  }
}
```

### CriarFichaWizardScreen - A View do Wizard

```dart
class CriarFichaWizardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Escuta mudanças no ViewModel
    final viewModel = context.watch<CriarFichaViewModel>();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Ficha Personalizada'),
        // Barra de progresso linear no bottom do AppBar
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(8),
          child: LinearProgressIndicator(
            value: viewModel.getProgressoPercentual() / 100,
          ),
        ),
      ),
      
      // Exibe o passo atual baseado no estado
      body: _buildPasso(viewModel.passoAtual),
      
      // Barra inferior com botões de navegação
      bottomNavigationBar: _buildBottomBar(context, viewModel),
    );
  }
  
  Widget _buildPasso(PassoWizard passo) {
    switch (passo) {
      case PassoWizard.selecionarDias:
        return Passo1SelecionarDias();  // Widget separado
      case PassoWizard.nomearDias:
        return Passo2NomearDias();       // Widget separado
      case PassoWizard.adicionarExercicios:
        return Passo3AdicionarExercicios(); // Widget separado
    }
  }
}
```

### Técnicas Importantes Usadas no Wizard:

#### 1. **Provider + watch/read**
```dart
// watch: Reconstrói o widget quando o estado muda
final viewModel = context.watch<CriarFichaViewModel>();

// read: Acessa sem reconstruir (para ações)
context.read<CriarFichaViewModel>().toggleDia(index);
```

#### 2. **ChoiceChip para Tabs**
```dart
ChoiceChip(
  label: Text(dia.nome),
  selected: isSelected,
  onSelected: (_) => viewModel.selecionarDia(index),
)
```

#### 3. **WillPopScope para Interceptar Voltar**
```dart
WillPopScope(
  onWillPop: () async {
    if (viewModel.passoAtual != PassoWizard.selecionarDias) {
      _mostrarDialogoVoltar(context);
      return false; // Não permite sair
    }
    return true; // Permite sair
  },
  child: Scaffold(...),
)
```

#### 4. **Padrão copyWith nos Models**
```dart
// Imutabilidade - não modifica o objeto original
final exercicioAtualizado = exercicio.copyWith(ordem: novaOrdem);
```

---

## 📦 Models (Modelos de Dados)

### FichaModel
```dart
class FichaModel {
  final String id;
  final String usuarioId;
  final String nome;
  final String? descricao;
  final String origem;           // 'customizada' ou 'pronta'
  final List<DiaTreinoModel> diasTreino;
  final bool ativa;
  final DateTime dataCriacao;
  
  // Converte de/para Map (Firestore)
  factory FichaModel.fromMap(Map<String, dynamic> map, String id);
  Map<String, dynamic> toMap();
  
  // Cria cópia com alterações (imutabilidade)
  FichaModel copyWith({...});
}
```

### Hierarquia de Dados:

```
FichaModel
    │
    └── List<DiaTreinoModel>
            │
            └── List<ExercicioModel>
                    │
                    └── List<SerieModel>
```

---

## 🔧 Services (Serviços)

Os Services são responsáveis pela comunicação com o Firebase.

### FichaService - Exemplo
```dart
class FichaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Buscar ficha ativa do usuário
  Future<FichaModel?> buscarFichaAtiva(String usuarioId) async {
    final query = await _firestore
        .collection('fichas')
        .where('usuario_id', isEqualTo: usuarioId)
        .where('ativa', isEqualTo: true)
        .limit(1)
        .get();
    
    if (query.docs.isEmpty) return null;
    return FichaModel.fromMap(query.docs.first.data(), query.docs.first.id);
  }
  
  // Criar nova ficha
  Future<String> criarFicha(FichaModel ficha) async {
    final docRef = await _firestore.collection('fichas').add(ficha.toMap());
    return docRef.id;
  }
  
  // Desativar fichas antigas (batch write)
  Future<void> desativarTodasFichas(String usuarioId) async {
    final batch = _firestore.batch();
    final fichas = await _firestore
        .collection('fichas')
        .where('usuario_id', isEqualTo: usuarioId)
        .where('ativa', isEqualTo: true)
        .get();
    
    for (var doc in fichas.docs) {
      batch.update(doc.reference, {'ativa': false});
    }
    
    await batch.commit(); // Executa todas as operações de uma vez
  }
}
```

---

## 🧠 ViewModels (Gerenciamento de Estado)

### Padrão Utilizado: ChangeNotifier + Provider

```dart
class CriarFichaViewModel extends ChangeNotifier {
  // Estado privado
  bool _carregando = false;
  
  // Getter público
  bool get carregando => _carregando;
  
  // Método que modifica estado
  void setCarregando(bool valor) {
    _carregando = valor;
    notifyListeners(); // ← Notifica a UI para reconstruir
  }
}
```

### Injeção de Dependências no main.dart:

```dart
void main() async {
  runApp(
    MultiProvider(
      providers: [
        // Cada ViewModel é registrado aqui
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => FichaViewModel()),
        ChangeNotifierProvider(create: (_) => CriarFichaViewModel()),
        // ...
      ],
      child: MaterialApp(...),
    ),
  );
}
```

---

## 🧩 Componentes Reutilizáveis (Widgets)

### BottomNavBar
```dart
class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  
  // 5 itens: Início, Fichas, Treinar (FAB), Evolução, Perfil
}
```

### CustomAppBar
```dart
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final int notificationCount;
  final VoidCallback onNotificationTap;
}
```

---

## 🔥 Integração com Firebase

### Estrutura do Firestore:

```
firestore/
├── usuarios/
│   └── {userId}/
│       ├── nome: "Lucas"
│       ├── email: "lucas@email.com"
│       ├── isAnonimo: false
│       └── dataCadastro: Timestamp
│
├── fichas/
│   └── {fichaId}/
│       ├── usuario_id: "abc123"
│       ├── nome: "Minha Ficha"
│       ├── ativa: true
│       └── dias_treino: [
│           {
│             nome: "Treino A",
│             exercicios: [...]
│           }
│       ]
│
├── treinos_realizados/
│   └── {treinoId}/
│       ├── usuario_id: "abc123"
│       ├── ficha_id: "xyz789"
│       ├── data: Timestamp
│       └── exercicios: [...]
│
└── exercicios/  (catálogo global)
    └── {exercicioId}/
        ├── nome: "Supino Reto"
        ├── grupo_muscular: "Peito"
        └── imagens: ["url1", "url2"]
```

### Firebase Storage:
```
storage/
└── exercicios/
    └── {nomeExercicio}/
        ├── 0.jpg
        ├── 1.jpg
        └── ...
```

---

## 💡 Pontos Interessantes e Técnicas Utilizadas

### 1. **Padrão Wizard com Estado Centralizado**
- O estado do wizard (passo atual, dias selecionados, exercícios) fica no ViewModel
- A View apenas lê e exibe, não mantém estado
- Permite voltar/avançar sem perder dados

### 2. **Imutabilidade com copyWith**
```dart
// Em vez de: exercicio.ordem = 5; (mutação)
// Fazemos:
final novo = exercicio.copyWith(ordem: 5); // cria novo objeto
```

### 3. **Batch Writes no Firestore**
```dart
final batch = _firestore.batch();
// Adiciona várias operações
batch.update(ref1, data1);
batch.update(ref2, data2);
// Executa todas de uma vez (atômico)
await batch.commit();
```

### 4. **Cache de Imagens**
```dart
CachedNetworkImage(
  imageUrl: exercicio.imagens.first,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
)
```

### 5. **Migração de Conta Anônima**
- Usuário pode começar anônimo (sem cadastro)
- Depois migra para conta com email
- Dados são transferidos para novo UID

### 6. **LinearProgressIndicator no AppBar**
```dart
AppBar(
  bottom: PreferredSize(
    preferredSize: Size.fromHeight(8),
    child: LinearProgressIndicator(value: 0.66),
  ),
)
```

### 7. **Tema Centralizado**
```dart
// core/theme/app_colors.dart
class AppColors {
  static const Color primary = Color(0xFF1E3A8A);
  // ...
}

// Uso:
Container(color: AppColors.primary)
```

---

## ❓ Possíveis Perguntas da Apresentação

### Sobre Arquitetura:

**P: Por que você escolheu MVVM?**
> R: MVVM separa bem as responsabilidades. A View não conhece o Firebase, o ViewModel não conhece widgets Flutter. Isso facilita manutenção e testes.

**P: O que é o Provider?**
> R: É um pacote de gerenciamento de estado recomendado pelo Flutter. Permite que widgets acessem dados sem passar por todos os níveis da árvore (evita "prop drilling").

**P: Qual a diferença entre watch e read no Provider?**
> R: `watch` faz o widget reconstruir quando o estado muda. `read` só acessa o valor sem criar dependência - útil para chamar métodos em callbacks.

### Sobre o Código:

**P: Como funciona o notifyListeners()?**
> R: Quando chamamos `notifyListeners()`, todos os widgets que usam `watch` naquele ViewModel são reconstruídos automaticamente.

**P: Por que usar copyWith nos models?**
> R: Para manter imutabilidade. Não modificamos objetos existentes, criamos novos. Isso evita bugs de estado compartilhado.

**P: Como você salva dados no Firebase?**
> R: Uso o Firestore. Converto o Model para Map com `toMap()`, salvo com `collection.add()` ou `doc.set()`, e leio convertendo de volta com `fromMap()`.

### Sobre a Tela de Fichas:

**P: Como funciona o wizard de criar ficha?**
> R: É um processo de 3 passos controlado por um enum `PassoWizard`. O ViewModel guarda qual passo está ativo e os dados de cada passo. A View só renderiza baseado no estado.

**P: Como você adiciona exercícios à ficha?**
> R: No passo 3, o usuário abre uma tela de busca, seleciona exercícios do catálogo, e eles são adicionados à lista do dia atual no ViewModel.

**P: E se o usuário voltar sem salvar?**
> R: Uso `WillPopScope` para interceptar o botão voltar e mostrar um diálogo de confirmação.

---

## 📝 Créditos

**Desenvolvido por:** Lucas de Sena  
**Disciplina:** Programação Mobile  
**Professor:** Alberto  
**Instituição:** IFMT  
**Ano:** 2025

---

## 🚀 Como Executar o Projeto

```bash
# Clone o repositório
git clone https://github.com/ifmtlucassena/gym_track.git

# Entre na pasta
cd gym_track

# Instale as dependências
flutter pub get

# Execute no Chrome (Web)
flutter run -d chrome

# Ou em um dispositivo Android/iOS
flutter run
```

### Requisitos:
- Flutter SDK 3.9.2+
- Dart SDK
- Projeto Firebase configurado (firebase_options.dart)
