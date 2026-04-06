import 'package:flutter/material.dart';
import '../widgets/multiplication_grid_view.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  int _row = 3;
  int _col = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('O\'rganish Markazi'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Vizual Mashq',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Bloklarni sanash orqali ko\'paytirishni tushunib ol!',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _NumberPicker(
                    label: 'Qator',
                    value: _row,
                    onChanged: (v) => setState(() => _row = v),
                  ),
                  const SizedBox(width: 20),
                  const Text('×', style: TextStyle(fontSize: 30)),
                  const SizedBox(width: 20),
                  _NumberPicker(
                    label: 'Ustun',
                    value: _col,
                    onChanged: (v) => setState(() => _col = v),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        '$_row × $_col = ${_row * _col}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6C63FF),
                        ),
                      ),
                      const SizedBox(height: 20),
                      MultiplicationGridView(
                        rows: _row,
                        cols: _col,
                        emoji: '🍎',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NumberPicker extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  const _NumberPicker({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Row(
          children: [
            IconButton(
              onPressed: value > 1 ? () => onChanged(value - 1) : null,
              icon: const Icon(Icons.remove_circle_outline),
            ),
            Text('$value',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            IconButton(
              onPressed: value < 10 ? () => onChanged(value + 1) : null,
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
      ],
    );
  }
}
