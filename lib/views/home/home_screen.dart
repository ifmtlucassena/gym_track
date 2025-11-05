import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../auth_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

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
    final authViewModel = context.watch<AuthViewModel>();
    final usuario = authViewModel.usuario;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Início'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authViewModel.logout();
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const AuthScreen()),
                );
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.fitness_center,
                size: 60,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Bem-vindo${usuario?.nome != null ? ', ${usuario!.nome}' : ''}!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Dashboard em construção...',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
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