import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';

class TableInfo extends Equatable {
  final int number; // 2..10
  final int progress; // 0..10

  const TableInfo({required this.number, required this.progress});

  int get index => number - AppConstants.tableMin;
  String get emoji => AppConstants.tableEmojis[index];
  Color get color => Color(AppConstants.tableColors[index]);
  bool get isCompleted => progress >= AppConstants.stepsPerTable;

  TableInfo copyWith({int? progress}) =>
      TableInfo(number: number, progress: progress ?? this.progress);

  @override
  List<Object> get props => [number, progress];
}
