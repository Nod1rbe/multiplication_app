import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiplication_app/core/router/app_router.dart';
import 'package:multiplication_app/di/service_locator.dart';
import 'package:multiplication_app/presentation/widgets/table_card.dart';

import '../../domain/entities/table_info.dart';
import 'cubit/home_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeCubit>()..loadTables(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView>
    with SingleTickerProviderStateMixin {
  late AnimationController _titleCtrl;
  late Animation<double> _titleAnim;

  @override
  void initState() {
    super.initState();
    _titleCtrl = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _titleAnim = CurvedAnimation(parent: _titleCtrl, curve: Curves.elasticOut);
    _titleCtrl.forward();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  Future<void> _openTable(BuildContext context, TableInfo info) async {
    final cubit = context.read<HomeCubit>();
    final result = await Navigator.pushNamed(
      context,
      AppRouter.learn,
      arguments: info,
    );
    if (result is int) {
      cubit.refreshTable(info.number, result);
    } else {
      cubit.loadTables();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6C63FF), Color(0xFF3F3D56)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 30),
              ScaleTransition(
                scale: _titleAnim,
                child: Column(
                  children: [
                    const Text('🧮', style: TextStyle(fontSize: 60)),
                    const SizedBox(height: 12),
                    const Text(
                      'Ko\'paytirish Jadvali',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Qaysi jadvalni o\'rganmoqchisan? 🎉',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    if (state is HomeLoading || state is HomeInitial) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    }
                    if (state is HomeError) {
                      return Center(
                        child: Text(
                          'Xato: ${state.message}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }
                    if (state is HomeLoaded) {
                      return GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.85,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: state.tables.length,
                        itemBuilder: (context, i) {
                          final info = state.tables[i];
                          return TableCard(
                            tableInfo: info,
                            onTap: () => _openTable(context, info),
                          );
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
