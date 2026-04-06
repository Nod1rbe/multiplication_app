abstract class AppConstants {
  static const int tableMin = 2;
  static const int tableMax = 10;
  static const int stepsPerTable = 10;

  static const String prefPrefix = 'table_progress_';

  static const int optionsCount = 4;
  static const int streakStarThreshold = 3;

  static const int correctAnswerDelay = 900;
  static const int wrongAnswerResetDelay = 1400;

  static const List<String> tableEmojis = [
    '🍎',
    '🐱',
    '🌟',
    '🚀',
    '🦄',
    '🎯',
    '🌈',
    '🐘',
    '🦋',
    '🏆',
  ];

  static const List<int> tableColors = [
    0xFFFF6B6B,
    0xFFFF9F43,
    0xFFFFD93D,
    0xFF6BCB77,
    0xFF4D96FF,
    0xFF6C63FF,
    0xFFFF6BCB,
    0xFF48DBFB,
    0xFFFF9FF3,
    0xFF54A0FF,
  ];
}
