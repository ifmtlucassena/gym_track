import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../viewmodels/home_viewmodel.dart';
import '../../widgets/escolher_tipo_treino_modal.dart';
import 'selecionar_treino_screen.dart';

class RegistrarTreinoScreen extends StatefulWidget {
  const RegistrarTreinoScreen({super.key});

  @override
  State<RegistrarTreinoScreen> createState() => _RegistrarTreinoScreenState();
}

class _RegistrarTreinoScreenState extends State<RegistrarTreinoScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mostrarModalTipoTreino();
    });
  }

  Future<void> _mostrarModalTipoTreino() async {
    final tipoTreino = await EscolherTipoTreinoModal.show(context);

    if (tipoTreino == null) {
      if (mounted) {
        Navigator.pop(context);
      }
      return;
    }

    if (!mounted) return;

    final homeViewModel = context.read<HomeViewModel>();
    final fichaAtiva = homeViewModel.fichaAtiva;

    if (fichaAtiva == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Você precisa ter uma ficha ativa primeiro'),
            backgroundColor: AppColors.error,
          ),
        );
        Navigator.pop(context);
      }
      return;
    }

    DateTime? dataTreino;
    if (tipoTreino == 'passado') {
      dataTreino = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(const Duration(days: 90)),
        lastDate: DateTime.now(),
        locale: const Locale('pt', 'BR'),
      );

      if (dataTreino == null) {
        if (mounted) {
          Navigator.pop(context);
        }
        return;
      }
    }

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SelecionarTreinoScreen(
            ficha: fichaAtiva,
            dataTreino: dataTreino,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.surface,
      body: Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }
}
