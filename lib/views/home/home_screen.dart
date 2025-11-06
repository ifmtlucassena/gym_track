import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/home_viewmodel.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/motivational_card.dart';
import '../../widgets/workout_today_card.dart';
import '../../widgets/quick_stats_card.dart';
import '../auth_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authViewModel = context.read<AuthViewModel>();
      if (authViewModel.usuario != null) {
        context.read<HomeViewModel>().carregarDados(authViewModel.usuario!.id);
      }
    });
  }

  final List<Widget> _pages = [
    const InicioPage(),
    const FichasPage(),
    const SizedBox(),
    const EvolucaoPage(),
    const PerfilPage(),
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const RegistrarTreinoPage()),
      );
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class InicioPage extends StatelessWidget {
  const InicioPage({super.key});

  @override
  Widget build(BuildContext context) {
    final homeViewModel = context.watch<HomeViewModel>();
    final authViewModel = context.watch<AuthViewModel>();

    if (homeViewModel.isLoading) {
      return Scaffold(
        backgroundColor: AppColors.surface,
        appBar: CustomAppBar(
          title: 'Início',
          notificationCount: 0,
          onNotificationTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Notificações em desenvolvimento'),
                duration: Duration(seconds: 2),
              ),
            );
          },
        ),
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (homeViewModel.hasError) {
      return Scaffold(
        backgroundColor: AppColors.surface,
        appBar: CustomAppBar(
          title: 'Início',
          notificationCount: 0,
          onNotificationTap: () {},
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppColors.error,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Erro ao carregar dados',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  homeViewModel.error ?? 'Erro desconhecido',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (authViewModel.usuario != null) {
                      homeViewModel.refresh(authViewModel.usuario!.id);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  child: const Text('Tentar novamente'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: CustomAppBar(
        title: 'Início',
        notificationCount: 2,
        onNotificationTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Notificações em desenvolvimento'),
              duration: Duration(seconds: 2),
            ),
          );
        },
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          if (authViewModel.usuario != null) {
            await homeViewModel.refresh(authViewModel.usuario!.id);
          }
        },
        color: AppColors.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  60 - // altura do AppBar
                  65, // altura do BottomNavBar
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MotivationalCard(
                  frase: homeViewModel.fraseMotivacional,
                  icon: Icons.flash_on,
                ),
                const SizedBox(height: 8),
                WorkoutTodayCard(
                  treinoHoje: homeViewModel.treinoHoje,
                  hasFicha: homeViewModel.hasFicha,
                  onIniciar: () {
                    if (homeViewModel.hasFicha && homeViewModel.treinoHoje != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegistrarTreinoPage(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Criar ficha em desenvolvimento'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildQuickStats(homeViewModel),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStats(HomeViewModel viewModel) {
    if (viewModel.estadoUsuario == EstadoUsuario.ativo) {
      return Row(
        children: [
          Expanded(
            child: QuickStatsCard(
              icon: Icons.calendar_today_outlined,
              label: 'Último treino',
              value: viewModel.ultimoTreino != null
                  ? viewModel.calcularTempoRelativo(viewModel.ultimoTreino!.dataFim)
                  : '-',
              subtitle: viewModel.ultimoTreino?.nomeTreino,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: QuickStatsCard(
              icon: Icons.local_fire_department,
              iconColor: viewModel.sequenciaDias > 3
                  ? AppColors.secondary
                  : AppColors.primary,
              label: 'Sequência',
              value: viewModel.sequenciaDias > 0
                  ? '${viewModel.sequenciaDias} dias'
                  : '-',
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: QuickStatsCard(
              icon: Icons.arrow_forward,
              label: 'Próximo',
              value: viewModel.proximoTreino ?? '-',
              subtitle: viewModel.fichaAtiva?.diasTreino
                      .firstWhere(
                        (d) => d.diaSemana ==
                            (DateTime.now().weekday == 7 ? 1 : DateTime.now().weekday + 1),
                        orElse: () => viewModel.fichaAtiva!.diasTreino.first,
                      )
                      .nome ??
                  '',
            ),
          ),
        ],
      );
    } else if (viewModel.estadoUsuario == EstadoUsuario.comFichaSemTreinos) {
      return Row(
        children: [
          Expanded(
            child: QuickStatsCard(
              icon: Icons.fitness_center,
              label: 'Treinos',
              value: '0',
              subtitle: 'feitos',
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: QuickStatsCard(
              icon: Icons.assignment_outlined,
              label: 'Ficha ativa',
              value: viewModel.fichaAtiva?.nome.split(' ').take(2).join(' ') ?? '-',
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: QuickStatsCard(
              icon: Icons.rocket_launch,
              iconColor: AppColors.secondary,
              label: 'Começar',
              value: 'Hoje!',
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: QuickStatsCard(
              icon: Icons.fitness_center,
              label: 'Treinos',
              value: '0',
              subtitle: 'feitos',
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: QuickStatsCard(
              icon: Icons.description_outlined,
              label: 'Ficha',
              value: 'Nenhuma',
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: QuickStatsCard(
              icon: Icons.add_circle_outline,
              iconColor: AppColors.secondary,
              label: 'Ação',
              value: 'Criar',
            ),
          ),
        ],
      );
    }
  }
}

class FichasPage extends StatelessWidget {
  const FichasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Fichas de Treino'),
      ),
      body: const Center(
        child: Text(
          'Fichas em construção...',
          style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
        ),
      ),
    );
  }
}

class EvolucaoPage extends StatelessWidget {
  const EvolucaoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Evolução'),
      ),
      body: const Center(
        child: Text(
          'Evolução em construção...',
          style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
        ),
      ),
    );
  }
}

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();
    final usuario = authViewModel.usuario;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.primary,
              child: Text(
                usuario?.nome?.substring(0, 1).toUpperCase() ?? 'U',
                style: const TextStyle(
                  fontSize: 36,
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              usuario?.nome ?? 'Usuário',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              usuario?.email ?? '',
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () async {
                await authViewModel.logout();
                if (context.mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const AuthScreen()),
                  );
                }
              },
              icon: const Icon(Icons.logout),
              label: const Text('Sair'),
            ),
          ],
        ),
      ),
    );
  }
}

class RegistrarTreinoPage extends StatelessWidget {
  const RegistrarTreinoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Registrar Treino'),
      ),
      body: const Center(
        child: Text(
          'Registrar treino em construção...',
          style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
        ),
      ),
    );
  }
}