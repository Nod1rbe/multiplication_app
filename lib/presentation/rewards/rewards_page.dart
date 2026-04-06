import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiplication_app/presentation/home/cubit/home_cubit.dart';

class RewardsPage extends StatelessWidget {
  const RewardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mening Mukofotlarim'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is! HomeLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          final tables = state.tables;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Stikerlar To\'plami',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Har bir jadvalni a\'lo topshirib, yangi hayvoncha stikerini yutib ol!',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: tables.length,
                    itemBuilder: (context, index) {
                      final info = tables[index];
                      final bool isUnlocked = info.isCompleted;

                      return Container(
                        decoration: BoxDecoration(
                          color: isUnlocked
                              ? info.color.withOpacity(0.2)
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color:
                                isUnlocked ? info.color : Colors.grey.shade300,
                            width: 2,
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Text(
                              info.emoji,
                              style: TextStyle(
                                fontSize: 40,
                                color: Colors.black
                                    .withOpacity(isUnlocked ? 1.0 : 0.2),
                              ),
                            ),
                            if (!isUnlocked)
                              const Icon(Icons.lock_rounded,
                                  color: Colors.grey, size: 24),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
