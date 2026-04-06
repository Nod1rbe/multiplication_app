import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiplication_app/di/service_locator.dart';
import 'package:multiplication_app/presentation/explore/explore_page.dart';
import 'package:multiplication_app/presentation/home/cubit/home_cubit.dart';
import 'package:multiplication_app/presentation/home/home_page.dart';
import 'package:multiplication_app/presentation/rewards/rewards_page.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const ExplorePage(),
    const RewardsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => sl<HomeCubit>()..loadTables(),
        child: Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: _pages,
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
              selectedItemColor: const Color(0xFF6C63FF),
              unselectedItemColor: Colors.grey,
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded),
                  label: 'Asosiy',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.explore_rounded),
                  label: 'O\'rganish',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.emoji_events_rounded),
                  label: 'Yutuqlar',
                ),
              ],
            ),
          ),
        ));
  }
}
